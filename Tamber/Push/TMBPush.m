//
//  TMBPush.m
//  Tamber
//
//  Created by Alexander Robbins on 10/14/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBPush.h"
@import UserNotifications;

typedef void (*didRegisterForRemoteNotificationsWithDeviceTokenImplSignature)(__strong id,SEL,UIApplication *, NSData*);
typedef void (*didFailToRegisterForRemoteNotificationsWithErrorImplSignature)(__strong id,SEL,UIApplication *, NSError*);
typedef void (*didReceiveRemoteNotificationImplSignature)(__strong id,SEL,UIApplication *, NSDictionary*, void (^)(UIBackgroundFetchResult result));

static bool swizzled = false;

@interface TMBPush() {
    didRegisterForRemoteNotificationsWithDeviceTokenImplSignature didRegisterForRemoteNotificationsWithDeviceTokenImpl;
    didFailToRegisterForRemoteNotificationsWithErrorImplSignature didFailToRegisterForRemoteNotificationsWithErrorImpl;
    didReceiveRemoteNotificationImplSignature didReceiveRemoteNotificationImpl;
    NSString *lastPushId;
    NSString *lastTMBPushId;
}
@end

@implementation TMBPush

#pragma mark - init

+ (instancetype) getInstance {
    static id defaultPush;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ defaultPush = [[self alloc] init]; });
    return defaultPush;
}

+ (void) setInternalDelegate: (id <TMBPushInternalDelegate> )internalDelegate {
    TMBPush *push = [TMBPush getInstance];
    push.client = internalDelegate;
    push.trackReceipts = false;
    if (![TMBUtils autoUNCenterDelDisabled] && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = push;
    }
}

+ (void) setPushDelegate: (id <TMBPushDelegate>) delegate andInternalDelegate:(id <TMBPushInternalDelegate> )internalDelegate {
    TMBPush *push = [TMBPush getInstance];
    push.delegate = delegate;
    push.client = internalDelegate;
    push.trackReceipts = false;
    if (![TMBUtils autoUNCenterDelDisabled] && SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")) {
        UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
        center.delegate = push;
    }
    [push observeSwizzling];
}

#pragma mark - Swizzling Handlers

- (BOOL) observeSwizzling {
    
    if(!swizzled){
        Class appDelegateClass = [[TMBUtils sharedUIApplication].delegate class];
        SEL didRegisterSelector = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
        SEL didFailSelector = @selector(application:didFailToRegisterForRemoteNotificationsWithError:);
        SEL didReceiveSelector = @selector(application:didReceiveRemoteNotification:fetchCompletionHandler:);
        
        // Cast to actual method signature
        didRegisterForRemoteNotificationsWithDeviceTokenImpl = (didRegisterForRemoteNotificationsWithDeviceTokenImplSignature)[TMBSwizzler swizzleMethod:didRegisterSelector inClass:appDelegateClass withImplementationIn:self];
        didFailToRegisterForRemoteNotificationsWithErrorImpl = (didFailToRegisterForRemoteNotificationsWithErrorImplSignature)[TMBSwizzler swizzleMethod:didFailSelector inClass:appDelegateClass withImplementationIn:self];
        didReceiveRemoteNotificationImpl = (didReceiveRemoteNotificationImplSignature)[TMBSwizzler swizzleMethod:didReceiveSelector inClass:appDelegateClass withImplementationIn:self];
        
        swizzled = true;
    } else {
        didRegisterForRemoteNotificationsWithDeviceTokenImpl = NULL;
        didFailToRegisterForRemoteNotificationsWithErrorImpl = NULL;
        didReceiveRemoteNotificationImpl = NULL;
    }
    
    return swizzled;
}

- (void) deswizzlePushMethods {
    
    if(swizzled) {
        Class appDelegateClass = [[TMBUtils sharedUIApplication].delegate class];
        SEL didRegister = @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:);
        [TMBSwizzler deswizzleMethod:didRegister inClass:appDelegateClass originalImplementation:(IMP)didRegisterForRemoteNotificationsWithDeviceTokenImpl];
        didRegisterForRemoteNotificationsWithDeviceTokenImpl = NULL;
        
        SEL didFail = @selector(application:didFailToRegisterForRemoteNotificationsWithError:);
        [TMBSwizzler deswizzleMethod:didFail inClass:appDelegateClass originalImplementation:(IMP)didFailToRegisterForRemoteNotificationsWithErrorImpl];
        didFailToRegisterForRemoteNotificationsWithErrorImpl = NULL;
        
        SEL didReceive = @selector(application:didReceiveRemoteNotification:);
        [TMBSwizzler deswizzleMethod:didReceive inClass:appDelegateClass originalImplementation:(IMP)didReceiveRemoteNotificationImpl];
        didReceiveRemoteNotificationImpl = NULL;
        
        swizzled = false;
    }
}

