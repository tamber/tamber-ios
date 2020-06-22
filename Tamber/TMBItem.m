//
//  TMBItem.m
//  Tamber
//
//  Created by Alexander Robbins on 11/10/17.
//  Copyright © 2020 Tamber. All rights reserved.
//

#import "TMBItem.h"
#import "NSDictionary+Tamber.h"

@implementation TMBItem

@synthesize additionalAPIParameters = _additionalAPIParameters;

- (instancetype)init {
    self = [super init];
    if (self) {
        _additionalAPIParameters = @{};
    }
    return self;
}

+ (instancetype)itemWithId:(NSString *) ID {
    return [[self.class alloc] initWithId:ID properties:nil tags:nil created:nil];
}

+ (instancetype)itemWithId:(NSString *) ID properties:(NSDictionary *)properties tags:(NSArray *) tags{
    return [[self.class alloc] initWithId:ID properties:properties tags:tags created:nil];
}

+ (instancetype)itemWithId:(NSString *) ID properties:(NSDictionary *)properties tags:(NSArray *) tags created:(NSDate*)created{
    return [[self.class alloc] initWithId:ID properties:properties tags:tags created:created];
}

- (instancetype)initWithId:(NSString *) ID properties:(NSDictionary *)properties tags:(NSArray *) tags created:(NSDate*)created {
    self = [super init];
    if (self) {
        _ID = ID;
        _properties = properties;
        _tags = tags;
        _created = created;
    }
    return self;
}

+ (NSArray *)requiredFields {
    return @[@"id"];
}

+ (instancetype)decodedObjectFromAPIResponseSubField:(NSDictionary *)response {
    NSDictionary *result = [response tmb_dictionaryByRemovingNullsValidatingRequiredFields:[self requiredFields]];
    if (!result) {
        return nil;
    }
    TMBItem *item = [self new];
    item.ID = result[@"id"];
    item.tags = result[@"tags"];
    item.properties = result[@"properties"];
    item.created = [NSDate dateWithTimeIntervalSince1970:[result[@"created"] doubleValue]];
    return item;
}


+ (instancetype)decodedObjectFromAPIResponse:(NSDictionary *)response {
    TMBItem *item;
    if([[response allKeys] containsObject:@"result"]){
        if (response[@"result"] == [NSNull null]){
            return nil;
        }
        NSDictionary *result = [response[@"result"] tmb_dictionaryByRemovingNullsValidatingRequiredFields:[self requiredFields]];
        if (!result) {
            return nil;
        }
        item = [self decodedObjectFromAPIResponseSubField:result];
    } else {
        item = [self decodedObjectFromAPIResponseSubField:response];
    }
    return item;
}

#pragma mark - TMBObjectEncodable

+ (NSString *)rootObjectName {
    return nil;
}

+ (NSDictionary *)propertyNamesToFormFieldNamesMapping {
    return @{
             @"ID": @"id",
             @"properties": @"properties",
             @"tags": @"tags",
             @"created": @"created",
             @"hidden": @"hidden",
             };
}

@end

