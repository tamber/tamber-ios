//
//  TMBUserParams.m
//  Tamber
//
//  Created by Alexander Robbins on 7/5/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBUserParams.h"

@implementation TMBUserParams

@synthesize additionalAPIParameters = _additionalAPIParameters;

- (instancetype)init {
    self = [super init];
    if (self) {
        _additionalAPIParameters = @{};
    }
    return self;
}


+ (instancetype)defaultUser{
    return [[self.class alloc] initWithId:nil metadata:nil events:nil];
}

+ (instancetype)userWithId:(NSString *) userId{
    return [[self.class alloc] initWithId:userId metadata:nil events:nil];
}

+ (instancetype)userWithMetadata:(NSDictionary*) metadata{
    return [[self.class alloc] initWithId:nil metadata:metadata events:nil];
}

+ (instancetype)userWithMetadata:(NSDictionary*) metadata events:(NSArray *) events{
    return [[self.class alloc] initWithId:nil metadata:metadata events:events];
}

+ (instancetype)userWithId:(NSString *) userId metadata:(NSDictionary*) metadata{
    return [[self.class alloc] initWithId:userId metadata:metadata events:nil];
}

+ (instancetype)userWithId:(NSString *) userId metadata:(NSDictionary*) metadata events:(NSArray *) events{
    return [[self.class alloc] initWithId:userId metadata:metadata events:events];
}

- (instancetype)initWithId:(NSString *) userId metadata:(NSDictionary*) metadata events:(NSArray *) events{
    self = [super init];
    if (self) {
        _ID = userId;
        _metadata = metadata;
        _events = events;
    }
    return self;
}

- (void) setGetRecs:(TMBDiscoverParams*)getRecs{
    _getRecs = getRecs;
}

#pragma mark - TMBObjectEncodable

+ (NSString *)rootObjectName {
    return nil;
}

+ (NSDictionary *)propertyNamesToFormFieldNamesMapping {
    return @{
             @"ID": @"id",
             @"events": @"events",
             @"metadata": @"metadata",
             @"getRecs": @"get_recs",
             };
}

@end
