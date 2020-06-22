//
//  TMBDiscovery.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2020 Tamber. All rights reserved.
//

#import "TMBDiscovery.h"
#import "NSDictionary+Tamber.h"

@implementation TMBDiscovery

+ (NSArray *)requiredFields {
    return @[@"item", @"score", @"item_created"];
}

+ (instancetype)decodedObjectFromAPIResponse:(NSDictionary *)response {
    LogDebug(@"response:%@", response);
    NSDictionary *result = [response tmb_dictionaryByRemovingNullsValidatingRequiredFields:[self requiredFields]];
    if (!result) {
        return nil;
    }
    TMBDiscovery *discovery = [self new];
    discovery.item = result[@"item"];
    discovery.score = result[@"score"];
    discovery.popularity = result[@"popularity"];
    discovery.hotness = result[@"hotness"];
    discovery.properties = result[@"properties"];
    discovery.tags = result[@"tags"];
    discovery.created = [NSDate dateWithTimeIntervalSince1970:[result[@"item_created"] doubleValue]];
    return discovery;
}

+ (NSDictionary *)propertyNamesToFormFieldNamesMapping {
    return @{
             @"item": @"item",
             @"score": @"score",
             @"popularity": @"popularity",
             @"hotness": @"hotness",
             @"properties": @"properties",
             @"tags": @"tags",
             @"created": @"item_created",
             };
}

-(NSDictionary *) dict{
    NSMutableDictionary *keyPairs = [NSMutableDictionary dictionary];
    [[TMBDiscovery propertyNamesToFormFieldNamesMapping] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull propertyName, NSString *  _Nonnull formFieldName, __unused BOOL * _Nonnull stop) {
        id value = [self valueForKey:propertyName];
        if (value) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                NSDictionary *encodedValueTemp = [[NSMutableDictionary alloc] initWithDictionary:value];
                keyPairs[formFieldName] =  [encodedValueTemp copy];
            } else if ([value isKindOfClass:[NSArray class]]) {
                NSMutableArray *encodedValueTemp = [[NSMutableArray alloc] init];
                for(NSObject* obj in value){
                    [encodedValueTemp addObject:obj];
                }
                NSArray *encodedValue = [encodedValueTemp copy];
                keyPairs[formFieldName] = encodedValue;
            } else if ([value isKindOfClass:[NSDate class]]) {
                keyPairs[formFieldName] =  [NSNumber numberWithDouble:[value timeIntervalSinceReferenceDate]];
            } else {
                keyPairs[formFieldName] = value;
            }
        }
    }];
    return keyPairs;
}

@end

