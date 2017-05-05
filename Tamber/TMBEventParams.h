//
//  TMBEventParams.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMBDiscoverParams.h"
#import "TMBObjectEncodable.h"

/**
 *  Representation of a user-item interaction event. You can create event params to track events as users interact with items in your app. Novel users and items are automatically created. @see https://tamber.com/docs/api/#event-track
 */
@interface TMBEventParams : NSObject<TMBObjectEncodable>

/**
 *  Initialize user event with an item and behavior (TMBClient uses default user when tracking event).
 */
+ (nullable instancetype)eventWithItem:(nonnull NSString*) item behavior:(nonnull NSString *)behavior;

/**
 *  Initialize user event with an item, behavior, value, and created time (TMBClient uses default user when tracking event).
 */
+ (nullable instancetype)eventWithItem:(nonnull NSString*) item behavior:(nonnull NSString *)behavior value:(nullable NSNumber*)value created:(nullable NSDate*)created;

/**
 *  Initialize an event with a user, item and behavior.
 */
+ (nullable instancetype)eventWithUser:(nonnull NSString*) user item:(nonnull NSString*) item behavior:(nonnull NSString *)behavior;

/**
 *  Initialize the full event params with a user, item, behavior, value, and created time.
 */
+ (nullable instancetype)eventWithUser:(nonnull NSString*) user item:(nonnull NSString*) item behavior:(nonnull NSString *)behavior value:(nullable NSNumber*)value created:(nullable NSDate*)created;

- (nullable instancetype)initWithUser:(nullable NSString*) user item:(nonnull NSString*) item behavior:(nonnull NSString *)behavior value:(nullable NSNumber*)value created:(nullable NSDate*)created;

/**
 *  Provide TMBDiscoverParams to return udpated recommendations for the user, taking into account the event that is tracked.
 */
- (void) setGetRecs:(nonnull TMBDiscoverParams*)getRecs;

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

/**
 *  If you would like to instantly return new recommendations for the user, set getRecs (accepts number, page, and filter params). Note that all fields are optional, and adding a non NULL TMBDiscoverParams instance will return recommendations.
 */
@property (nonatomic, copy, nullable) TMBDiscoverParams *getRecs;

@end
