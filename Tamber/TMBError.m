//
//  TMBError.m
//  Tamber
//
//  Created by Alexander Robbins on 7/17/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBError.h"

NSString *const TamberDomain = @"com.tamber.lib";
NSString *const TMBErrorCodeKey = @"com.tamber.lib:ErrorCodeKey";

@implementation NSError(Tamber)

+ (NSError *)tmb_error:(NSDictionary *)jsonDictionary statusCode:(NSInteger) statusCode {
    NSString *errorMessage = jsonDictionary[@"error"];
    if (!errorMessage) {
        return nil;
    }
    NSString *errorCodeStr = [NSString stringWithFormat: @"%ld", (long)statusCode];
    NSDictionary *errorInfo = @{
                               NSLocalizedDescriptionKey: errorMessage,
                               TMBErrorCodeKey: errorCodeStr
                               };
    return [[self alloc] initWithDomain:TamberDomain code:statusCode userInfo:errorInfo];
}

+ (nullable NSError *)tmb_defaultJSONParseError {
    NSDictionary *errorInfo = @{
                                NSLocalizedDescriptionKey: @"The response from Tamber failed to get parsed into valid JSON.",
                                TMBErrorCodeKey: @"60"
                                };
    return [[self alloc] initWithDomain:TamberDomain code:60 userInfo:errorInfo];
}
@end
