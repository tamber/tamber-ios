//
//  TMBAPIRequest.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBAPIRequest.h"
#import "TMBClient.h"
#import "TMBEncoder.h"
#import "NSMutableURLRequest+Tamber.h"
#import "TMBDispatcher.h"

@implementation TMBAPIRequest

+ (NSURLSessionDataTask *)postWithAPIClient:(TMBClient *)apiClient
                                   endpoint:(NSString *)endpoint
                                 parameters:(NSDictionary *)parameters
                                 serializer:(id<TMBObjectDecodable>)serializer
                                 completion:(TMBAPIResponseBlock)completion {
    
    NSURL *url = [apiClient.apiUrl URLByAppendingPathComponent:endpoint];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request setValue:apiClient.auth forHTTPHeaderField:@"Authorization"];
    request.HTTPMethod = @"POST";
    NSString *query = [TMBEncoder queryStringFromParameters:parameters];
    request.HTTPBody = [query dataUsingEncoding:NSUTF8StringEncoding];
    
    NSURLSessionDataTask *task = [apiClient.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable body, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [[self class] parseResponse:response
                               body:body
                              error:error
                         serializer:serializer
                         completion:completion];
    }];
    [task resume];
    return task;
}

+ (NSURLSessionDataTask *)getWithAPIClient:(TMBClient *)apiClient
                                  endpoint:(NSString *)endpoint
                                parameters:(NSDictionary *)parameters
                                serializer:(id<TMBObjectDecodable>)serializer
                                completion:(TMBAPIResponseBlock)completion {
    
    NSURL *url = [apiClient.apiUrl URLByAppendingPathComponent:endpoint];
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL:url];
    [request tmb_addParametersToURL:parameters];
    [request setValue:apiClient.auth forHTTPHeaderField:@"Authorization"];
    request.HTTPMethod = @"GET";
    
    NSURLSessionDataTask *task = [apiClient.urlSession dataTaskWithRequest:request completionHandler:^(NSData * _Nullable body, NSURLResponse * _Nullable response, NSError * _Nullable error) {
        [[self class] parseResponse:response
                               body:body
                              error:error
                         serializer:serializer
                         completion:completion];
    }];
    [task resume];
    return task;
}

+ (void)parseResponse:(NSURLResponse *)response
                 body:(NSData *)body
                error:(NSError *)error
           serializer:(id<TMBObjectDecodable>)serializer
           completion:(TMBAPIResponseBlock)completion {
    
    NSDictionary *jsonDictionary = body ? [NSJSONSerialization JSONObjectWithData:body options:(NSJSONReadingOptions)kNilOptions error:NULL] : nil;
    id<TMBObjectDecodable> responseObject = [[serializer class] decodedObjectFromAPIResponse:jsonDictionary];
    NSString *returnedError = jsonDictionary[@"error"] ?: [error localizedDescription];
    if ((!responseObject || ![response isKindOfClass:[NSHTTPURLResponse class]]) && !returnedError) {
        returnedError = @"The response from Tamber failed to get parsed into valid JSON.";
    }
    
    NSHTTPURLResponse *httpResponse;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        httpResponse = (NSHTTPURLResponse *)response;
    }
    tmbDispatchToMainThreadIfNecessary(^{
        if (returnedError) {
            completion(nil, httpResponse, returnedError);
        } else {
            completion(responseObject, httpResponse, nil);
        }
    });
    
}

@end
