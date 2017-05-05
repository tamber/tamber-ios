//
//  TMBEvent.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMBObjectDecodable.h"

/**
 *  A `TMBEvent` represents an Event object. @see https://tamber.com/docs/api/#event-object
 */
@interface TMBEvent : NSObject<TMBObjectDecodable>

/**
 *  User associated with the event.
 */
@property (nonatomic, copy, nullable) NSString *user;

/**
 *  Item associated with the event.
 */
@property (nonatomic, copy, nullable) NSString *item;

/**
 *  The behavior name.
 */
@property (nonatomic, copy, nullable) NSString *behavior;

/**
 *  A value that represents the amount that the behavior was performed. Defaults to 1.0 if not supplied.
 */
@property (nonatomic, nullable) NSNumber* value;

/**
 *  Time the event occurred. Defaults to the current time if not supplied.
 */
@property (nonatomic, copy, nullable) NSDate *created;

@end
