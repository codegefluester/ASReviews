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
}

@property (strong) NSString *author;
@property (strong) NSString *content;
@property (strong) NSString *title;
@property (strong) NSString *appVersion;
@property (strong) NSString *rating;

- (CGSize) textDimensionsConstrainedToSize:(CGSize)theSize withFont:(UIFont*)theFont;

@end
