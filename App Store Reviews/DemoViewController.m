//
//  DemoViewController.m
//  App Store Reviews
//
//  Created by Björn Kaiser on 02.03.13.
//  Copyright (c) 2013 Björn Kaiser. All rights reserved.
//

#import "DemoViewController.h"

@interface DemoViewController ()

@end

@implementation DemoViewController

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.reviews = [[NSMutableArray alloc] init];
    self.pageToFetch = 1;
    self.isFetching = NO;
    
    self.asReviews = [ASReviews instance];
    [self.asReviews setAppId:@"284882215"];
    [self.asReviews setCountryIdentifier:@"us"];
    
    [self loadReviews];
}

- (void) loadReviews
{
    self.isFetching = YES;
    [self.asReviews fetchReviewsFromPage:self.pageToFetch onComplete:^(NSArray *reviews, int page) {
        NSLog(@"Found %i reviews on page %i", [reviews count], page);
        [self.reviews removeAllObjects];
        [self.reviews addObjectsFromArray:reviews];
        [self.tableView reloadData];
		self.isFetching = NO;
		NSLog(@"Average rating: %.2f", [self.asReviews averageRatingForVersion:nil]);
    } onError:^(NSError *error, int page) {
        NSLog(@"Failed to fetch reviews on page %i: %@", page, error.description);
        self.isFetching = NO;
    }];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return [self.reviews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    Review *current = [self.reviews objectAtIndex:indexPath.row];
    cell.textLabel.text = [current title];
    cell.detailTextLabel.text = [current content];
    
    if ([current isPositiveReview]) {
        cell.textLabel.textColor = [UIColor greenColor];
    } else if([current isNegativeReview]) {
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        cell.textLabel.textColor = [UIColor yellowColor];
    }
    
    return cell;
}

// http://stackoverflow.com/a/5627837/515042
- (void)scrollViewDidScroll:(UIScrollView *)aScrollView {
    CGPoint offset = aScrollView.contentOffset;
    CGRect bounds = aScrollView.bounds;
    CGSize size = aScrollView.contentSize;
    UIEdgeInsets inset = aScrollView.contentInset;
    float y = offset.y + bounds.size.height - inset.bottom;
    float h = size.height;
    // NSLog(@"offset: %f", offset.y);
    // NSLog(@"content.height: %f", size.height);
    // NSLog(@"bounds.height: %f", bounds.size.height);
    // NSLog(@"inset.top: %f", inset.top);
    // NSLog(@"inset.bottom: %f", inset.bottom);
    // NSLog(@"pos: %f of %f", y, h);
    
    float reload_distance = 10;
    if(y > h + reload_distance) {
        if(self.pageToFetch < 10 && !self.isFetching) {
            // Load more reviews
            self.pageToFetch++;
            [self loadReviews];
        }
    }
}

@end
