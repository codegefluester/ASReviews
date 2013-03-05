//
//  ReviewDetailViewController.m
//  App Store Reviews
//
//  Created by Björn Kaiser on 05.03.13.
//  Copyright (c) 2013 Björn Kaiser. All rights reserved.
//

#import "ReviewDetailViewController.h"

@interface ReviewDetailViewController ()

@end

@implementation ReviewDetailViewController

@synthesize theReview;

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    
    UITextView *textView = [[UITextView alloc] initWithFrame:self.view.frame];
    [textView setEditable:NO];
    [textView setText:[NSString stringWithFormat:@"%@ by %@\n%@ stars\n%@", self.theReview.title, self.theReview.author, self.theReview.rating, self.theReview.content]];
    [self.view addSubview:textView];
    
    UIButton *closeBtn = [[UIButton alloc] initWithFrame:CGRectMake(10, self.view.frame.size.height - 50, self.view.frame.size.width-20, 40)];
    [closeBtn setTitle:@"Close" forState:UIControlStateNormal];
    [closeBtn setBackgroundColor:[UIColor darkGrayColor]];
    [closeBtn addTarget:self action:@selector(closeView) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:closeBtn];
}

- (void) closeView
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
