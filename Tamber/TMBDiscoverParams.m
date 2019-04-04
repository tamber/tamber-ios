//
//  TMBDiscoverParams.m
//  Tamber
//
//  Created by Alexander Robbins on 10/3/17.
//  Copyright © 2019 Tamber. All rights reserved.
//

#import "TMBDiscoverParams.h"

@implementation TMBDiscoverParams

@synthesize additionalAPIParameters = _additionalAPIParameters;

- (instancetype)init {
    self = [super init];
    if (self) {
        _additionalAPIParameters = @{};
    }
    return self;
}

+ (nullable instancetype) discoverRecommended:(nullable NSNumber*) number {
    return [[self.class alloc] initWithUser:nil item:nil number:number excludeItems:nil variability:nil filter:nil getProperties:false continuation:false noCreate:nil];
}

+ (nullable instancetype)discoverRecommended:(nullable NSNumber*) number getProperties:(BOOL) getProperties{
    return [[self.class alloc] initWithUser:nil item:nil number:number excludeItems:nil variability:nil filter:nil getProperties:getProperties continuation:false noCreate: nil];
}

+ (nullable instancetype)discoverRecommended:(nullable NSNumber*) number excludeItems:(nullable NSArray*) excludeItems variability:(nullable NSNumber*) variability  filter:(nullable NSDictionary*)filter getProperties:(BOOL) getProperties continuation:(BOOL) continuation noCreate:(nullable NSString *) noCreate {
    return [[self.class alloc] initWithUser:nil item:nil number:number excludeItems:excludeItems variability:variability filter:filter getProperties:getProperties continuation:continuation noCreate: noCreate];
}

+ (nullable instancetype)discoverNext:(nullable NSString*) item number:(nullable NSNumber*) number {
    return [[self.class alloc] initWithUser:nil item:item number:number excludeItems:nil variability:nil filter:nil getProperties:false continuation:false noCreate: nil];
}

+ (nullable instancetype)discoverNext:(nullable NSString*) item  number:(nullable NSNumber*) number getProperties:(BOOL) getProperties{
    return [[self.class alloc] initWithUser:nil item:nil number:number excludeItems:nil variability:nil filter:nil getProperties:getProperties continuation:false noCreate: nil];
}

+ (nullable instancetype)discoverNext:(nullable NSString*) item number:(nullable NSNumber*) number excludeItems:(nullable NSArray*) excludeItems variability:(nullable NSNumber*) variability  filter:(nullable NSDictionary*)filter getProperties:(BOOL) getProperties noCreate:(NSString*) noCreate {
    return [[self.class alloc] initWithUser:nil item:nil number:number excludeItems:excludeItems variability:variability filter:filter getProperties:getProperties continuation:false noCreate: noCreate];
}

+ (nullable instancetype)discoverNextParamsWithUser:(nullable NSString*) user number:(nullable NSNumber*) number {
    return [[self.class alloc] initWithUser:user item:nil number:number excludeItems:nil variability:nil filter:nil getProperties:false continuation:false noCreate: nil];
}

+ (nullable instancetype)discoverNextParamsWithUser:(nullable NSString*) user item:(nullable NSString*) item number:(nullable NSNumber*) number {
    return [[self.class alloc] initWithUser:user item:item number:number excludeItems:nil variability:nil filter:nil getProperties:false continuation:false noCreate: nil];
}


- (instancetype)initWithUser:(NSString*) user item:(NSString*) item number:(NSNumber*)number excludeItems:(NSArray*) excludeItems variability:(NSNumber*)variability filter:(NSDictionary*)filter getProperties:(BOOL) getProperties continuation:(BOOL) continuation noCreate:(NSString *) noCreate {
    self = [super init];
    if (self) {
        _user = user;
        _item = item;
        _number = number;
        _excludeItems = excludeItems;
        _variability = variability;
        _filter = filter;
        _getProperties = getProperties;
        _continuation = continuation;
        _noCreate = noCreate;
    }
    return self;
}


#pragma mark - TMBObjectEncodable

+ (NSString *)rootObjectName {
    return nil;
}

+ (NSDictionary *)propertyNamesToFormFieldNamesMapping {
    return @{
             @"user": @"user",
             @"item": @"item",
             @"number": @"number",
             @"excludeItems": @"exclude_items",
             @"variability": @"variability",
             @"filter": @"filter",
             @"getProperties": @"get_properties",
             @"continuation": @"continuation",
             @"noCreate": @"no_create",
             };
}


@end
