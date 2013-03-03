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

static ASReviews *_sharedInstance = nil;

+ (ASReviews*) instance
{
    
    if (_sharedInstance == nil) {
        _sharedInstance = [[ASReviews alloc] init];
        _sharedInstance.countryIdentifier = @"de";
        _sharedInstance.reviews = [[NSMutableArray alloc] initWithCapacity:0];
    }
    
    return _sharedInstance;
}

/**
 *  Fetches all reviews on the page and calls the completionHandler
 *  when all data has been pulled from Apple servers.
 *
 *  Regardless of the pages listed in the response, 10 seems to be the last page that is fetchable,
 *  everything above 10 returns a server error.
 *
 *  @param int page The page to fetch (1-10)
 *  @param block The completion handler
 *  @return void
 **/
- (void) fetchReviewsFromPage:(int)page onComplete:(void(^)(NSArray *reviews, int page))completionHandler onError:(void (^)(NSError *error, int page))errorHandler
{
    NSAssert(self.appId != nil, @"App ID should not be nil");
    
    if(page > 10) page = 10;
    
    NSURL *reviewUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://itunes.apple.com/%@/rss/customerreviews/page=%i/id=%@/sortBy=mostRecent/json", self.countryIdentifier, page, self.appId]];
    
    NSLog(@"Fetching reviews for app %@", self.appId);
    
    [NSURLConnection sendAsynchronousRequest:[NSURLRequest requestWithURL:reviewUrl] queue:[NSOperationQueue mainQueue] completionHandler:^(NSURLResponse *response, NSData *responseData, NSError *responseError) {
        if (responseError == nil) {
            NSDictionary *reviewData = [NSJSONSerialization JSONObjectWithData:responseData options:NSJSONReadingMutableLeaves error:nil];
            
            //NSLog(@"Raw: %@", reviewData);
            
            if ([reviewData objectForKey:@"feed"] != nil && [[reviewData objectForKey:@"feed"] objectForKey:@"entry"] != nil) {
                NSMutableArray *tmp = [NSMutableArray arrayWithArray:[[reviewData objectForKey:@"feed"] objectForKey:@"entry"]];
                if([tmp count] > 0) [tmp removeObjectAtIndex:0];
                
                if ([tmp count] > 0) {
                    for (NSDictionary *review in tmp) {
                        Review *aReview = [[Review alloc] init];
                        [aReview setAuthor:[[[review objectForKey:@"author"] objectForKey:@"name"] objectForKey:@"label"]];
                        [aReview setContent:[[review objectForKey:@"content"] objectForKey:@"label"]];
                        [aReview setRating:[[review objectForKey:@"im:rating"] objectForKey:@"label"]];
                        [aReview setAppVersion:[[review objectForKey:@"im:version"] objectForKey:@"label"]];
                        [aReview setTitle:[[review objectForKey:@"title"] objectForKey:@"label"]];
                        [self.reviews addObject:aReview];
                    }
                }
            }
            
            if (completionHandler != nil) {
                completionHandler(self.reviews, page);
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

- (NSArray*) reviewsForVersion:(NSString*)appVersion
{
	return [self.reviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"appVersion = %@", appVersion]];
}

- (NSArray*) negativeReviews
{
	return [self.reviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"rating = %@ OR rating = %@", @"1", @"2"]];
}

- (NSArray*) neutralReviews
{
	return [self.reviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"rating = %@", @"3"]];
}

- (NSArray*) positiveReviews
{
	return [self.reviews filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"rating = %@ OR rating = %@", @"4", @"5"]];
}


@end
