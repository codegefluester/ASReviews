//
//  DemoViewController.h
//  App Store Reviews
//
//  Created by Björn Kaiser on 02.03.13.
//  Copyright (c) 2013 Björn Kaiser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ASReviews.h"
#import "ReviewDetailViewController.h"

@interface DemoViewController : UITableViewController

@property (strong) ASReviews *asReviews;
@property (strong) NSMutableArray *reviews;

- (void) loadReviews;

@end
