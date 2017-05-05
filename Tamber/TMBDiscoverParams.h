//
//  TMBDiscoverParams.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBEvent.h"
#import <Foundation/Foundation.h>
#import "TMBObjectEncodable.h"

/**
 *  An object representing parameters used to retrieve discoveries. Not all parameters are needed for all requests. @see https://tamber.com/docs/api/#discover
 */
@interface TMBDiscoverParams : NSObject<TMBObjectEncodable>

/**
 * The simplest way to get `TMBDiscoverParams` for user recommendations – only set the number of recommended items (`TMBDiscovery` objects) you want to return.
 * @warning The `TMBClient` userId must be set with `setUser`.
 * @param number Number of recommendations to return.
 */
+ (nullable instancetype)discoverRecommendations:(nullable NSNumber*) number;

/**
 * Expanded discover params for user recommendations.
 * @param number Number of recommendations to return. Maximum of 500.
 * @param page The page of recommended items to return.
 * @param filter The filter to apply on the discoveries. See https://tamber.com/docs/api/#filtering and our filtering guide at https://tamber.com/docs/guides/filtering.html for reference.
 * @param getProperties Include items' properties and tags in the discovery objects.
 * @param testEvents Recommendations will be made as if the supplied events had occurred, but the engine will not be affected in any way. Also works if the user that has not yet been created, allowing you to see what a visiting user’s recommendations would be. Warning: recommendations with test_events are generated at a lower priority of computational resources and are not representative of recommendation API performance.
 */
+ (nullable instancetype)discoverRecommendations:(nullable NSNumber*) number page:(nullable NSNumber*) page filter:(nullable NSDictionary*)filter getProperties:(BOOL) getProperties testEvents:(nullable NSArray*) testEvents;


/**
 * Discover params for user recommendations.
 * @param user User's unique identifier.
 * @param number Number of recommendations to return.
 */
+ (nullable instancetype)discoverParamsWithUser:(nullable NSString*) user number:(nullable NSNumber*) number;


/**
 *  Initialize discover params for user recommendations.
 * @param user User's unique identifier. Used for discover-recommended and discover-recommended_similar.
 * @param item Item's unique identifier. Used for discover-similar and discover-recommended_similar.
 * @param number Number of recommendations to return. Maximum of 500.
 * @param page The page of recommended items to return.
 * @param filter The filter to apply on the discoveries. See https://tamber.com/docs/api/#filtering and our filtering guide at https://tamber.com/docs/guides/filtering.html for reference.
 * @param getProperties Include items' properties and tags in the discovery objects.
 * @param testEvents Recommendations will be made as if the supplied events had occurred, but the engine will not be affected in any way. Also works if the user that has not yet been created, allowing you to see what a visiting user’s recommendations would be. Warning: recommendations with test_events are generated at a lower priority of computational resources and are not representative of recommendation API performance.
 */
- (nullable instancetype)initWithUser:(nullable NSString*) user item:(nullable NSString*) item number:(nullable NSNumber*)number page:(nullable NSNumber*)page filter:(nullable NSDictionary*)filter getProperties:(BOOL) getProperties testEvents:(nullable NSArray*) testEvents;

@property (nonatomic, copy, nullable) NSString *user;
@property (nonatomic, copy, nullable) NSString *item;
@property (nonatomic, readonly, nullable) NSNumber *number;
@property (nonatomic, readonly, nullable) NSNumber *page;
@property (nonatomic, readonly, nullable) NSDictionary *filter;
@property (nonatomic, readwrite) BOOL getProperties;
@property (nonatomic, readonly, nullable) NSArray *testEvents;


@end
