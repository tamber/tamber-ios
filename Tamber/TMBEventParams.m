//
//  TMBEventParams.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBEventParams.h"

@implementation TMBEventParams

@synthesize additionalAPIParameters = _additionalAPIParameters;

- (instancetype)init {
    self = [super init];
    if (self) {
        _additionalAPIParameters = @{};
    }
    return self;
}

+ (instancetype)eventWithItem:(NSString*) item behavior:(NSString *)behavior{
    return [[self.class alloc] initWithUser:nil item:item behavior:behavior value:nil created:nil];
}

+ (instancetype)eventWithItem:(NSString*) item behavior:(NSString *)behavior value:(NSNumber*)value created:(NSDate*)created{
    return [[self.class alloc] initWithUser:nil item:item behavior:behavior value:value created:created];
}

+ (instancetype)eventWithUser:(NSString*) user item:(NSString*) item behavior:(NSString *)behavior{
    return [[self.class alloc] initWithUser:user item:item behavior:behavior value:nil created:nil];
}

+ (instancetype)eventWithUser:(NSString*) user item:(NSString*) item behavior:(NSString *)behavior value:(NSNumber*)value created:(NSDate*)created{
    return [[self.class alloc] initWithUser:user item:item behavior:behavior value:value created:created];
}

- (instancetype)initWithUser:(NSString*) user item:(NSString*) item behavior:(NSString *)behavior value:(NSNumber*)value created:(NSDate*)created {
    self = [super init];
    if (self) {
        _user = user;
        _item = item;
        _behavior = behavior;
        _value = value;
        _created = created;
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
             @"user": @"user",
             @"item": @"item",
             @"behavior": @"behavior",
             @"value": @"value",
             @"created": @"created",
             @"getRecs": @"get_recs",
             };
}

@end
