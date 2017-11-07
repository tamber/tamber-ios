//
//  TMBClient.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBClient.h"
#import <UIKit/UIKit.h>
#import <sys/utsname.h>
#import "TMBEvent.h"

@implementation Tamber
+ (void)setPublishableProjectKey:(NSString *)publishableProjectKey publishableEngineKey:(NSString *)publishableEngineKey{
    TMBClient* client = [TMBClient defaultClient];
    client.publishableProjectKey = publishableProjectKey;
    client.publishableEngineKey = publishableEngineKey;
    [client updateAuth];
}

+ (void)setPublishableProjectKey:(NSString *)publishableProjectKey{
    TMBClient* client = [TMBClient defaultClient];
    client.publishableProjectKey = publishableProjectKey;
    [client updateAuth];
}

+ (void)setPublishableEngineKey:(NSString *)publishableEngineKey{
    TMBClient* client = [TMBClient defaultClient];
    client.publishableEngineKey = publishableEngineKey;
    [client updateAuth];
}

+ (void)setPublishableProjectKey:(nullable NSString *)publishableProjectKey enablePush:(BOOL) enablePush{
    TMBClient* client = [TMBClient defaultClient];
    client.publishableProjectKey = publishableProjectKey;
    [client updateAuth];
    if(enablePush){
        [TMBPush setInternalDelegate: client];
    }
}

+ (void)setPublishableProjectKey:(nullable NSString *)publishableProjectKey publishableEngineKey:(nullable NSString *)publishableEngineKey enablePush:(BOOL) enablePush{
    TMBClient* client = [TMBClient defaultClient];
    client.publishableProjectKey = publishableProjectKey;
    client.publishableEngineKey = publishableEngineKey;
    [client updateAuth];
    if(enablePush){
        [TMBPush setInternalDelegate: client];
    }
}

+ (void) enablePush{
    [TMBPush setInternalDelegate:  [TMBClient defaultClient]];
}

+ (void) setPushDelegate:(id <TMBPushDelegate>) delegate {
    [[TMBClient defaultClient] setPushDelegate:delegate];
}

+ (void) enableAutoUNCenterDel {
    TMBUtils *utils = [TMBUtils getInstance];
    utils.disableNotificationCenterDelegate = false;
}

+ (void) disableAutoUNCenterDel {
    TMBUtils *utils = [TMBUtils getInstance];
    utils.disableNotificationCenterDelegate = true;
}

+ (void)setUser:(NSString *)user {
    [TMBClient defaultClient].userId = user;
}

+(void) setUserPushToken:(nullable NSString*)token{
    [[TMBClient defaultClient] setUserPushToken: token];
}

+ (TMBClient*) client {
    return  [TMBClient defaultClient];
}

+ (nullable TMBPush*) push {
    return [TMBPush getInstance];
}

@end
@implementation TMBClient

+ (instancetype)defaultClient{
    static id defaultClient;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ defaultClient = [[self alloc] init]; });
    return defaultClient;
}

+(instancetype) apiClientWithPublishableProjectKey:(NSString*)publishableProjectKey publishableEngineKey:(NSString*)publishableEngineKey {
    return [[self.class alloc] initWithPublishableProjectKey:publishableProjectKey publishableEngineKey:publishableEngineKey user:nil];
}

+(instancetype) apiClientWithPublishableProjectKey:(NSString*)publishableProjectKey publishableEngineKey:(NSString*)publishableEngineKey user:(NSString*)user{
    return [[self.class alloc] initWithPublishableProjectKey:publishableProjectKey publishableEngineKey:publishableEngineKey user:user];
}

- (void) setPushDelegate:(id <TMBPushDelegate>) delegate {
    [TMBPush setPushDelegate:delegate andInternalDelegate:self];
}

- (void) enablePush{
    [TMBPush setInternalDelegate: self];
}

