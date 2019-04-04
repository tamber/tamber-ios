//
//  TMBAPIRequest.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2019 Tamber. All rights reserved.
//

//#import <Tamber/TMBAPIRequest.h>
#import "TMBAPIRequest.h"
#import "TMBEncoder.h"
#import "NSMutableURLRequest+Tamber.h"
#import "TMBDispatcher.h"
//#import <Tamber/TMBClient.h>
#import "TMBClient.h"
#import "TMBError.h"

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
    LogDebug(@"parameters: %@", parameters);
    NSString *query = [TMBEncoder queryStringFromParameters:parameters];
    LogDebug(@"query: %@", query);
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
    LogDebug(@"parameters: %@", parameters);
    [request tmb_addParametersToURL:parameters];
    LogDebug(@"request query: %@", request.URL.absoluteString);
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
    if(!error){
        NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse *) response;
        error = [NSError tmb_error:jsonDictionary statusCode:[httpResponse statusCode]]; // only sets error if error field is set in response, which is only true when there is an error.
    }
//    NSString *errorMessage = jsonDictionary[@"error"] ?: [error localizedDescription];
    if ((!responseObject || ![response isKindOfClass:[NSHTTPURLResponse class]]) && !error) {
        error = [NSError tmb_defaultJSONParseError];
    }
    
    NSHTTPURLResponse *httpResponse;
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        httpResponse = (NSHTTPURLResponse *)response;
    }
    
    tmbDispatchToMainThreadIfNecessary(^{
        if (error) {
            completion(nil, httpResponse, error);
        } else {
            completion(responseObject, httpResponse, nil);
        }
    });
    
}

@end
