//
//  TMBDiscoverResponse.h
//  Tamber
//
//  Created by Alexander Robbins on 5/4/17.
//  Copyright © 2019 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMBObjectDecodable.h"

/**
 *  A `TMBDiscoverResponse` contains an array of deserialized Discovery objects.
 */
@interface TMBDiscoverResponse : NSObject<TMBObjectDecodable>

/**
 * An array of deserialized `TMBDiscovery` objects.
 */
@property (nonatomic, nullable) NSArray *discoveries;

@end
