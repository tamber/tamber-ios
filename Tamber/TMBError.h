//
//  TMBError.h
//  Tamber
//
//  Created by Alexander Robbins on 7/17/17.
//  Copyright © 2020 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN
static  NSString *const TamberDomain = @"com.tamber.lib";
static  NSString *const TMBErrorCodeKey = @"com.tamber.lib:ErrorCodeKey";
NS_ASSUME_NONNULL_END

@interface NSError(Tamber)

+ (nullable NSError *)tmb_error:(nullable NSDictionary *)jsonDictionary statusCode:(NSInteger) statusCode ;
+ (nullable NSError *)tmb_defaultJSONParseError ;
@end
