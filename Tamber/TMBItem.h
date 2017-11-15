//
//  TMBUser.h
//  Tamber
//
//  Created by Alexander Robbins on 7/5/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMBObjectDecodable.h"
#import "TMBObjectEncodable.h"

/**
 *  A `TMBUser` represents a User object. @see https://tamber.com/docs/api/#user-object
 */
@interface TMBItem : NSObject<TMBObjectEncodable,TMBObjectDecodable>

/**
 *  Unique ID associated with the user.
 */
@property (nonatomic, copy, nullable) NSString *ID;

/**
 *  Data associated with the user.
 */
@property (nonatomic, copy, nullable) NSDictionary *properties;

/**
 *  List of all items recommended to the user.
 */
@property (nonatomic, copy, nullable) NSArray *tags;

/**
 *  Time the user was created.
 */
@property (nonatomic, copy, nullable) NSDate *created;

@end

