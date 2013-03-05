ASReviews
=========
A small helper to fetch reviews for iOS/Mac OS X Apps from the App Store.

Features
=========
- Fetch reviews for an iOS/Mac App
- Calculate average rating based on fetched reviews
- Filter positive/negative/neutral reviews

TODOs
=========
- Implement caching
- Implement method to fetch all available pages at once


Usage
=========
A sample project is included, but in case you want to start right away, add the following files 
from the sample project to your project:

- ASReviews.h/.m
- Review.h/.m


## Fetch reviews from a specific page
This sample will fetch the 50 latest reviews for the Facebook iOS App from the US App Store
```objc
ASReviews *asr = [ASReviews instance];
[asr setAppId:@"284882215"];
[asr setCountryIdentifier:@"us"];

[asr fetchReviewsFromPage:1 onComplete:^(NSArray *reviews, int page) {
    NSLog(@"Reviews: %@", reviews);
} onError:^(NSError *error, int page) {
    NSLog(@"Failed to fetch reviews on page %i: %@", page, error.description);
}];
```

## Fetch all available reviews at once
This sample will fetch all available reviews for the Facebook iOS App from the US App Store
```objc
ASReviews *asr = [ASReviews instance];
[asr setAppId:@"284882215"];
[asr setCountryIdentifier:@"us"];

[asr fetchAllReviews:^(NSArray *reviews, int lastFetchedPage) {
    NSLog(@"Average rating: %.2f based on %i reviews", [asr averageRatingForVersion:nil], reviews.count);
}];
```

## Filter reviews
This sample will fetch the latest 50 reviews and filters out negative reviews (1 and 2 star reviews)
```objc
ASReviews *asr = [ASReviews instance];
[asr setAppId:@"284882215"];
[asr setCountryIdentifier:@"us"];

[asr fetchReviewsFromPage:1 onComplete:^(NSArray *reviews, int page) {
    NSLog(@"Negative reviews: %@", [asr negativeReviews]);
    //NSLog(@"Positive reviews: %@", [asr positiveReviews]);
    //NSLog(@"Neutral reviews: %@", [asr neutralReviews]);
} onError:^(NSError *error, int page) {
    NSLog(@"Failed to fetch reviews on page %i: %@", page, error.description);
}];
```

## Check if a review is positive, negative or neutral
If you're displaying reviews in a `UITableView` you might want to adjust the `UITableViewCell`s appearance
accordingly. Each review object has 3 methods to check wether it is a positive, negative or neutral review.
```objc
ASReviews *asr = [ASReviews instance];
[asr setAppId:@"284882215"];
[asr setCountryIdentifier:@"us"];

[asr fetchReviewsFromPage:1 onComplete:^(NSArray *reviews, int page) {
    for(Review *review in reviews) {
        if([review isPositive]) NSLog(@"Positive review");
        
        if([review isNegative]) NSLog(@"Negative review");
        
        if([review isNeutral]) NSLog(@"Neutral review");
    }
} onError:^(NSError *error, int page) {
    NSLog(@"Failed to fetch reviews on page %i: %@", page, error.description);
}];
```

License
=========
This code is licensed under my very own and special "Do whatever you want with it" license.
