ASReviews
=========

A small helper to fetch reviews for iOS/Mac OS X Apps from the App Store

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


## Fetch reviews
This sample will fetch the 50 latest reviews for the Facebook iOS App from the US App Store
```
  ASReviews *asr = [ASReviews instance];
  [asr setAppId:@"284882215"];
  [asr setCountryIdentifier:@"us"];
  
  [asr fetchReviewsFromPage:1 onComplete:^(NSArray *reviews, int page) {
        NSLog(@"Reviews: %@", reviews);
    } onError:^(NSError *error, int page) {
        NSLog(@"Failed to fetch reviews on page %i: %@", page, error.description);
  }];  
}
```

## Filter reviews
This sample will fetch the latest 50 reviews and filter out negative reviews (1 and 2 star reviews)
```
  // .. setup ASReviews (see above sample) ...
  [asr fetchReviewsFromPage:1 onComplete:^(NSArray *reviews, int page) {
        NSLog(@"Negative reviews: %@", [asr negativeReviews]);
        //NSLog(@"Positive reviews: %@", [asr positiveReviews]);
        //NSLog(@"Neutral reviews: %@", [asr neutralReviews]);
    } onError:^(NSError *error, int page) {
        NSLog(@"Failed to fetch reviews on page %i: %@", page, error.description);
  }];  
}
```

License
=========
This code is licensed under my very own and special "Do whatever you want with it" license.
