//
//  TMBDiscoverNextParams.h
//  Tamber
//
//  Created by Alexander Robbins on 10/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMBObjectEncodable.h"

/**
 *  An object representing parameters used to retrieve discoveries. Not all parameters are needed for all requests. @see https://tamber.com/docs/api/#discover
 */
@interface TMBDiscoverNextParams : NSObject<TMBObjectEncodable>

/**
 * The simplest way to get `TMBDiscoverNextParams` for user recommendations – only set the number of recommended items (`TMBDiscovery` objects) you want to return.
 * @warning The `TMBClient` userId must be set with `setUser`.
 * @param number Number of recommendations to return.
 */
+ (nullable instancetype)discoverNext:(nullable NSNumber*) number;

/**
 * The simplest way to get `TMBDiscoverNextParams` for a given item. If `TMBClient` userId has been set, the results will be tuned for the user.
 * @param number Number of recommendations to return.
 */
+ (nullable instancetype)discoverNextWithItem:(nullable NSString*) item number:(nullable NSNumber*) number;

/**
 * Expanded discover params for user recommendations.
 * @param item Item's unique identifier. Used for discover-similar and discover-recommended_similar.
 * @param number Number of recommendations to return. Maximum of 200.
 * @param excludeItems List of item ids to exclude from results. Useful for hiding items that are already being displayed to the user.
 * @param variability Represents the degree of variability applied to the results. variability helps make results more dynamic, and is intelligently weighted to prioritize higher-scoring results (i.e. it does not just shuffle the results). Defaults to 0 if not supplied.
 * @param filter The filter to apply on the discoveries. See https://tamber.com/docs/api/#filtering and our filtering guide at https://tamber.com/docs/guides/filtering.html for reference.
 * @param getProperties Include items' properties and tags in the discovery objects.
 */
+ (nullable instancetype)discoverNext:(nullable NSString*) item number:(nullable NSNumber*) number excludeItems:(nullable NSArray*) excludeItems variability:(nullable NSNumber*) variability  filter:(nullable NSDictionary*)filter getProperties:(BOOL) getProperties;


/**
 * DiscoverNext params for user recommendations.
 * @param user User's unique identifier.
 * @param number Number of recommendations to return.
 */
+ (nullable instancetype)discoverNextParamsWithUser:(nullable NSString*) user number:(nullable NSNumber*) number;

/**
 * DiscoverNext params for user-item recommendations.
 * @param user User's unique identifier.
 * @param number Number of recommendations to return.
 */
+ (nullable instancetype)discoverNextParamsWithUser:(nullable NSString*) user item:(nullable NSString*) item number:(nullable NSNumber*) number;


/**
 *  Initialize discover params for user recommendations.
 * @param user User's unique identifier. Used for discover-recommended and discover-recommended_similar.
 * @param item Item's unique identifier. Used for discover-similar and discover-recommended_similar.
 * @param number Number of recommendations to return. Maximum of 200.
 * @param excludeItems List of item ids to exclude from results. Useful for hiding items that are already being displayed to the user.
 * @param variability Represents the degree of variability applied to the results. Variability helps make results more dynamic, and is intelligently weighted to prioritize higher-scoring results (i.e. it does not just shuffle the results). Defaults to 0 if not supplied.
 * @param filter The filter to apply on the discoveries. See https://tamber.com/docs/api/#filtering and our filtering guide at https://tamber.com/docs/guides/filtering.html for reference.
 * @param getProperties Include items' properties and tags in the discovery objects.
 */
- (nullable instancetype)initWithUser:(nullable NSString*) user item:(nullable NSString*) item number:(nullable NSNumber*)number excludeItems:(nullable NSArray*) excludeItems variability:(nullable NSNumber*)variability filter:(nullable NSDictionary*)filter getProperties:(BOOL) getProperties;

@property (nonatomic, copy, nullable) NSString *user;
@property (nonatomic, copy, nullable) NSString *item;
@property (nonatomic, readonly, nullable) NSNumber *number;

/**
 *  List of item ids to exclude from results. Useful for hiding items that are already being displayed to the user.
 */
@property (nonatomic, readonly, nullable) NSArray *excludeItems;

/**
 *  Represents the degree of variability applied to the results. Variability helps make results more dynamic, and is intelligently weighted to prioritize higher-scoring results (i.e. it does not just shuffle the results). Defaults to 0 if not supplied.
 */
@property (nonatomic, nullable) NSNumber* variability;
@property (nonatomic, readonly, nullable) NSDictionary *filter;
@property (nonatomic, readwrite) BOOL getProperties;



@end
