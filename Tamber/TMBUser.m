//
//  TMBUser.m
//  Tamber
//
//  Created by Alexander Robbins on 7/5/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBUser.h"
#import "TMBEvent.h"
#import "TMBDiscovery.h"
#import "NSDictionary+Tamber.h"
#import "NSMutableArray+Tamber.h"

@implementation TMBUser

+ (NSArray *)requiredFields {
    return @[@"id", @"created"];
}

+ (instancetype)decodedObjectFromAPIResponseSubField:(NSDictionary *)response {
    NSDictionary *result = [response tmb_dictionaryByRemovingNullsValidatingRequiredFields:[self requiredFields]];
    if (!result) {
        return nil;
    }
    TMBUser *user = [self new];
    user.ID = result[@"id"];
    
    NSMutableArray *events = [NSMutableArray new];
    for (NSDictionary *eventDict in result[@"events"]){
        TMBEvent *event = [TMBEvent decodedObjectFromAPIResponse:eventDict];
        [events tmb_addObjectIfNotNil:event];
    }
    user.events = [events copy];
    
    if(result[@"recommended"] != nil){
        NSMutableArray *recs = [NSMutableArray new];
        for (NSDictionary *discoveryDict in result[@"recommended"]){
            TMBDiscovery *discovery = [TMBDiscovery decodedObjectFromAPIResponse:discoveryDict];
            [recs tmb_addObjectIfNotNil:discovery];
        }
        user.recs = [recs copy];
    }
    
    user.metadata = result[@"metadata"];
    user.created = [NSDate dateWithTimeIntervalSince1970:[result[@"created"] doubleValue]];
    return user;
}

+ (instancetype)decodedObjectFromAPIResponse:(NSDictionary *)response {
    TMBUser *user;
    if([[response allKeys] containsObject:@"result"]){
        if (response[@"result"] == [NSNull null]){
            return nil;
        }
        NSDictionary *result = [response[@"result"] tmb_dictionaryByRemovingNullsValidatingRequiredFields:[self requiredFields]];
        if (!result) {
            return nil;
        }
        user = [self decodedObjectFromAPIResponseSubField:result];
    } else {
        user = [self decodedObjectFromAPIResponseSubField:response];
    }
    return user;
}

@end
