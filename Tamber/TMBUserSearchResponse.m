//
//  TMBUserSearchResponse.m
//  Tamber
//
//  Created by Alexander Robbins on 7/5/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBUserSearchResponse.h"

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
        [users addObject:user];
    }
    searchResponse.users = [users copy];
    return searchResponse;
}

@end
