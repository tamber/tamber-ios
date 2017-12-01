//
//  TMBClient.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreLocation/CoreLocation.h>
#import "TMBEventParams.h"
#import "TMBEventResponse.h"
#import "TMBDiscoverParams.h"
#import "TMBDiscoverNextParams.h"
#import "TMBDiscoverResponse.h"
#import "TMBUser.h"
#import "TMBUserParams.h"
#import "TMBUserSearchResponse.h"
#import "TMBDiscovery.h"
#import "TMBItem.h"
#import "TMBEncoder.h"
#import "TMBPush.h"
#import "TMBUtils.h"
#import "TMBAPIRequest.h"

NS_ASSUME_NONNULL_BEGIN
static  NSString *const TMBSDKVersion = @"0.0.16";
static NSString *const TMBApiURLBase = @"api.tamber.com/v1";
static NSString *const TMBApiVersion = @"2017-11-30";

static NSString *const TMBPushTokenFieldName = @"tmb_push_token_ios";
static NSString *const TMBPushMinIntervalFieldName = @"tmb_push_min_interval";
static NSString *const TMBTimezoneFieldName = @"tmb_timezone";
static NSString *const TMBTestUserFieldName = @"tmb_test_user";

static NSString *const TMBDefaultContext = @"tamber";
static NSString *const TMBNextContext = @"tmb_next";
static NSString *const TMBRecommendedContext = @"tmb_recommended";
static NSString *const TMBSimilarContext = @"tmb_similar";
static NSString *const TMBRecommendedSimilarContext = @"tmb_recommended_similar";
NS_ASSUME_NONNULL_END

/**
 *  High-level wrapper for the Tamber iOS SDK.
 */
@interface Tamber : NSObject

// Set default project and engine keys.
+ (void)setPublishableProjectKey:(nullable NSString *)publishableProjectKey publishableEngineKey:(nullable NSString *)publishableEngineKey;

// Set default project key.
+ (void)setPublishableProjectKey:(nullable NSString *)publishableProjectKey;

// Set default engine key.
+ (void)setPublishableEngineKey:(nullable NSString *)publishableEngineKey;

// Set default project key and enable push.
+ (void)setPublishableProjectKey:(nullable NSString *)publishableProjectKey enablePush:(BOOL) enablePush;

// Set default project and engine keys and enable push.
+ (void)setPublishableProjectKey:(nullable NSString *)publishableProjectKey publishableEngineKey:(nullable NSString *)publishableEngineKey enablePush:(BOOL) enablePush;

// Set default user.
+ (void)setUser:(nullable NSString *)user;

+ (void) enablePush;

+ (void) enableAutoUNCenterDel;

+ (void) disableAutoUNCenterDel;

+ (void) setPushDelegate:(nullable id <TMBPushDelegate>) delegate;

/**
 * Set the push token for the user (must set the user first)
 * @param token The unique push token for the user
 */
+ (void) setUserPushToken:(nullable NSString*)token;

/**
 * Set the minimum time between push notifications for the user to override the global default.
 * @param interval The mimimum interval (in seconds)
 */
+ (void) setUserPushMinInterval:(int) interval;

/**
 * Set the location for the user (must set the user first)
 * @param location The current location for the user
 */
+ (void) setUserLocation:(nullable CLLocation*)location;

+ (void) makeTestUser;
+ (void) makeTestUser:(nullable TMBEmptyCallbackBlock) completion;
//+ (void) makeTestUser:(nullable NSString*)user;

// Load the default client for making API requests.
+ (nullable TMBClient*)client;

+ (nullable TMBPush*) push;
@end

/**
 *  Client for interacting with a Tamber project and/or engine via the Tamber API.
 */
@interface TMBClient : NSObject <TMBPushInternalDelegate>

+ (nullable instancetype)defaultClient;
- (void) updateAuth;

/**
 * Create a Tamber Client instance.
 *
 * @param publishableProjectKey Your publishable project key. Obtained from https://dashboard.tamber.com
 * @param publishableEngineKey Your publishable engine key. Obtained from https://dashboard.tamber.com
 */
+(nullable instancetype) apiClientWithPublishableProjectKey:(nullable NSString*)publishableProjectKey publishableEngineKey:(nullable NSString*)publishableEngineKey;

/**
 * Create a Tamber Client instance.
 *
 * @param publishableProjectKey Your publishable project key. Obtained from https://dashboard.tamber.com
 * @param publishableEngineKey Your publishable engine key. Obtained from https://dashboard.tamber.com
 * @param user The unique id for the app user
 */
