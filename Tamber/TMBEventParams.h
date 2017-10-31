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
 *  Initialize user event with an item, behavior, hit boolean, and context array (TMBClient uses default user when tracking event).
 */
+ (nullable instancetype)eventWithItem:(nonnull NSString*) item behavior:(nonnull NSString *)behavior hit:(BOOL)hit context:(nullable NSArray*)context;

/**
 *  Initialize user event with an item, behavior, amount, and created time (TMBClient uses default user when tracking event).
 */
+ (nullable instancetype)eventWithItem:(nonnull NSString*) item behavior:(nonnull NSString *)behavior amount:(nullable NSNumber*)amount created:(nullable NSDate*)created;

/**
 *  Initialize an event with a user, item and behavior.
 */
+ (nullable instancetype)eventWithUser:(nonnull NSString*) user item:(nonnull NSString*) item behavior:(nonnull NSString *)behavior;

/**
 *  Initialize an event with a user, item, behavior, amount, and created time.
 */
+ (nullable instancetype)eventWithUser:(nonnull NSString*) user item:(nonnull NSString*) item behavior:(nonnull NSString *)behavior amount:(nullable NSNumber*)amount created:(nullable NSDate*)created;

/**
 *  Initialize an event with a user, item, behavior, hit, and context.
 */
+ (nullable instancetype)eventWithUser:(nonnull NSString*) user item:(nonnull NSString*) item behavior:(nonnull NSString *)behavior hit:(BOOL)hit context:(nullable NSArray*)context;

/**
 *  Initialize the full event params with a user, item, behavior, amount, and created time.
 */
+ (nullable instancetype)eventWithUser:(nonnull NSString*) user item:(nonnull NSString*) item behavior:(nonnull NSString *)behavior amount:(nullable NSNumber*)amount hit:(BOOL)hit context:(nullable NSArray*)context created:(nullable NSDate*)created;

- (nullable instancetype)initWithUser:(nullable NSString*) user item:(nullable NSString*) item behavior:(nonnull NSString *)behavior amount:(nullable NSNumber*)amount hit:(BOOL)hit context:(nullable NSArray*)context created:(nullable NSDate*)created;

/**
 *  Provide TMBDiscoverParams to return udpated recommendations for the user, taking into account the event that is tracked.
 */
- (void) setGetRecs:(nonnull TMBDiscoverParams*)getRecs;

/**
 *  Initialize a session started item-less event.
 */
+ (nullable instancetype)sessionStarted;

+ (nullable instancetype)sessionStartedWithContext:(nullable NSArray*)context created:(nullable NSDate*)created;

/**
 *  Initialize a session ended item-less event.
 */
+ (nullable instancetype)sessionEnded;

+ (nullable instancetype)sessionEndedWithContext:(nullable NSArray*)context created:(nullable NSDate*)created;

/**
 *  Initialize a push rendered item-less event.
 */
+ (nullable instancetype)pushRendered;

+ (nullable instancetype)pushRenderedWithContext:(nullable NSArray*)context created:(nullable NSDate*)created;

/**
 *  Initialize a push received item-less event.
 */
+ (nullable instancetype)pushReceived;

+ (nullable instancetype)pushReceivedWithContext:(nullable NSArray*)context created:(nullable NSDate*)created;

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
@property (nonatomic, copy, nullable) NSArray *context;

/**
 *  Time the event occurred. Defaults to the current time if not supplied.
 */
@property (nonatomic, copy, nullable) NSDate *created;

/**
 *  If you would like to instantly return new recommendations for the user, set getRecs (accepts number, page, and filter params). Note that all fields are optional, and adding a non NULL TMBDiscoverParams instance will return recommendations.
 */
@property (nonatomic, copy, nullable) TMBDiscoverParams *getRecs;

@end
