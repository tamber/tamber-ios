//
//  TMBPush.h
//  Tamber
//
//  Created by Alexander Robbins on 10/14/17.
//  Copyright © 2020 Tamber. All rights reserved.
//
#import <UserNotifications/UserNotifications.h>
#import "TMBUtils.h"

@class TMBPushMessage;

NS_ASSUME_NONNULL_BEGIN
static NSString *const TMBPushMessageFieldName = @"tmb-push-msg";

static NSString *const TMBPushContextKey = @"tmb_push";
static NSString *const TMBPushReceivedContext = @"received";
static NSString *const TMBPushTargetItemContext = @"target_item";
static NSString *const TMBPushSourceItemContext = @"src_item";

static NSString *const TMBPushMessageTypeContextKey = @"tmb_push_msg_type";
NS_ASSUME_NONNULL_END

#pragma mark Delegate Methods
@protocol TMBPushDelegate <NSObject>
- (void) getPushContent:(nullable TMBPushMessage *) message completion:(nullable void (^)(UNMutableNotificationContent * _Nullable content))completion;

@optional
-(void) handleDeepLink;
-(void) handleDeviceToken:(nullable NSData *) deviceToken;
-(void) remoteNotificationReceived:(nullable NSDictionary *)userInfo;
@end

@protocol TMBPushInternalDelegate <NSObject>
- (void) sessionStarted;
- (void) setUserPushToken:(nullable NSString *) token;
- (void) trackPushReceived:(nullable NSString *) pushId context:(nullable NSDictionary*) context completion:(nullable TMBEmptyCallbackBlock) completion;
- (void) trackPushRendered:(nullable NSString *) item context:(nullable NSDictionary*) context completion:(nullable TMBEmptyCallbackBlock) completion;
- (void) trackPushEngaged:(nullable NSString *) item context:(nullable NSDictionary*) context completion:(nullable TMBEmptyCallbackBlock) completion;
@end

@interface TMBPush : NSObject <UNUserNotificationCenterDelegate>

//@property (readwrite, nonatomic) BOOL autoLoadToken;
@property (readwrite, nonatomic) BOOL trackReceipts;

/**
 * Set the push token for the user (must set the user first)
 * @param token The unique push token for the user
 */
-(void) setPushDeviceToken:(nullable NSData *) token;

/**
 * Swizzle AppDelegate Push Methdos. This method is idempotent - safe to call more than once.
 */
- (BOOL) observeSwizzling;

/**
 * Deswizzle AppDelegate Push Methdos. Swizzling is performed by default, so call to deactivate swizzling.  This method is idempotent - safe to call more than once.
 */
- (void) deswizzlePushMethods;

#pragma mark UNUserNotificationCenter callable sub-delegate methods

/**
 * If another class is serving as the `UNUserNotificationCenter` delegate, use this method to handle willPresentNotification events in `TMBPush`.
 * @param center The `UNUserNotificationCenter` object.
 * @param notification the `UNNotification` that will be presented.
 * @param completion Completion handler called once all operations completed.
 */
- (void)userNotificationCenter:(nonnull UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification completion:(nullable TMBEmptyCallbackBlock) completion;

/**
 * If another class is serving as the `UNUserNotificationCenter` delegate, and using `UNNotificationPresentationOptions` in its completionHandler, use this method to handle willPresentNotification events in `TMBPush`.
 * @param center The `UNUserNotificationCenter` object.
 * @param notification The `UNNotification` that will be presented.
 * @param options Presentation options for the notification. Used by TMBPush to determine whether or not the notification will be shown (or 'rendered') to the user.
 * @param completion Completion handler called once all operations completed.
 */
- (void)userNotificationCenter:(nonnull UNUserNotificationCenter *)center willPresentNotification:(nonnull UNNotification *)notification withOptions:(UNNotificationPresentationOptions) options completion:(nullable TMBEmptyCallbackBlock) completion;

/**
 * If another class is serving as the `UNUserNotificationCenter` delegate, use this method to handle didReceiveNotificationResponse events in `TMBPush`.
 * @param center The `UNUserNotificationCenter` object.
 * @param response The `UNNotificationResponse` received.
 * @param completion Completion handler called once all operations completed.
 */
- (void)userNotificationCenter:(nonnull UNUserNotificationCenter *)center didReceiveNotificationResponse:(nonnull UNNotificationResponse *)response completion:(nullable TMBEmptyCallbackBlock) completion;



/**
 * Handler for received notification payloads. Only to be used if swizzling is disabled.
 * @param payload The notification payload
 * @param completion Completion handler called once all operations completed.
 */
-(void) pushNotificationReceived:(nullable NSDictionary *) payload completion:(nullable TMBEmptyCallbackBlock) completion;

/**
 * Handler for rendered notifications (notifications shown to the user). Only to be used if swizzling is disabled.
 * @param userInfo The notification payload. Be sure to correctly set the `tmb-push-msg` field to the dictionary-encoded TMBPushMessage to ensure proper handling.
 * @param completion Completion handler called once all operations completed.
 */
-(void) localPushNotificationRendered:(nullable NSDictionary *) userInfo completion:(nullable TMBEmptyCallbackBlock) completion;

/**
 * Track start of user session. Used to evaluate engagement driven by push notifications.
 */
- (void) sessionStarted;

+ (nullable instancetype) getInstance;

+ (void) setInternalDelegate: (nonnull id <TMBPushInternalDelegate> )internalDelegate;

+ (void) setPushDelegate: (nonnull id  <TMBPushDelegate>) delegate andInternalDelegate:(nonnull id <TMBPushInternalDelegate> )internalDelegate;

@property (nonatomic, assign, nonnull) id <TMBPushInternalDelegate> client;
@property (nonatomic, assign, nonnull) id <TMBPushDelegate> delegate;
@end


