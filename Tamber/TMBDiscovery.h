//
//  TMBDiscovery.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBUtils.h"
#import "TMBObjectDecodable.h"

// A `TMBDiscovery` represents a Discovery object.
@interface TMBDiscovery : NSObject<TMBObjectDecodable>

/**
 *  Item associated with the event.
 */
@property (nonatomic, copy, nullable) NSString *item;

/**
 *  Recommendation score (relative to other results, not a predicted rating)
 */
@property (nonatomic, nullable) NSNumber *score;

/**
 *  Popularity score of the given item.
 */
@property (nonatomic, nullable) NSNumber *popularity;

/**
 *  Popularity score of the given item.
 */
@property (nonatomic, nullable) NSNumber *hotness;

/**
 *  Properties for the given item. Only included if `getProperties` is set in the `TMBDiscoverParams`.
 */
@property (nonatomic, nullable) NSDictionary *properties;

/**
 *  Tags for the given item. Only included if `getProperties` is set in the `TMBDiscoverParams`.
 */
@property (nonatomic, nullable) NSArray *tags;

/**
 *  Time the given item was created.
 */
@property (nonatomic, nullable) NSDate *created;

-(nullable NSDictionary *) dict;

@end


