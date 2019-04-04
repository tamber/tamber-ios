//
//  TMBUserSearchResponse.h
//  Tamber
//
//  Created by Alexander Robbins on 7/5/17.
//  Copyright © 2019 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMBObjectDecodable.h"
#import "TMBUser.h"

/**
 *  A `TMBUserSearchResponse` represents an array of deserialized User objects from the Tamber API's user/search endpoint. @see https://tamber.com/docs/api/#user-search
 */
@interface TMBUserSearchResponse : NSObject<TMBObjectDecodable>

/**
 * An array of `TMBUser` objects.
 */
@property (nonatomic, nullable) NSArray *users;


@end