// set token
// call tamber client setToken method
-(void) setPushDeviceToken:(nullable NSData *) token{
    NSString* newTokenString = [[[token description] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"<>"]] stringByReplacingOccurrencesOfString:@" " withString:@""];
    [_client setUserPushToken:newTokenString];
}
// SWIZZLE ALTERNATIVE:
// didRegisterForRemoteNotifications


// push received
-(void) pushNotificationReceived:(nullable NSDictionary *) payload willDisplayAlert:(bool) willDisplayAlert completion:(TMBEmptyCallbackBlock) completion {
    LogDebug(@"pushNotificationReceived called");
    TMBPushMessage *tmbMessage = [TMBPushMessage decodedObjectFromAPIResponse:payload];
    NSArray *context;
    if(tmbMessage){
        context = @[TMBPushContext];
    }
    if(_trackReceipts){
        [_client trackPushReceived:nil context:context];
    }
    if(tmbMessage){
        if([lastTMBPushId isEqualToString:tmbMessage.pushId]){
            completion();
            return;
        }
        lastTMBPushId = tmbMessage.pushId;
    }
    id aps = [payload objectForKey:@"aps"];
    if ([aps isKindOfClass:[NSDictionary class]]){
        if([aps objectForKey:@"alert"]){
            if(willDisplayAlert){
                // assume this is not a silent notification
                [_client trackPushRendered:nil context:context];
            }
            completion();
            return;
        }
    }
    if(!tmbMessage){
        return;
    }
    [_delegate getPushContent:tmbMessage completion:^(UNMutableNotificationContent *content){
        if(content){
            NSMutableDictionary *uinfo = [NSMutableDictionary dictionaryWithDictionary:content.userInfo];
            NSDictionary *tmbMsgDict = [tmbMessage dict];
            [uinfo setObject:tmbMsgDict forKey:TMBPushMessageFieldName];
            content.userInfo = uinfo;
            UNNotificationRequest *request = [UNNotificationRequest requestWithIdentifier:tmbMessage.type content:content trigger:[UNTimeIntervalNotificationTrigger triggerWithTimeInterval:1 repeats:NO]];
            if(request){
                UNUserNotificationCenter* center = [UNUserNotificationCenter currentNotificationCenter];
                [center addNotificationRequest:request withCompletionHandler:^(NSError * _Nullable error) {
                    if (error != nil) {
                        LogDebug(@"%@", error.localizedDescription);
                    } else {
                        // If center delegate set then iOS will leave presentation of notification up to willPresent -- else if app is foreground the completion error will be non-nil and the notification will not present.
    //                    [UNUserNotificationCenter currentNotificationCenter].delegate
                        if(willDisplayAlert){
                            [self localPushNotificationRendered:request.content.userInfo];
                        }
                    }
                }];
            }
        }
        completion();
    }];

}

-(void) pushNotificationReceived:(nullable NSDictionary *) payload completion:(TMBEmptyCallbackBlock) completion{
    [self pushNotificationReceived:payload willDisplayAlert:![TMBUtils sharedUIApplicationActive] completion:completion];
}

-(void) localPushNotificationRendered:(nullable NSDictionary *) userInfo{
    LogDebug(@"localPushNotificationRendered");
    id tmbMsgDict = [userInfo objectForKey:TMBPushMessageFieldName];
    if ([tmbMsgDict isKindOfClass:[NSDictionary class]]){
        TMBPushMessage *tmbMessage = [TMBPushMessage decodedObjectFromAPIResponse:tmbMsgDict];
        for(NSString *itemId in tmbMessage.items){
            [_client trackPushRendered:itemId context:@[TMBPushContext, tmbMessage.type]];
        }
        if(tmbMessage.srcItems){
            for(NSString *itemId in tmbMessage.srcItems){
                [_client trackPushRendered:itemId context:@[TMBPushContext, tmbMessage.type]];
            }
        }
    } else {
        // Non-tamber local push notification
        [_client trackPushRendered:nil context:nil];
    }
}

// Session started
-(void) sessionStarted{
    if(_client != nil){
        [_client sessionStarted];
    }
}

