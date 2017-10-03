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

+ (void)setUser:(NSString *)user {
    [TMBClient defaultClient].userId = user;
}

+ (TMBClient*)client {
    return  [TMBClient defaultClient];
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

- (void) updateAuth {
    NSData *authData = [[[self.publishableProjectKey stringByAppendingString:@":"] stringByAppendingString:self.publishableEngineKey ]
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
        _apiVersion = @"2017-3-8";
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
        _apiVersion = @"2017-3-8";
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

@end
