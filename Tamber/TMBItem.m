//
//  TMBUser.m
//  Tamber
//
//  Created by Alexander Robbins on 7/5/17.
//  Copyright © 2017 Tamber. All rights reserved.
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
             };
}

@end

