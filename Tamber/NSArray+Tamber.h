//
//  NSArray+Tamber.h
//  Tamber
//
//  Created by Alexander Robbins on 7/6/17.
//  Copyright © 2019 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (Tamber)
- (nullable NSString *) tmb_json;
@end

void linkNSArrayCategory(void);
