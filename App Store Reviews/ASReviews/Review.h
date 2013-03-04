//
//  Review.h
//  App Store Reviews
//
//  Created by Björn Kaiser on 02.03.13.
//  Copyright (c) 2013 Björn Kaiser. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Review : NSObject {
    NSDictionary *raw;
    
    NSString *author;
    NSString *content;
    NSString *title;
    NSString *appVersion;
    NSString *rating;
    NSString *reviewId;
}

@property (strong) NSString *author;
@property (strong) NSString *content;
@property (strong) NSString *title;
@property (strong) NSString *appVersion;
@property (strong) NSString *rating;
@property (strong) NSString *reviewId;

- (CGSize) textDimensionsConstrainedToSize:(CGSize)theSize withFont:(UIFont*)theFont;

- (BOOL) isNegativeReview;
- (BOOL) isPositiveReview;
- (BOOL) isNeutralReview;


@end