+(nullable instancetype) apiClientWithPublishableProjectKey:(nullable NSString*)publishableProjectKey publishableEngineKey:(nullable NSString*)publishableEngineKey user:(nullable NSString*)user;

/**
 * Tamber initialization
 *
 * @param publishableProjectKey Your publishable project key, obtained from https://dashboard.tamber.com
 * @param publishableEngineKey Your publishable engine key, obtained from https://dashboard.tamber.com
 * @param user The unique id for the app user
 */
-(nullable instancetype) initWithPublishableProjectKey:(nullable NSString*)publishableProjectKey publishableEngineKey: (nullable NSString*)publishableEngineKey user:(nullable NSString*)user;

/**
 * Set id for the user
 * @param user The unique id for the app user
 */
-(void) setUser:(nullable NSString*)user;

/**
 * Get the current user. Returns nil if no user has been set.
 */
-(nullable NSString*) getUser;

/**
 * Set the push token for the user (must set the user first)
 * @param token The unique push token for the user
 */
-(void) setUserPushToken:(nullable NSString*)token;

-(void) setUserPushMinInterval:(int) interval;

/**
 * Set the location for the user (must set the user first)
 * @param location The current location for the user
 */
-(void) setUserLocation:(nullable CLLocation*)location;

-(void) makeTestUser:(nullable NSString *) userId completion:(nullable TMBEmptyCallbackBlock) completion;
/**
 * Set the delegate for `TMBPush`.
 * @param delegate The `TMBPushDelegate`.
 */
-(void) setPushDelegate:(nullable id <TMBPushDelegate>) delegate;

/**
 * Enable `TMBPush` operation. Initializes `TMBPush` instance to begin handling push notification events.
 */
-(void) enablePush;

/**
 * Track start of user session. Used to evaluate engagement driven by push notifications.
 */
-(void) sessionStarted;

/**
 * Disable push notification services for the user.
 */
- (void) disableUserPush;

/**
 * Enable push notification services for the user *after* having called `disableUserPush`. Push services will be enabled by default if `enablePush` has been called and the user has given push permissions to the app.
 */
- (void) reEnableUserPush;

/**
 * Track event to your project.
 * @param eventParams The parameters for the event you are tracking. If the client's user has been set, then the user field can be nil and it will default to the client's user.
 * @param responseCompletion The callback to run with the returned TMBEventResponse (and any errors that may have occurred)
 */
- (nullable NSURLSessionDataTask *) trackEvent:(nullable  TMBEventParams*) eventParams responseCompletion:(nullable TMBAPIResponseBlock) responseCompletion;

/**
 * Create user in your project. IMPORTANT: You do not need to manually create users, tracking events will automatically create novel users. Manually creating a user is valuable for initializing metadata, or if you have an onboarding flow where users interact with items, you can create the user with a list of events from onboarding to seed their recommendations.
 * @param userParams The parameters for the user you are creating. If the client's user has been set, then the `ID` field can be nil and it will default to the client's user.
 * @param responseCompletion The callback to run with the returned TMBUser (and any errors that may have occurred)
 */
- (nullable NSURLSessionDataTask *) createUser:(nullable TMBUserParams*) userParams responseCompletion:(nullable TMBAPIResponseBlock) responseCompletion;

/**
 * Update user in your project. The metadata field will be set to the value provided, if not nil, overwriting any past metadata.
 * @param userParams The parameters for the user you are updating. If the client's user has been set, then the `ID` field can be nil and it will default to the client's user.
 * @param responseCompletion The callback to run with the returned TMBUser (and any errors that may have occurred)
 */
- (nullable NSURLSessionDataTask *) updateUser:(nullable TMBUserParams*) userParams responseCompletion:(nullable TMBAPIResponseBlock) responseCompletion;

/**
 * Retrieve user in your project.
 * @param userParams The parameters for the user you are retrieving – only the `ID` is used. If the client's user has been set, then the `ID` field can be nil and it will default to the client's user.
 * @param responseCompletion The callback to run with the returned TMBUser (and any errors that may have occurred)
 */
- (nullable NSURLSessionDataTask *) retrieveUser:(nullable TMBUserParams*) userParams responseCompletion:(nullable TMBAPIResponseBlock) responseCompletion;

/**
 * Merge from the current default user to another, transferring the tracked events / recommendations and removing the default user from the project, as well as all associated engines, and setting the `TMBClient` default user to the id of the new `toUser`. Useful for transferring a temporary user profile to a logged-in user.
 
 * @param toUser The ID of the user that will be merged to.
 * @param responseCompletion The callback to run with the returned TMBUser (and any errors that may have occurred)
 */
