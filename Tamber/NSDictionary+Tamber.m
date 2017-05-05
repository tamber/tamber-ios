//
//  NSDictionary+Tamber.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "NSDictionary+Tamber.h"

@implementation NSDictionary (Tamber)

- (nullable NSDictionary *)tmb_dictionaryByRemovingNullsValidatingRequiredFields:(nonnull NSArray *)requiredFields {
    NSMutableDictionary *dict = [NSMutableDictionary dictionary];
    [self enumerateKeysAndObjectsUsingBlock:^(id key, id obj, __unused BOOL *stop) {
        if (obj != [NSNull null]) {
            dict[key] = obj;
        }
    }];
    for (NSString *key in requiredFields) {
        if (![[dict allKeys] containsObject:key]) {
            return nil;
        }
    }
    return [dict copy];
}

@end

void linkNSDictionaryCategory(void){}
