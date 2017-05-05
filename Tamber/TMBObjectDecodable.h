//
//  TMBObjectDecodable.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 * Tamber Decodable Objects can be parsed from NSJSON Serialized API responses.
 */
@protocol TMBObjectDecodable <NSObject>

/**
 * Parses a response from the Tamber API (in JSON format; represented as an `NSDictionary`) into an instance of the class. Returns nil if the object could not be decoded. */
+ (nullable instancetype)decodedObjectFromAPIResponse:(nullable NSDictionary *)response;

@end
