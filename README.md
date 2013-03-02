ASReviews
=========

A small helper to fetch reviews for iOS Apps from the App Store

Usage
=========
Add the following files to your project:
- ASReviews.h/.m
- Review.h/.m

```
#import "ASReviews.h"

@implementation YourViewController

- (void) viewDidLoad
{
  [super viewDidLoad]
  
  ASReviews *asr = [ASReviews instance];
  // Set the ID of your app. If you don't know it, look it up in iTunes Connect
  [asr setAppId:@"YOUR_APPS_ID"];
  
  // Set the country for which you want to get the reviews for (us = United States)
  [asr setCountryIdentifier:@"us"];
  
  /**
  * Fetch the reviews
  **/
  [asr fetchReviewsFromPage:1 onComplete:^(NSArray *reviews, int page) {
        NSLog(@"Found %i reviews on page %i", [reviews count], page);
        NSLog(@"Reviews: %@", reviews);
    } onError:^(NSError *error, int page) {
        NSLog(@"Failed to fetch reviews on page %i: %@", page, error.description);
  }];
  
}

@end


```
