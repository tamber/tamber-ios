//
//  TMBDiscoverParams.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
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

+ (nullable instancetype)discoverRecommendations:(nullable NSNumber*) number {
    return [[self.class alloc] initWithUser:nil item:nil number:number page:nil filter:nil getProperties:false testEvents:nil];
}

+ (nullable instancetype)discoverRecommendations:(nullable NSNumber*) number page:(nullable NSNumber*) page filter:(nullable NSDictionary*)filter getProperties:(BOOL) getProperties testEvents:(nullable NSArray*) testEvents{
    return [[self.class alloc] initWithUser:nil item:nil number:number page:page filter:filter getProperties:getProperties testEvents:testEvents];
}

+ (nullable instancetype)discoverParamsWithUser:(nullable NSString*) user number:(nullable NSNumber*) number {
    return [[self.class alloc] initWithUser:user item:nil number:number page:nil filter:nil getProperties:false testEvents:nil];
}



- (instancetype)initWithUser:(NSString*) user item:(NSString*) item number:(NSNumber*)number page:(NSNumber*)page filter:(NSDictionary*)filter getProperties:(BOOL) getProperties testEvents:(NSArray*) testEvents {
    self = [super init];
    if (self) {
        _user = user;
        _item = item;
        _number = number;
        _page = page;
        _filter = filter;
        _getProperties = getProperties;
        _testEvents = testEvents;
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
             @"page": @"page",
             @"filter": @"filter",
             @"testEvents": @"test_events",
             @"getProperties": @"get_properties",
             };
}


@end
