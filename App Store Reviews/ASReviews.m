//
//  ASReviews.m
//  App Store Reviews
//
//  Created by Björn Kaiser on 02.03.13.
//  Copyright (c) 2013 Björn Kaiser. All rights reserved.
//

#import "ASReviews.h"

@implementation ASReviews

@synthesize appId;
@synthesize countryIdentifier;
@synthesize reviews;
@synthesize appName;
@synthesize iconUrl;
@synthesize appCategory;
@synthesize lastPage;
@synthesize availableVersions;

static ASReviews *_sharedInstance = nil;

+ (ASReviews*) instance
{
    
    if (_sharedInstance == nil) {
        _sharedInstance = [[ASReviews alloc] init];
        _sharedInstance.countryIdentifier = @"us";
        _sharedInstance.reviews = [[NSMutableArray alloc] initWithCapacity:0];
        _sharedInstance.lastPage = 1;
        _sharedInstance.availableVersions = [[NSMutableSet alloc] initWithCapacity:0];
    }
    
    return _sharedInstance;
}

/**
 *  Fetches all reviews on the page and calls the completionHandler
 *  when all data has been pulled from Apple servers.
 *
 *  Regardless of the pages listed in the response, page 10 seems 
 *  to be the last page that is fetchable. 
 *  Everything above 10 returns a server error.
 *
 *  @param int page The page to fetch (1-10)
 *  @param block The completion handler
 *  @return void
 **/
- (void) fetchReviewsFromPage:(int)page onComplete:(void(^)(NSArray *reviews, int page))completionHandler onError:(void (^)(NSError *error, int page))errorHandler
{
    NSAssert(self.appId != nil, @"App ID should not be nil");
    
    NSURL *reviewUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/%@/rss/customerreviews/page=%i/id=%@/sortBy=mostRecent/json", self.countryIdentifier, page, self.appId]];
    
    NSLog(@"Fetching reviews for app %@", self.appId);
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:reviewUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *responseError) {
        
        if (responseError == nil) {            
            NSDictionary *reviewData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            NSMutableArray *fetchedReviews = [[NSMutableArray alloc] initWithCapacity:0];
            
            if ([reviewData objectForKey:@"feed"] != nil && [[reviewData objectForKey:@"feed"] objectForKey:@"entry"] != nil) {
                NSMutableArray *tmp = nil;
                if([[[reviewData objectForKey:@"feed"] objectForKey:@"entry"] isKindOfClass:[NSArray class]]) {
                    tmp = [NSMutableArray arrayWithArray:[[reviewData objectForKey:@"feed"] objectForKey:@"entry"]];
                }
                
                self.appName = [[[tmp objectAtIndex:0] objectForKey:@"im:name"] objectForKey:@"label"];
                self.appCategory = [[[[tmp objectAtIndex:0] objectForKey:@"category"] objectForKey:@"attributes"] objectForKey:@"label"];
                self.iconUrl = [[[[tmp objectAtIndex:0] objectForKey:@"im:image"] lastObject] objectForKey:@"label"];
                
                if([tmp count] > 0) [tmp removeObjectAtIndex:0];
                
                if ([tmp count] > 0) {
                    for (NSDictionary *review in tmp) {
                        Review *aReview = [[Review alloc] init];
                        [aReview setAuthor:[[[review objectForKey:@"author"] objectForKey:@"name"] objectForKey:@"label"]];
                        [aReview setContent:[[review objectForKey:@"content"] objectForKey:@"label"]];
                        [aReview setRating:[[review objectForKey:@"im:rating"] objectForKey:@"label"]];
                        [aReview setAppVersion:[[review objectForKey:@"im:version"] objectForKey:@"label"]];
                        [aReview setTitle:[[review objectForKey:@"title"] objectForKey:@"label"]];
                        [aReview setReviewId:[[review objectForKey:@"id"] objectForKey:@"label"]];
                        [fetchedReviews addObject:aReview];
                        [self.reviews addObject:aReview];
                        [self.availableVersions addObject:aReview.appVersion];
                    }
                }
            }
            
            if (completionHandler != nil) {
                completionHandler(fetchedReviews, page);
            }
            
        } else {
            if (errorHandler != nil) {
                errorHandler(responseError, page);
            } else {
                NSLog(@"Error: %@", responseError.description);
            }
        }
    }];
}

/**
 *  Fetches all available reviews at once
 *
 *  @param block The completion handler to execute when loading is finished
 *  @return void
 **/
- (void) fetchAllReviews:(void (^)(NSArray *reviews, int lastFetchedPage))completionHandler
{
    [self fetchReviewsFromPage:self.lastPage onComplete:^(NSArray *list, int page) {
        if(list.count > 0) {
            self.lastPage++;
            [self fetchAllReviews:completionHandler];
        } else {
            if (completionHandler != nil) {
                completionHandler(self.reviews, self.lastPage);
            } else {
                NSLog(@"Fetched %i reviews, last page was %i", self.reviews.count, page);
            }
        }
    } onError:^(NSError *error, int page) {
        NSLog(@"Error while fetching page %i: %@", page, error.description);
    }];
}

/**
 *  Returns reviews for a specific version of the app
 *
 *  @param NSString The version string
 *  @return NSArray An array of reviews
 **/
- (NSArray*) reviewsForVersion:(NSString*)appVersion
{
	return [self.reviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"appVersion = %@", appVersion]];
}

/**
 *  Returns all negative reviews of the app
 *
 *  @return NSArray An array of reviews
 **/
- (NSArray*) negativeReviews
{
	return [self.reviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"rating = %@ OR rating = %@", @"1", @"2"]];
}

/**
 *  Returns all neutral reviews of the app
 *
 *  @return NSArray An array of reviews
 **/
- (NSArray*) neutralReviews
{
	return [self.reviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"rating = %@", @"3"]];
}

/**
 *  Returns all positive reviews of the app
 *
 *  @return NSArray An array of reviews
 **/
- (NSArray*) positiveReviews
{
	return [self.reviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"rating = %@ OR rating = %@", @"4", @"5"]];
}

/**
 *  Returns the average rating for a specific version
 *  of the app. If appVersion is nil, it will return
 *  an average rating for all versions
 *
 *  @param NSString The version string
 *  @return NSArray An array of reviews
 **/
- (float) averageRatingForVersion:(NSString*)appVersion
{
	float avg = 0.0;
	
	NSArray *versionReviews = nil;
    if(appVersion != nil) versionReviews = [self reviewsForVersion:appVersion];
    else versionReviews = self.reviews;
	
	if ([versionReviews count] > 0) {
		for (Review *review in versionReviews) {
			avg += [[review rating] floatValue];
		}
        
        return (avg / [versionReviews count]);
    }
    
    return avg;
}

/**
 *  Returns a list of versions we have fetched
 *  reviews for
 *
 *  @return NSArray A list of version strings
 **/
- (NSArray*) versions
{
    return [self.availableVersions allObjects];
}


@end