- (BOOL) matchesLastPush:(UNNotification *) notification {
    if (lastPushId != nil && [lastPushId isEqualToString:notification.request.identifier]){
        return true;
    }
    if(lastTMBPushId != nil){
        id tmbMsgDict = [notification.request.content.userInfo objectForKey:TMBPushMessageFieldName];
        if ([tmbMsgDict isKindOfClass:[NSDictionary class]]){
            TMBPushMessage *tmbMessage = [TMBPushMessage decodedObjectFromAPIResponse:tmbMsgDict];
            if([lastTMBPushId isEqualToString:tmbMessage.pushId]){
                return true;
            }
        }
    }
    return false;
}

- (void)userNotificationCenter:(nonnull UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification withOptions:(UNNotificationPresentationOptions) options completion:(TMBEmptyCallbackBlock) completion {
    LogDebug(@"willPresentNotification options + completion");
    // TODO: Handle non-tamber local notifications
    if (![self matchesLastPush:notification]){
        if((options & UNNotificationPresentationOptionAlert) > 0){
            LogDebug(@"willPresentNotification options + completion calling pushReceived willDisplay:true");
            [self pushNotificationReceived:notification.request.content.userInfo willDisplayAlert:true completion:completion];
        } else {
            LogDebug(@"willPresentNotification options + completion calling pushReceived willDisplay:false");
            [self pushNotificationReceived:notification.request.content.userInfo willDisplayAlert:false completion:completion];
        }
    }
}

+ (UNNotificationPresentationOptions) getDefaultPresentationOptions {
    if([TMBUtils sharedUIApplicationActive]){
        return UNNotificationPresentationOptionNone;
    } else {
        return UNNotificationPresentationOptionAlert;
    }
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification completion:(TMBEmptyCallbackBlock) completion{
    LogDebug(@"willPresentNotification completion");
    [self userNotificationCenter:center willPresentNotification:notification withOptions:[TMBPush getDefaultPresentationOptions] completion:completion];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions options))completionHandler{
    LogDebug(@"willPresentNotification delegate");
    UNNotificationPresentationOptions opts = [TMBPush getDefaultPresentationOptions];
    [self userNotificationCenter:center willPresentNotification:notification withOptions:opts completion:^(){
            // TODO: Test this
            completionHandler(opts);
        }
     ];
}

- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response completion:(TMBEmptyCallbackBlock)completion{
    LogDebug(@"didReceiveNotificationResponse completion");
    if (![self matchesLastPush:response.notification]){
        lastPushId = response.notification.request.identifier;
        [self pushNotificationReceived: response.notification.request.content.userInfo completion:completion];
    }
}

#ifdef __IPHONE_11_0
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)(void))completionHandler {
#else
- (void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void(^)())completionHandler {
#endif
    LogDebug(@"didReceiveNotificationResponse delegate");
    [self userNotificationCenter:center didReceiveNotificationResponse:response completion:^(){
        completionHandler();
    }];
}

#pragma mark - UIApplication Functions

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)newDeviceToken {
    TMBPush *push = [TMBPush getInstance];
    if( push.client == NULL) {

    } else {
        
        [push setPushDeviceToken:newDeviceToken];
        
        if(push->didRegisterForRemoteNotificationsWithDeviceTokenImpl != NULL) {
            id target = [TMBUtils sharedUIApplication].delegate;
            push->didRegisterForRemoteNotificationsWithDeviceTokenImpl(target, @selector(application:didRegisterForRemoteNotificationsWithDeviceToken:), application, newDeviceToken);
        }
    }
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
    TMBPush *push = [TMBPush getInstance];
    if( push.client == NULL) {

    } else {
        if( push->didFailToRegisterForRemoteNotificationsWithErrorImpl != NULL ) {
            id target = [TMBUtils sharedUIApplication].delegate;
            push->didFailToRegisterForRemoteNotificationsWithErrorImpl(target, @selector(application:didFailToRegisterForRemoteNotificationsWithError:), application, error);
        }
    }
}

- (void)application:(UIApplication *)application
didReceiveRemoteNotification:(NSDictionary *)userInfo
fetchCompletionHandler:(void (^)(UIBackgroundFetchResult result))completionHandler{
    LogDebug(@"didReceiveRemoteNotification swizzle");
    TMBPush *push = [TMBPush getInstance];
    if(push.client == NULL) {

    } else {
        // if 1st occurrance of notification, push received or rendered
        [push pushNotificationReceived:userInfo completion:^(){
            // else, push engaged
            if( push->didReceiveRemoteNotificationImpl != NULL ) {
                id target = [TMBUtils sharedUIApplication].delegate;
                push->didReceiveRemoteNotificationImpl(target, @selector(application:didReceiveRemoteNotification:), application, userInfo, completionHandler);
            } else {
                completionHandler(UIBackgroundFetchResultNewData);
            }
        }];
    }
}
@end

