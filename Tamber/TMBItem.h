//
//  TMBItem.h
//  Tamber
//
//  Created by Alexander Robbins on 11/10/17.
//  Copyright © 2020 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMBObjectDecodable.h"
#import "TMBObjectEncodable.h"

/**
 *  A `TMBItem` represents a User object. @see https://tamber.com/docs/api/#item-object
 */
@interface TMBItem : NSObject<TMBObjectEncodable,TMBObjectDecodable>

+ (nullable instancetype)itemWithId:(nullable NSString *) ID;

+ (nullable instancetype)itemWithId:(nullable NSString *) ID properties:(nullable NSDictionary *)properties tags:(nullable NSArray *) tags;

+ (nullable instancetype)itemWithId:(nullable NSString *) ID properties:(nullable NSDictionary *)properties tags:(nullable NSArray *) tags created:(nullable NSDate*)created;

- (nullable instancetype)initWithId:(nullable NSString *) ID properties:(nullable NSDictionary *)properties tags:(nullable NSArray *) tags created:(nullable NSDate*)created;
/**
 *  Unique ID associated with the item.
 */
@property (nonatomic, copy, nullable) NSString *ID;

/**
 *  Properties associated with the item.
 */
@property (nonatomic, copy, nullable) NSDictionary *properties;

/**
 *  List of all tags assigned to the item.
 */
@property (nonatomic, copy, nullable) NSArray *tags;

/**
 *  Time the item was created.
 */
@property (nonatomic, copy, nullable) NSDate *created;

/**
 *  Indicates that the item is hidden from all users.
 */
@property (nonatomic) BOOL hidden;

@end