- (void) updateAuth {
    NSString *engineKey = @"";
    if(self.publishableEngineKey){
        engineKey = self.publishableEngineKey;
    }
    NSString *projectKey = @"";
    if(self.publishableProjectKey){
        projectKey = self.publishableProjectKey;
    }
    NSData *authData = [[[projectKey stringByAppendingString:@":"] stringByAppendingString:engineKey ]
                        dataUsingEncoding:NSUTF8StringEncoding];
    NSString *authKeys = [authData base64EncodedStringWithOptions:0];
    self.auth = [@"Basic " stringByAppendingString:authKeys];
}

-(instancetype) initWithPublishableProjectKey:(NSString*)publishableProjectKey publishableEngineKey: (NSString*)publishableEngineKey user:(NSString*)user
{
    self = [super init];
    if (self) {
        _publishableProjectKey = publishableProjectKey;
        _publishableEngineKey = publishableEngineKey;
        _userId = user;
        _apiUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@", TMBApiURLBase]];
        _apiVersion = TMBApiVersion;
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.HTTPAdditionalHeaders = @{
                                                       @"X-Tamber-User-Agent": [self.class tamberUserAgentDetails],
                                                       @"Tamber-Version": TMBApiVersion,
                                                       };
        _urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
        [self updateAuth];
    }
    return self;
}

-(instancetype) init{
    self = [super init];
    if (self) {
        _apiUrl = [NSURL URLWithString:[NSString stringWithFormat:@"https://%@", TMBApiURLBase]];
        _apiVersion = TMBApiVersion;
        NSURLSessionConfiguration *sessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
        sessionConfiguration.HTTPAdditionalHeaders = @{
                                                       @"X-Tamber-User-Agent": [self.class tamberUserAgentDetails],
                                                       @"Tamber-Version": TMBApiVersion,
                                                       };
        _urlSession = [NSURLSession sessionWithConfiguration:sessionConfiguration];
    }
    return self;
}

-(void) setUser:(NSString*)user{
    _userId = user;
}

-(void) setUserPushToken:(nullable NSString*)token{
    TMBClient *client = [TMBClient defaultClient];
    if(client.userId != nil){
        TMBUserParams *userParams = [TMBUserParams userWithId:_userId];
        [client retrieveUser:userParams responseCompletion:^(TMBUser *user, NSHTTPURLResponse *response, NSError *errorMessage) {
            if(!errorMessage){
                // Check if token already set
                if(user.metadata){
                    id curToken = [user.metadata objectForKey:TMBPushTokenFieldName];
                    if([curToken isKindOfClass:[NSString class]] && [curToken isEqualToString:token]){
                        return;
                    }
                }
                // Update token if necessary
                NSMutableDictionary *metadata;
                if(user.metadata){
                    metadata = [[NSMutableDictionary alloc] initWithDictionary:user.metadata];
                } else {
                    metadata = [[NSMutableDictionary alloc] init];
                }
                [metadata setValue:token forKey:TMBPushTokenFieldName];
                userParams.metadata = metadata;
                [client updateUser:userParams responseCompletion:^(TMBUser *object, NSHTTPURLResponse *response, NSError *errorMessage) {
                    if(errorMessage){
                        LogDebug(@"error %@", errorMessage);
                    }
                }];
            }
        }];
    }
}

-(nullable NSString*) getUser{
    return _userId;
}

- (NSURLSessionDataTask *) trackEvent:(TMBEventParams*) eventParams responseCompletion:(TMBAPIResponseBlock) responseCompletion {

    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", @"event", @"track"];
    if(eventParams.user == nil && self.userId != nil){
        eventParams.user = self.userId;
    }
    NSDictionary *params = [TMBEncoder dictionaryForObject:eventParams];
    return [TMBAPIRequest getWithAPIClient:self
                                               endpoint:endpoint
                                             parameters:params
                                             serializer:[TMBEventResponse new]
                                             completion:responseCompletion];
}

