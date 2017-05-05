//
//  TMBParser.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>

@class TMBDiscoverParams, TMBEventParams;
@protocol TMBObjectEncodable;

@interface TMBEncoder : NSObject

+ (nonnull NSDictionary *)dictionaryForObject:(nonnull NSObject<TMBObjectEncodable> *)object;

+ (nonnull NSString *)stringByURLEncoding:(nonnull NSString *)string;

+ (nonnull NSString *)stringByReplacingSnakeCaseWithCamelCase:(nonnull NSString *)input;

+ (nonnull NSString *)queryStringFromParameters:(nonnull NSDictionary *)parameters;

@end

