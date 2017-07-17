//
//  TMBError.h
//  Tamber
//
//  Created by Alexander Robbins on 7/17/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>

FOUNDATION_EXPORT NSString * __nonnull const StripeDomain;

@interface NSError(Tamber)

+ (nullable NSError *)tmb_error:(nullable NSDictionary *)jsonDictionary statusCode:(NSInteger) statusCode ;
+ (nullable NSError *)tmb_defaultJSONParseError ;
@end