- (nullable NSURLSessionDataTask *) mergeToUser:(nonnull NSString*) toUser responseCompletion:(nullable TMBAPIResponseBlock) responseCompletion;

/**
 * Merge one user into another, removing the `from` user. Useful for transferring the tracked events / recommendations of a temporary user to a logged-in user.
 * @param fromUser The ID of the user that will be merged from.
 * @param toUser The ID of the user that will be merged to.
 * @param responseCompletion The callback to run with the returned TMBUser (and any errors that may have occurred)
 */
- (nullable NSURLSessionDataTask *) mergeUser:(nonnull  NSString*) fromUser toUser:(nonnull  NSString*)toUser responseCompletion:(nullable TMBAPIResponseBlock) responseCompletion;

/**
 * Merge one user into another, removing the `from` user. Useful for transferring the tracked events / recommendations of a temporary user to a logged-in user.
 * @param fromUser The ID of the user that will be merged from.
 * @param toUser The ID of the user that will be merged to.
 * @param noCreate By default, if the toUser does not yet exist it will be created. Set noCreate to `true` to disable this behavior (meaning attempting to merge to a user that does not exist will return an error).
 * @param responseCompletion The callback to run with the returned TMBUser (and any errors that may have occurred)
 */
- (nullable NSURLSessionDataTask *) mergeUser:(nonnull  NSString*) fromUser toUser:(nonnull  NSString*)toUser noCreate:(BOOL) noCreate responseCompletion:(nullable TMBAPIResponseBlock) responseCompletion;

/**
 * Search for users by metadata field-values.
 * @param metadata Dictionary of key-value pairs to search on. The key-values are AND'd together, meaning the search will return users whose metadata contains the entirety of the given dictionary.
 * @param responseCompletion The callback to run with the returned TMBUserSearchResponse (and any errors that may have occurred)
 */
- (nullable NSURLSessionDataTask *) searchUsers:(nonnull  NSDictionary*) metadata responseCompletion:(nullable TMBAPIResponseBlock) responseCompletion;


/**
 * Retrieve the set of recommended items to display next for the given user and/or item. Discover Next is your go-to tool for displaying personalized items on item-pages (set the item to the currently displayed item) and in dedicated recommendations section.
 *
 * @param discoverParams The parameters for the discover request.
 * @param responseCompletion The callback to run with the returned TMBEventResponse (and any errors that may have occurred)
 */
- (nullable NSURLSessionDataTask *) discoverNext:(nonnull TMBDiscoverNextParams*) discoverParams responseCompletion:(nonnull TMBAPIResponseBlock) responseCompletion;

/**
 * Retrieve recommended items for the given user.
 *
 * @param discoverParams The parameters for the discover request. If the client's user has been set, then the user field can be nil and it will default to the client's user.
 * @param responseCompletion The callback to run with the returned TMBEventResponse (and any errors that may have occurred)
 */
- (nullable NSURLSessionDataTask *) discoverRecommendations:(nonnull TMBDiscoverParams*) discoverParams responseCompletion:(nonnull TMBAPIResponseBlock) responseCompletion;

/**
 * Retrieve similar items for the given item.
 *
 * @param discoverParams The parameters for the discover request. Set the `item` parameter to the id of the item for which you wish to receive similar item suggestions.
 * @param responseCompletion The callback to run with the returned TMBEventResponse (and any errors that may have occurred)
 */
- (nullable NSURLSessionDataTask *) discoverSimilar:(nonnull TMBDiscoverParams*) discoverParams responseCompletion:(nonnull TMBAPIResponseBlock) responseCompletion;

/**
 * Retrieve similar items for the given item, that are tailored to the taste profile of the given user.
 *
 * @param discoverParams The parameters for the discover request. Set the `item` parameter to the id of the item for which you wish to receive similar item suggestions. If the client's user has been set, then the user field can be nil and it will default to the client's user.
 * @param responseCompletion The callback to run with the returned TMBEventResponse (and any errors that may have occurred)
 */
- (nullable NSURLSessionDataTask *) discoverRecommendedSimilar:(nonnull TMBDiscoverParams*) discoverParams responseCompletion:(nonnull TMBAPIResponseBlock) responseCompletion;


@property (nullable, readwrite, nonatomic) NSString *publishableProjectKey;
@property (nullable, readwrite, nonatomic) NSString *publishableEngineKey;
@property (nullable, readwrite, nonatomic) NSString *userId;
@property (nullable, readwrite, nonatomic) NSURLSession *urlSession;
@property (nullable, readwrite, nonatomic) NSURL *apiUrl;
@property (nullable, readwrite, nonatomic) NSString *apiVersion;
@property (nullable, readwrite, nonatomic) NSString *auth;

@end
