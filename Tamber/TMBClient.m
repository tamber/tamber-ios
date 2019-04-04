//
//  TMBClient.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2019 Tamber. All rights reserved.
//

//#import <Tamber/TMBClient.h>
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

+(void) setUserPushMinInterval:(int) interval {
    [[TMBClient defaultClient] setUserPushMinInterval: interval];
}

+ (void) setUserLocation:(nullable CLLocation*)location {
    [[TMBClient defaultClient] setUserLocation: location];
}

+(void) makeTestUser{
    [[TMBClient defaultClient] makeTestUser: nil completion:nil];
}

+ (void) makeTestUser:(TMBEmptyCallbackBlock) completion{
    [[TMBClient defaultClient] makeTestUser: nil completion:completion];
}

//+(void) makeTestUser:(nullable NSString*)user{
//    [[TMBClient defaultClient] makeTestUser: user];
//}


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

- (void) upsertUserMetadata:(NSString *) userId keyValues:(NSDictionary *) keyValues completion:(TMBEmptyCallbackBlock) completion {
    LogDebug(@"upsertUserMetadata called");
    if(userId == nil){
        if(_userId == nil){
            if(completion){completion();}
            return;
        }
        userId = _userId;
    }
    TMBUserParams *userParams = [TMBUserParams userWithId:userId metadata:keyValues];
    [self updateUser:userParams responseCompletion:^(TMBUser *user, NSHTTPURLResponse *response, NSError *errorMessage) {
        if(errorMessage){
            LogDebug(@"ERROR %@", errorMessage);
            if([errorMessage.domain isEqualToString:TamberDomain]) {
                [self createUser:userParams responseCompletion:^(TMBUser *cuser, NSHTTPURLResponse *response, NSError *cerrorMessage) {
                    if(cerrorMessage){
                        LogDebug(@"CERROR %@", cerrorMessage);
                        if([cerrorMessage.domain isEqualToString:TamberDomain]) {
                            [self updateUser:userParams responseCompletion:^(TMBUser *upuser, NSHTTPURLResponse *response, NSError *uperrorMessage) {
                                if(uperrorMessage){
                                    LogDebug(@"UPERROR %@", uperrorMessage);
                                }
                                if(completion){
                                    completion();
                                }
                            }];
                        } else if(completion){
                            completion();
                        }
                    }else if(completion){
                        completion();
                    }
                }];
            } else if(completion){
                completion();
            }
        } else if(completion){
            completion();
        }
    }];
}

-(void) setUserPushToken:(nullable NSString*)token{
    [self upsertUserMetadata:nil keyValues:@{TMBPushTokenFieldName:token, TMBTimezoneFieldName: [[NSTimeZone localTimeZone] name]} completion:nil];
}

-(void) setUserPushMinInterval:(int) interval {
    [self upsertUserMetadata:nil keyValues:@{TMBPushMinIntervalFieldName:[NSNumber numberWithInt:interval]} completion:nil];
}

- (void) disableUserPush {
    [self upsertUserMetadata:nil keyValues:@{ @"tmb_push_setting_ios": @"off"} completion:nil];
}

- (void) reEnableUserPush {
    [self upsertUserMetadata:nil keyValues:@{ @"tmb_push_setting_ios": @"on"} completion:nil];
}

-(void) setUserLocation:(nullable CLLocation*)location {
     // Ignore null locations
    if((location.coordinate.latitude == 0.0 && location.coordinate.longitude == 0.0) || location == nil){
        return;
    }
    [self upsertUserMetadata:nil keyValues:@{@"latitude": [NSNumber numberWithDouble:location.coordinate.latitude], @"longitude":[NSNumber numberWithDouble:location.coordinate.longitude]} completion:nil];
}

-(void) makeTestUser:(NSString *) userId completion:(TMBEmptyCallbackBlock) completion{
    [self upsertUserMetadata:userId keyValues:@{TMBTestUserFieldName:[NSNumber numberWithBool:TRUE]} completion:completion];
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
    return [self retrieveUser: userParams getEvents: false responseCompletion: responseCompletion];
}

