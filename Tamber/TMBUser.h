//
//  TMBUser.h
//  Tamber
//
//  Created by Alexander Robbins on 7/5/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMBObjectDecodable.h"

/**
 *  A `TMBUser` represents a User object. @see https://tamber.com/docs/api/#user-object
 */
@interface TMBUser : NSObject<TMBObjectDecodable>

/**
 *  Unique ID associated with the user.
 */
@property (nonatomic, copy, nullable) NSString *ID;

/**
 *  List of all of the events that are associated with the user (i.e. all passed user-item interactions).
 */
@property (nonatomic, copy, nullable) NSArray *events;

/**
 *  List of all items recommended to the user.
 */
@property (nonatomic, copy, nullable) NSArray *recs;

/**
 *  Data associated with the user.
 */
@property (nonatomic, copy, nullable) NSDictionary *metadata;

/**
 *  Time the user was created.
 */
@property (nonatomic, copy, nullable) NSDate *created;

@end
