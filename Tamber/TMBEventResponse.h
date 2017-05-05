//
//  TMBEventResponse.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMBObjectDecodable.h"
#import "TMBDiscovery.h"

/**
 *  A `TMBEventResponse` represents an array of deserialized Event objects, and an array of deserialized Discovery objects from the Tamber API's event endpoint. @see https://tamber.com/docs/api/#event
 */
@interface TMBEventResponse : NSObject<TMBObjectDecodable>

/**
 * An array of `TMBEvent` objects. Because the `publishableProjectKey` does not allow event-retrieve operations, this array will only contain the event that was tracked (on success). @see https://tamber.com/docs/api/#event-object
 */
@property (nonatomic, nullable) NSArray *events;

/**
 * An array of `TMBDiscovery` objects. Is only set if the `TMBEventParams` passed had getRecs set.
 */
@property (nonatomic, nullable) NSArray *recs;


@end
