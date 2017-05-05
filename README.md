# Tamber iOS SDK

Recommendation engines for developers, easy as π. Build blazing fast, head-scratchingly accurate hosted recommendation engines in minutes.

The Tamber iOS SDK makes it easy to track events (user-item interactions) and get recommendations for your users inside your iOS app. 

[Get a free api key][homepage] to get started.

## Requirements

Our SDK is compatible with iOS 8.0 and above. It requires Xcode 8.0+ to build the source.

## Documentation

This README covers the basics of using the Tamber iOS SDK. Check out the [documentation][ios-docs] for a comprehensive look at the classes and methods.

## Installation

Install Tamber with [CocoaPods][install-cocoa-pods]. If you do not yet have a Podfile for your project, `$ cd` into your project directory and run `$ pod init`.

Add this line to your Podfile:

```
pod 'Tamber'
```

Then, run the following command:

```
$ pod install
```

## Usage

If you are just getting started, check out the [Quick Start][quickstart] guide for instructions on how to get setup.

To begin tracking events, set your publishable project key. If you have already begun tracking real time events and have created an engine, you should also set your engine key so you can retrieve recommendations.

```
#import "AppDelegate.h"
@import Tamber;

@implementation AppDelegate
- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
	[Tamber setPublishableProjectKey:@"your_project_key"];
	// If you have an engine use:
    [Tamber setPublishableProjectKey:@"your_project_key" publishableEngineKey:@"your_engine_key"];
    // do any other necessary launch configuration
    return YES;
}
@end
```

### Set User

Set the User wherever you load your user's unique ID from your backend, or wherever you load user ids from.

```
[Tamber setUser:@"user_id"];
```

### Track Events

Stream events to your Tamber project as the user interacts with items in your app.

```
TMBEventParams *params = [TMBEventParams eventWithItem:@"item_id" behavior:@"like"];
[[Tamber client] trackEvent:params responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSString *errorMessage) {
    if(errorMessage){
    	// Handle error
    } else {
    	object.events[0] // Event tracked
    	object.recs // Returns updated recommendations if params.getRecs is set - [params setGetRecs:<TMBDiscoverParams>]
	}
}];
```

### Get Recommendations

Once you have seeded some events and created your engine, you can start pulling user recommendations into your app.

```
TMBDiscoverParams *params = [TMBDiscoverParams discoverRecommendations:[NSNumber numberWithInt:50]];
[[Tamber client] discoverRecommendations:params responseCompletion:^(TMBDiscoverResponse *object, NSHTTPURLResponse *response, NSString *errorMessage) {
    if(errorMessage){
    	// Handle error
    } else {
    	for(TMBDiscovery *discovery in object.discoveries){
    		discovery.item // Recommended item id
    		discovery.score // Recommendation score (relative to other results, not a predicted rating)
    	}
	}
}];
```

If you are setting [properties for your items][properties] from your backend, you can include these properties in recommendation responses to simplify data handling. For example, you might have `title`, `img`, and `price` properties that you can use to display items to users without needing to make an additional request for each recommendation.

```
TMBDiscoverParams *params = [TMBDiscoverParams alloc] discoverRecommendations:[NSNumber numberWithInt:50] page:nil filter:nil getProperties:true testEvents:nil];
[[Tamber client] discoverRecommendations:params responseCompletion:^(TMBDiscoverResponse *object, NSHTTPURLResponse *response, NSString *errorMessage) {
    if(errorMessage){
    	// Handle error
    } else {
    	for(TMBDiscovery *discovery in object.discoveries){
    		discovery.item // Recommended item id
    		discovery.score // Recommendation score (relative to other results, not a predicted rating)
    		discovery.properties // Dictionary of item properties
    	}
	}
}];
```

If your app allows users to interact with content before creating an account, or otherwise establishing a unique identifier, and you can want to get recommendations for these un-initialized users, you can do so by setting `testEvents` to an array of `TMBEvent` objects. Retrieving recommendations with `testEvents` set will return a list of simulated recommendations given the series of Events, but does not write anything to your project or engine.


[install-cocoa-pods]: https://guides.cocoapods.org/using/getting-started.html
[ios-docs]: http://tamber.github.io/tamber-ios/docs/index.html
[quickstart]: https://tamber.com/docs/start/
[dataset]: https://tamber.com/docs/start/#upload-history
[proeprties]: https://tamber.com/docs/guides/filtering.html
[homepage]: https://tamber.com/
[docs]: https://tamber.com/docs/
[dashboard]: https://dashboard.tamber.com/