- (NSURLSessionDataTask *) retrieveUser:(TMBUserParams*) userParams getEvents:(BOOL) getEvents responseCompletion:(TMBAPIResponseBlock) responseCompletion{
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", @"user", @"retrieve"];
    
    if(userParams.ID == nil && self.userId != nil){
        userParams.ID = self.userId;
    }
    NSDictionary *_params = [TMBEncoder dictionaryForObject:userParams];
    NSMutableDictionary *params = [NSMutableDictionary dictionaryWithDictionary: _params];
    [params setObject:@(getEvents) forKey:@"get_events"];
    
    return [TMBAPIRequest getWithAPIClient:self
                                  endpoint:endpoint
                                parameters:[params copy]
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
    NSURLSessionDataTask *task = [self mergeUser: _userId toUser:toUser noCreate: false getEvents: false responseCompletion: responseCompletion];
    _userId = toUser;
    return task;
}

- (NSURLSessionDataTask *) mergeUser:(NSString*) fromUser toUser:(NSString*)toUser responseCompletion:(TMBAPIResponseBlock) responseCompletion{
    return [self mergeUser: fromUser toUser:toUser noCreate: false getEvents: false responseCompletion: responseCompletion];
}

- (NSURLSessionDataTask *) mergeUser:(NSString*) fromUser toUser:(NSString*)toUser noCreate:(BOOL) noCreate getEvents:(BOOL) getEvents responseCompletion:(TMBAPIResponseBlock) responseCompletion{
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", @"user", @"merge"];

    NSDictionary *params = @{ @"from": fromUser, @"to": toUser, @"no_create":@(noCreate), @"get_events":@(getEvents) };
    
    return [TMBAPIRequest getWithAPIClient:self
                                  endpoint:endpoint
                                parameters:params
                                serializer:[TMBUser new]
                                completion:responseCompletion];
}

- (NSURLSessionDataTask *) searchUsers:(NSDictionary*) metadata responseCompletion:(TMBAPIResponseBlock) responseCompletion{
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", @"user", @"list"];
    
    NSDictionary *params = @{ @"filter": metadata };
    
    return [TMBAPIRequest getWithAPIClient:self
                                  endpoint:endpoint
                                parameters:params
                                serializer:[TMBUserSearchResponse new]
                                completion:responseCompletion];
}

- (nullable NSURLSessionDataTask *) discoverNext:(nonnull TMBDiscoverParams*) discoverParams responseCompletion:(nonnull TMBAPIResponseBlock) responseCompletion {
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

- (NSURLSessionDataTask *) discoverSimilar:(TMBDiscoverBasicParams*) discoverParams responseCompletion:(TMBAPIResponseBlock) responseCompletion {
    
    NSString *endpoint = [NSString stringWithFormat:@"%@/%@", @"discover", @"similar"];
    NSDictionary *params = [TMBEncoder dictionaryForObject:discoverParams];
    return [TMBAPIRequest getWithAPIClient:self
                                  endpoint:endpoint
                                parameters:params
                                serializer:[TMBDiscoverResponse new]
                                completion:responseCompletion];
}

- (NSURLSessionDataTask *) discoverRecommendedSimilar:(TMBDiscoverBasicParams*) discoverParams responseCompletion:(TMBAPIResponseBlock) responseCompletion {
    
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

- (void) trackPushReceived:(nullable NSString *) pushId context:(nullable NSDictionary*) context completion:(TMBEmptyCallbackBlock) completion{
    [[Tamber client] trackEvent:[TMBEventParams pushReceivedWithContext:context created:[NSDate date]] responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        if(completion){completion();}
    }];
}

- (void) trackPushRendered:(nullable NSString *) item context:(nullable NSDictionary*) context completion:(TMBEmptyCallbackBlock) completion{
    TMBEventParams *eventParams = [TMBEventParams pushRenderedWithContext:context created:[NSDate date]];
    eventParams.item = item;
    [[Tamber client] trackEvent:eventParams responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        if(completion){completion();}
    }];
}

- (void) trackPushEngaged:(nullable NSString *) item context:(nullable NSDictionary*) context completion:(TMBEmptyCallbackBlock) completion{
    TMBEventParams *eventParams = [TMBEventParams pushEngagedWithContext:context created:[NSDate date]];
    eventParams.item = item;
    [[Tamber client] trackEvent:eventParams responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        LogDebug(@"error:%@", errorMessage.localizedDescription);
        if(completion){completion();}
    }];
}


@end
