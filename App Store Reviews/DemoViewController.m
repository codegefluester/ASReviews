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
    self.asReviews = [ASReviews instance];
    [self.asReviews setAppId:@"284882215"];
    [self.asReviews setCountryIdentifier:@"us"];
    
    [self loadReviews];
}

- (void) loadReviews
{
    /*[self.asReviews fetchAllReviews:^(NSArray *reviews, int lastFetchedPage) {
        self.reviews = [[NSMutableArray alloc] initWithArray:reviews];
        [self.tableView reloadData];
        NSLog(@"Average rating: %.2f based on %i reviews", [self.asReviews averageRatingForVersion:nil], reviews.count);
    }];*/
    
    [self.asReviews fetchReviewsFromPage:1 onComplete:^(NSArray *reviews, int page) {
        NSLog(@"Found %i reviews on page %i", [reviews count], page);
        [self.reviews removeAllObjects];
        [self.reviews addObjectsFromArray:reviews];
        [self.tableView reloadData];
		NSLog(@"Average rating: %.2f", [self.asReviews averageRatingForVersion:nil]);
    } onError:^(NSError *error, int page) {
        NSLog(@"Failed to fetch reviews on page %i: %@", page, error.description);
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
    cell.textLabel.text = [NSString stringWithFormat:@"%@S / %@", current.rating, [current title]];
    cell.detailTextLabel.text = [current content];
    
    if ([current isPositiveReview]) {
        cell.textLabel.textColor = [UIColor greenColor];
    } else if([current isNegativeReview]) {
        cell.textLabel.textColor = [UIColor redColor];
    } else {
        cell.textLabel.textColor = [UIColor orangeColor];
    }
    
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    
    return cell;
}

- (void) tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    ReviewDetailViewController *detailVC = [[ReviewDetailViewController alloc] init];
    [detailVC setTheReview:[self.reviews objectAtIndex:indexPath.row]];
    [self presentViewController:detailVC animated:YES completion:nil];
}

@end
