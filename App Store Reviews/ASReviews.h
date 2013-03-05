//
//  ASReviews.h
//  App Store Reviews
//
//  Created by Björn Kaiser on 02.03.13.
//  Copyright (c) 2013 Björn Kaiser. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Review.h"

@interface ASReviews : NSObject {
    NSString *appName;
    NSString *iconUrl;
    NSString *appCategory;
    NSString *appId;
    NSString *countryIdentifier;
    NSMutableArray *reviews;
    
    int lastPage;
}

@property (strong) NSString *appId;
@property (strong) NSString *countryIdentifier;
@property (strong) NSMutableArray *reviews;
@property (strong) NSString *appName;
@property (strong) NSString *iconUrl;
@property (strong) NSString *appCategory;
@property (strong) NSMutableSet *availableVersions;
@property int lastPage;

+ (ASReviews*) instance;

- (void) fetchReviewsFromPage:(int)page onComplete:(void(^)(NSArray *reviews, int page))completionHandler onError:(void(^)(NSError *error, int page))errorHandler;
- (void) fetchAllReviews:(void (^)(NSArray *reviews, int lastFetchedPage))completionHandler;

/**
 *	Convenience methods
 **/
- (NSArray*) reviewsForVersion:(NSString*)appVersion;
- (NSArray*) negativeReviews;
- (NSArray*) positiveReviews;
- (NSArray*) neutralReviews;
- (float) averageRatingForVersion:(NSString*)appVersion;
- (NSArray*) versions;

@end
