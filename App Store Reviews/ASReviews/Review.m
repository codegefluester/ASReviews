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

@end
