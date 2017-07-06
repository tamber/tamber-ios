//
//  TMBEvent.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBEvent.h"
#import "NSDictionary+Tamber.h"

@implementation TMBEvent

+ (NSArray *)requiredFields {
    return @[@"user", @"item", @"behavior", @"value", @"created"];
}

+ (instancetype)decodedObjectFromAPIResponse:(NSDictionary *)response {
    NSDictionary *result = [response tmb_dictionaryByRemovingNullsValidatingRequiredFields:[self requiredFields]];
    if (!result) {
        return nil;
    }
    TMBEvent *event = [self new];
    event.user = result[@"user"];
    event.item = result[@"item"];
    event.behavior = result[@"behavior"];
    event.value = result[@"value"];
    if([[result allKeys] containsObject:@"hit"]){
        event.hit = [result[@"hit"] boolValue];
    }
    event.context = [result objectForKey:@"context"];
    event.created = [NSDate dateWithTimeIntervalSince1970:[result[@"created"] doubleValue]];
    return event;
}

@end
