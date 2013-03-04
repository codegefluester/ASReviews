//
//  Review.m
//  App Store Reviews
//
//  Created by Björn Kaiser on 02.03.13.
//  Copyright (c) 2013 Björn Kaiser. All rights reserved.
//

#import "Review.h"

@implementation Review

@synthesize title;
@synthesize author;
@synthesize appVersion;
@synthesize content;
@synthesize rating;

- (NSString*) description
{
    return [NSString stringWithFormat:@"Author: %@ Title: %@ Content: %@ Version: %@ Stars: %@", self.author, self.title, self.content, self.appVersion, self.rating];
}

- (CGSize) textDimensionsConstrainedToSize:(CGSize)theSize withFont:(UIFont*)theFont
{
    return [self.content sizeWithFont:theFont constrainedToSize:theSize lineBreakMode:NSLineBreakByWordWrapping];
}

- (BOOL) isNegativeReview
{
    return ([self.rating isEqualToString:@"1"] || [self.rating isEqualToString:@"2"]);
}

- (BOOL) isPositiveReview
{
    return ([self.rating isEqualToString:@"4"] || [self.rating isEqualToString:@"5"]);
}

- (BOOL) isNeutralReview
{
    return [self.rating isEqualToString:@"3"];
}

@end
