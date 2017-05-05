//
//  TMBDiscovery.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBDiscovery.h"
#import "NSDictionary+Tamber.h"

@implementation TMBDiscovery

+ (NSArray *)requiredFields {
    return @[@"item", @"score", @"item_created"];
}

+ (instancetype)decodedObjectFromAPIResponse:(NSDictionary *)response {
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


@end

