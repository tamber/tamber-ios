//
//  NSMutableURLRequest+Tamber.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2019 Tamber. All rights reserved.
//
//  Same as Stripe's NSMutableURLRequest but name space changed

#import <Foundation/Foundation.h>

@interface NSMutableURLRequest (Tamber)

- (void)tmb_addParametersToURL:(NSDictionary *)parameters;
- (void)tmb_setFormPayload:(NSDictionary *)formPayload;
- (void)tmb_setMultipartFormData:(NSData *)data boundary:(NSString *)boundary;

@end

void linkNSMutableURLRequestCategory(void);
