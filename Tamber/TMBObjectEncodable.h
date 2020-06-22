//
//  TMBObjectEncodable.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2020 Tamber. All rights reserved.
//
//  Based on Stripe's STPFormEncodable Class

#import <Foundation/Foundation.h>
NS_ASSUME_NONNULL_BEGIN

/**
 * Tamber Encodable Objects can be parsed to form-encoded strings
 */
@protocol TMBObjectEncodable <NSObject>

/**
 * The root object name to be used when converting this object to/from a form-encoded string.
 */
+ (nullable NSString *)rootObjectName;

/**
 * This maps properties on an object that is being form-encoded into parameter names in the Tamber API.
 */
+ (NSDictionary *)propertyNamesToFormFieldNamesMapping;

/**
 * You can use this property to add additional fields to an API request that are not explicitly defined by the object's interface. This can be useful when using beta features that haven't been added to the Tamber SDK yet.
 */
@property(nonatomic, readwrite, copy)NSDictionary *additionalAPIParameters;


@end
NS_ASSUME_NONNULL_END
