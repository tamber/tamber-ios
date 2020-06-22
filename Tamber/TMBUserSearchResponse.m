//
//  TMBUserSearchResponse.m
//  Tamber
//
//  Created by Alexander Robbins on 7/5/17.
//  Copyright © 2020 Tamber. All rights reserved.
//

#import "TMBUserSearchResponse.h"
#import "NSMutableArray+Tamber.h"

@implementation TMBUserSearchResponse

+ (NSArray *)requiredFields {
    return @[];
}

+ (instancetype)decodedObjectFromAPIResponse:(NSDictionary *)response {
    if (response[@"result"] == [NSNull null]){
        return nil;
    }
    TMBUserSearchResponse *searchResponse = [self new];
    NSMutableArray *users = [[NSMutableArray alloc] initWithCapacity:[response[@"result"] count]];
    for (NSDictionary *userObj in response[@"result"]){
        TMBUser *user = [TMBUser decodedObjectFromAPIResponse:userObj];
        [users tmb_addObjectIfNotNil:user];
    }
    searchResponse.users = [users copy];
    return searchResponse;
}

@end
