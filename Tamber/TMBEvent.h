//
//  TMBEvent.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2020 Tamber. All rights reserved.
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
 *  Represents the amount that the behavior was performed. Defaults to 1.0 if not supplied.
 */
@property (nonatomic, nullable) NSNumber* amount;

/**
 *  Indicates that the event represents a successful recommendation (ex. user 'clicks' an item in their recommended items list). This is used in Tamber's analytics tools to track how recommendations impact user behavior.
 */
@property (nonatomic) BOOL hit;

/**
 *  The context(s) in which the event occurred. Useful for segmenting events data to determine the impact of interface elements and other contextual variables on user behavior. Also useful for A/B testing interface changes.
 */
@property (nonatomic, copy, nullable) NSDictionary *context;

/**
 *  Time the event occurred. Defaults to the current time if not supplied.
 */
@property (nonatomic, copy, nullable) NSDate *created;

@end
