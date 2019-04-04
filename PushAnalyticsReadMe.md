### Push Notification Analytics

In order for your Tamber engine to learn to optimize push notifications, it must be able to evaluate push notification performance. There are 3 reserved events that enable this: `tmb_session_started`, `tmb_session_ended`, and `tmb_push_rendered`. If you are using Tamber in conjunction with another Push Notification system, include the context key-value pair `{ @"source": @"tmb_push" }` in the `pushRendered` event object to ensure correct behavior.

```objc
// At app launch / wherever appropriate in your code 
[Tamber setUser:@"user-id"];

[[Tamber client] trackEvent:[TMBEventParams sessionStarted] responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
    if(error){
            // handle error
    }
}];

// At app close / wherever appropriate in your code 
[[Tamber client] trackEvent:[TMBEventParams sessionEnded] responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
    if(error){
            // handle error
    }
}];
```

Use `pushRendered` to track when a notification is displayed to the user.

```objc
// At app launch / wherever appropriate in your code 
[Tamber setUser:@"user-id"];

[[Tamber client] trackEvent:[TMBEventParams pushRendered:@[@"tmb_push"] created:nil] responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
    if(error){
            // handle error
    }
}];
```
