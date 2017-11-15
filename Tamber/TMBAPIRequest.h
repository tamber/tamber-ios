//
//  TMBAPIRequest.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//
//  Stolen from Stripe's iOS SDK - STPAPIRequest

#import <Foundation/Foundation.h>
#import "TMBObjectDecodable.h"

@class TMBClient;

@interface TMBAPIRequest<__covariant ResponseType:id<TMBObjectDecodable>> : NSObject

typedef void(^TMBAPIResponseBlock)(ResponseType object, NSHTTPURLResponse *response, NSError *error);

+ (NSURLSessionDataTask *)postWithAPIClient:(TMBClient *)apiClient
                                   endpoint:(NSString *)endpoint
                                 parameters:(NSDictionary *)parameters
                                 serializer:(ResponseType)serializer
                                 completion:(TMBAPIResponseBlock)completion;

+ (NSURLSessionDataTask *)getWithAPIClient:(TMBClient *)apiClient
                                  endpoint:(NSString *)endpoint
                                parameters:(NSDictionary *)parameters
                                serializer:(id<TMBObjectDecodable>)serializer
                                completion:(TMBAPIResponseBlock)completion;

@end
