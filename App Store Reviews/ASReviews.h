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
    NSString *appId;
    NSString *countryIdentifier;
    NSMutableArray *reviews;
    
    int lastPage;
}

@property (strong) NSString *appId;
@property (strong) NSString *countryIdentifier;
@property (strong) NSMutableArray *reviews;

+ (ASReviews*) instance;

- (void) fetchReviewsFromPage:(int)page onComplete:(void(^)(NSArray *reviews, int page))completionHandler onError:(void(^)(NSError *error, int page))errorHandler;

/**
 *	Convenience methods
 **/
- (NSArray*) reviewsForVersion:(NSString*)appVersion;
- (NSArray*) negativeReviews;
- (NSArray*) positiveReviews;
- (NSArray*) neutralReviews;
- (float) averageRatingForVersion:(NSString*)appVersion;

@end
