//
//  TMBDiscoverResponse.m
//  Tamber
//
//  Created by Alexander Robbins on 5/4/17.
//  Copyright © 2020 Tamber. All rights reserved.
//

#import "TMBDiscoverResponse.h"
#import "TMBDiscovery.h"
#import "NSDictionary+Tamber.h"
#import "NSMutableArray+Tamber.h"

@implementation TMBDiscoverResponse

+ (NSArray *)requiredFields {
    return @[];
}

+ (instancetype)decodedObjectFromAPIResponse:(NSDictionary *)response {
    if (response[@"result"] == [NSNull null]){
        return nil;
    }
    TMBDiscoverResponse *discoverResponse = [self new];
    NSMutableArray *discoveries = [[NSMutableArray alloc] initWithCapacity:[response[@"result"] count]];
    for (NSDictionary *discoveryObj in response[@"result"]){
        TMBDiscovery *discovery = [TMBDiscovery decodedObjectFromAPIResponse:discoveryObj];
        [discoveries tmb_addObjectIfNotNil:discovery];
    }
    discoverResponse.discoveries = [discoveries copy];
    return discoverResponse;
}

@end
