//
//  TMBClient.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMBEventParams.h"
#import "TMBEventResponse.h"
#import "TMBDiscoverParams.h"
#import "TMBDiscoverResponse.h"
#import "TMBDiscovery.h"
#import "TMBEncoder.h"
#import "TMBAPIRequest.h"

NS_ASSUME_NONNULL_BEGIN
static  NSString *const TMBSDKVersion = @"0.0.2";
static NSString *const TMBApiURLBase = @"api.tamber.com/v1";
static NSString *const TMBApiVersion = @"2017-3-8";
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

// Set default user.
+ (void)setUser:(nullable NSString *)user;

// Load the default client for making API requests.
+ (nullable TMBClient*)client;
@end
/**
 *  Client for interacting with a Tamber project and/or engine via the Tamber API.
 */
@interface TMBClient : NSObject

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
 * Track event to your project.
 * @param eventParams The parameters for the event you are tracking. If the client's user has been set, then the user field can be and it will default to the client's user.
 * @param responseCompletion The callback to run with the returned TMBEventResponse (and any errors that may have occurred)
 */
- (nullable NSURLSessionDataTask *) trackEvent:(nullable  TMBEventParams*) eventParams responseCompletion:(nullable TMBAPIResponseBlock) responseCompletion;

/**
 * Retrieve recommended items for the given user.
 *
 * @param discoverParams The parameters for the discover request. If the client's user has been set, then the user field can be nil and it will default to the client's user.
 * @param responseCompletion The callback to run with the returned TMBEventResponse (and any errors that may have occurred)
 */
- (nullable NSURLSessionDataTask *) discoverRecommendations:(nonnull TMBDiscoverParams*) discoverParams responseCompletion:(nonnull TMBAPIResponseBlock) responseCompletion;


@property (nullable, readwrite, nonatomic) NSString *publishableProjectKey;
@property (nullable, readwrite, nonatomic) NSString *publishableEngineKey;
@property (nullable, readwrite, nonatomic) NSString *userId;
@property (nullable, readwrite, nonatomic) NSURLSession *urlSession;
@property (nullable, readwrite, nonatomic) NSURL *apiUrl;
@property (nullable, readwrite, nonatomic) NSString *apiVersion;
@property (nullable, readwrite, nonatomic) NSString *auth;

@end
