//
//  NSArray+Tamber.m
//  Tamber
//
//  Created by Alexander Robbins on 7/6/17.
//  Copyright © 2019 Tamber. All rights reserved.
//

#import "NSArray+Tamber.h"

@implementation NSArray (Tamber)

- (NSString *) tmb_json {
    NSString* json = nil;
    
    NSError* error = nil;
    NSData *data = [NSJSONSerialization dataWithJSONObject:self options:0 error:&error];
    json = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    return (error ? nil : json);
}

@end

void linkNSArrayCategory(void){}
