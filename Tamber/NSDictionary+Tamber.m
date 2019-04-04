//
//  NSDictionary+Tamber.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2019 Tamber. All rights reserved.
//

#import "NSDictionary+Tamber.h"
#import "NSMutableArray+Tamber.h"

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

-(NSString*) tmb_json {
    NSError *error;
    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:self
                                                       options:(NSJSONWritingOptions) (0)
                                                         error:&error];
    
    if (! jsonData) {
        NSLog(@"NSDictionary+Tamber tmb_json error: %@", error.localizedDescription);
        return @"{}";
    } else {
        return [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    }
}

@end

void linkNSDictionaryCategory(void){}
