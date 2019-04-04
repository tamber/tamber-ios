//
//  TMBEventResponse.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2019 Tamber. All rights reserved.
//

#import "TMBEventResponse.h"
#import "TMBEvent.h"
#import "NSDictionary+Tamber.h"
#import "NSMutableArray+Tamber.h"

@implementation TMBEventResponse

+ (NSArray *)requiredFields {
    return @[@"events"];
}

+ (instancetype)decodedObjectFromAPIResponse:(NSDictionary *)response {
    if (response[@"result"] == [NSNull null]){
        return nil;
    }
    NSDictionary *result = [response[@"result"] tmb_dictionaryByRemovingNullsValidatingRequiredFields:[self requiredFields]];
    if (!result) {
        return nil;
    }
    
    TMBEventResponse *eventResponse = [self new];
    
    NSMutableArray *events = [[NSMutableArray alloc] init];
    for (NSDictionary *eventDict in result[@"events"]){
        TMBEvent *event = [TMBEvent decodedObjectFromAPIResponse:eventDict];
        [events tmb_addObjectIfNotNil:event];
    }
    eventResponse.events = [events copy];
    
    if(result[@"recommended"] != nil){
        NSMutableArray *recs = [[NSMutableArray alloc] init];
        for (NSDictionary *discoveryDict in result[@"recommended"]){
            TMBDiscovery *discovery = [TMBDiscovery decodedObjectFromAPIResponse:discoveryDict];
            [recs tmb_addObjectIfNotNil:discovery];
        }
        eventResponse.recs = [recs copy];
    }
    
    return eventResponse;
}

@end
