//
//  TMBUserParams.h
//  Tamber
//
//  Created by Alexander Robbins on 7/5/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMBDiscoverParams.h"
#import "TMBObjectEncodable.h"

/**
 *  An object representing parameters used to make user commands. Not all parameters are needed for all requests. @see https://tamber.com/docs/api/#user
 */
@interface TMBUserParams : NSObject<TMBObjectEncodable>

/**
 *  Initialize empty user. TMBClient uses default user id when making relevant requests.
 */
+ (nullable instancetype)defaultUser;

/**
 *  Initialize user with id.
 */
+ (nullable instancetype)userWithId:(nonnull NSString *) userId;

/**
 *  Initialize user with metadata (TMBClient uses default user id when making relevant requests).
 */
+ (nullable instancetype)userWithMetadata:(nullable NSDictionary*) metadata;

/**
 *  Initialize user with metadata and events (array of TMBEventParams - user field should be empty or set to id of the given user). TMBClient uses default user id when making relevant requests.
 */
+ (nullable instancetype)userWithMetadata:(nullable NSDictionary*) metadata events:(nullable NSArray *) events;

/**
 *  Initialize user with id and metadata (TMBClient uses default user id when making relevant requests).
 */
+ (nullable instancetype)userWithId:(nonnull NSString *) userId metadata:(nullable NSDictionary*) metadata;

/**
 *  Initialize user with id, metadata, and events (TMBClient uses default user id when making relevant requests).
 */
+ (nullable instancetype)userWithId:(nonnull NSString *) userId metadata:(nullable NSDictionary*) metadata events:(nullable NSArray *) events;

- (nullable instancetype)initWithId:(nullable NSString *) userId metadata:(nullable NSDictionary*) metadata events:(nullable NSArray *) events;

/**
 *  Provide TMBDiscoverParams to return udpated recommendations for the user. If the user is created with events, recommendations will take these events into account.
 */
- (void) setGetRecs:(nonnull TMBDiscoverParams*)getRecs;

/**
 *  Unique ID associated with the user.
 */
@property (nonatomic, copy, nullable) NSString *ID;

/**
 *  List of all of the events (TMBEventParams) that are associated with the user (i.e. all passed user-item interactions).
 */
@property (nonatomic, copy, nullable) NSArray *events;

/**
 *  Data associated with the user.
 */
@property (nonatomic, copy, nullable) NSDictionary *metadata;

/**
 *  If you would like to  return new recommendations for the user, set getRecs (accepts number, page, and filter params). Note that all fields are optional, and an initialized, non-NULL TMBDiscoverParams instance (even if no properties/fields are set) will return recommendations.
 */
@property (nonatomic, copy, nullable) TMBDiscoverParams *getRecs;

@end