- (NSURLSessionDataTask *) createUser:(TMBUserParams*) userParams responseCompletion:(TMBAPIResponseBlock) responseCompletion{
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", @"user", @"create"];
    
    if(userParams.ID == nil && self.userId != nil){
        userParams.ID = self.userId;
    }
    NSDictionary *params = [TMBEncoder dictionaryForObject:userParams];
    
    return [TMBAPIRequest getWithAPIClient:self
                                  endpoint:endpoint
                                parameters:params
                                serializer:[TMBUser new]
                                completion:responseCompletion];
}

- (NSURLSessionDataTask *) retrieveUser:(TMBUserParams*) userParams responseCompletion:(TMBAPIResponseBlock) responseCompletion{
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", @"user", @"retrieve"];
    
    if(userParams.ID == nil && self.userId != nil){
        userParams.ID = self.userId;
    }
    NSDictionary *params = [TMBEncoder dictionaryForObject:userParams];
    
    return [TMBAPIRequest getWithAPIClient:self
                                  endpoint:endpoint
                                parameters:params
                                serializer:[TMBUser new]
                                completion:responseCompletion];
}

- (NSURLSessionDataTask *) updateUser:(TMBUserParams*) userParams responseCompletion:(TMBAPIResponseBlock) responseCompletion{
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", @"user", @"update"];
    
    if(userParams.ID == nil && self.userId != nil){
        userParams.ID = self.userId;
    }
    NSDictionary *params = [TMBEncoder dictionaryForObject:userParams];
    
    return [TMBAPIRequest getWithAPIClient:self
                                  endpoint:endpoint
                                parameters:params
                                serializer:[TMBUser new]
                                completion:responseCompletion];
}

- (NSURLSessionDataTask *) mergeToUser:(NSString*) toUser responseCompletion:(TMBAPIResponseBlock) responseCompletion{
    NSURLSessionDataTask *task = [self mergeUser: _userId toUser:toUser noCreate: false responseCompletion: responseCompletion];
    _userId = toUser;
    return task;
}

- (NSURLSessionDataTask *) mergeUser:(NSString*) fromUser toUser:(NSString*)toUser responseCompletion:(TMBAPIResponseBlock) responseCompletion{
    return [self mergeUser: fromUser toUser:toUser noCreate: false responseCompletion: responseCompletion];
}

- (NSURLSessionDataTask *) mergeUser:(NSString*) fromUser toUser:(NSString*)toUser noCreate:(BOOL) noCreate responseCompletion:(TMBAPIResponseBlock) responseCompletion{
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", @"user", @"merge"];

    NSDictionary *params = @{ @"from": fromUser, @"to": toUser, @"no_create":@(noCreate) };
    
    return [TMBAPIRequest getWithAPIClient:self
                                  endpoint:endpoint
                                parameters:params
                                serializer:[TMBUser new]
                                completion:responseCompletion];
}

- (NSURLSessionDataTask *) searchUsers:(NSDictionary*) metadata responseCompletion:(TMBAPIResponseBlock) responseCompletion{
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", @"user", @"search"];
    
    NSDictionary *params = @{ @"filter": metadata };
    
    return [TMBAPIRequest getWithAPIClient:self
                                  endpoint:endpoint
                                parameters:params
                                serializer:[TMBUserSearchResponse new]
                                completion:responseCompletion];
}

- (nullable NSURLSessionDataTask *) discoverNext:(nonnull TMBDiscoverNextParams*) discoverParams responseCompletion:(nonnull TMBAPIResponseBlock) responseCompletion {
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", @"discover", @"next"];
    if(discoverParams.user == nil && self.userId != nil){
        discoverParams.user = self.userId;
    }
    NSDictionary *params = [TMBEncoder dictionaryForObject:discoverParams];
    return [TMBAPIRequest getWithAPIClient:self
                                  endpoint:endpoint
                                parameters:params
                                serializer:[TMBDiscoverResponse new]
                                completion:responseCompletion];
}

