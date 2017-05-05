//
//  NSMutableURLRequest+Tamber.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//
//  Same as Stripe's NSMutableURLRequest but name space changed

#import "NSMutableURLRequest+Tamber.h"
#import "TMBEncoder.h"

@implementation NSMutableURLRequest (Tamber)

- (void)tmb_addParametersToURL:(NSDictionary *)parameters {
    NSString *query = [TMBEncoder queryStringFromParameters:parameters];
    NSString *urlString = [self.URL absoluteString];
    self.URL = [NSURL URLWithString:[urlString stringByAppendingFormat:self.URL.query ? @"&%@" : @"?%@", query]];
}

- (void)tmb_setFormPayload:(NSDictionary *)formPayload {
    NSData *formData = [[TMBEncoder queryStringFromParameters:formPayload] dataUsingEncoding:NSUTF8StringEncoding];
    self.HTTPBody = formData;
    [self setValue:[NSString stringWithFormat:@"%lu", (unsigned long)formData.length] forHTTPHeaderField:@"Content-Length"];
    [self setValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
}

- (void)tmb_setMultipartFormData:(NSData *)data boundary:(NSString *)boundary {
    self.HTTPBody = data;
    [self setValue:[NSString stringWithFormat:@"%lu", (unsigned long)data.length] forHTTPHeaderField:@"Content-Length"];
    [self setValue:[NSString stringWithFormat:@"multipart/form-data; boundary=%@", boundary] forHTTPHeaderField:@"Content-Type"];
}

@end

void linkNSMutableURLRequestCategory(void){}
