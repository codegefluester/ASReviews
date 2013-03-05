//
//  ReviewDetailViewController.h
//  App Store Reviews
//
//  Created by Björn Kaiser on 05.03.13.
//  Copyright (c) 2013 Björn Kaiser. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Review.h"

@interface ReviewDetailViewController : UIViewController {
    Review *theReview;
}

@property (strong) Review *theReview;

- (void) closeView;

@end