- (NSURLSessionDataTask *) discoverRecommendations:(TMBDiscoverParams*) discoverParams responseCompletion:(TMBAPIResponseBlock) responseCompletion {
    
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", @"discover", @"recommended"];
    if(discoverParams.user == nil && self.userId != nil){
        discoverParams.user = self.userId;
    }
    NSDictionary *params = [TMBEncoder dictionaryForObject:discoverParams];
    return [TMBAPIRequest getWithAPIClient:self
                                  endpoint:endpoint
                                parameters:params
                                serializer:[TMBDiscoverResponse new]
                                completion:responseCompletion];
}

- (NSURLSessionDataTask *) discoverSimilar:(TMBDiscoverParams*) discoverParams responseCompletion:(TMBAPIResponseBlock) responseCompletion {
    
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", @"discover", @"similar"];
    NSDictionary *params = [TMBEncoder dictionaryForObject:discoverParams];
    return [TMBAPIRequest getWithAPIClient:self
                                  endpoint:endpoint
                                parameters:params
                                serializer:[TMBDiscoverResponse new]
                                completion:responseCompletion];
}

- (NSURLSessionDataTask *) discoverRecommendedSimilar:(TMBDiscoverParams*) discoverParams responseCompletion:(TMBAPIResponseBlock) responseCompletion {
    
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", @"discover", @"recommended_similar"];
    if(discoverParams.user == nil && self.userId != nil){
        discoverParams.user = self.userId;
    }
    NSDictionary *params = [TMBEncoder dictionaryForObject:discoverParams];
    return [TMBAPIRequest getWithAPIClient:self
                                  endpoint:endpoint
                                parameters:params
                                serializer:[TMBDiscoverResponse new]
                                completion:responseCompletion];
}

/* Taken from Stripe STPAPIClient user agent */
+ (NSString *)tamberUserAgentDetails {
    NSMutableDictionary *details = [@{
                                      @"lang": @"objective-c",
                                      @"bindings_version": TMBSDKVersion,
                                      } mutableCopy];
    NSString *version = [UIDevice currentDevice].systemVersion;
    if (version) {
        details[@"os_version"] = version;
    }
    struct utsname systemInfo;
    uname(&systemInfo);
    NSString *deviceType = @(systemInfo.machine);
    if (deviceType) {
        details[@"type"] = deviceType;
    }
    NSString *model = [UIDevice currentDevice].localizedModel;
    if (model) {
        details[@"model"] = model;
    }
    if ([[UIDevice currentDevice] respondsToSelector:@selector(identifierForVendor)]) {
        NSString *vendorIdentifier = [[[UIDevice currentDevice] performSelector:@selector(identifierForVendor)] performSelector:@selector(UUIDString)];
        if (vendorIdentifier) {
            details[@"vendor_identifier"] = vendorIdentifier;
        }
    }
    return [[NSString alloc] initWithData:[NSJSONSerialization dataWithJSONObject:[details copy] options:(NSJSONWritingOptions)kNilOptions error:NULL] encoding:NSUTF8StringEncoding];
}

#pragma mark TMPushInternalDelegate

-(void) sessionStarted{
    if(_userId != nil){
        [self trackEvent:[TMBEventParams sessionStarted] responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
           // handle
        }];
    }
}

- (void) trackPushReceived:(nullable NSString *) pushId context:(nullable NSArray *) context{
    [[Tamber client] trackEvent:[TMBEventParams pushReceivedWithContext:context created:nil] responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        // handle
    }];
}
- (void) trackPushRendered:(nullable NSString *) item context:(nullable NSArray *) context{
    TMBEventParams *eventParams = [TMBEventParams pushRenderedWithContext:context created:nil];
    eventParams.item = item;
    [[Tamber client] trackEvent:eventParams responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
         // handle
    }];
}


@end
