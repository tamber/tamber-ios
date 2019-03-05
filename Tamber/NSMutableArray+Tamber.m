//
//  NSMutableArray+Tamber.m
//  Tamber
//
//  Created on 3/5/19.
//  Copyright © 2019 Tamber. All rights reserved.
//

#import "NSMutableArray+Tamber.h"

@implementation NSMutableArray (Tamber)

- (void) tmb_addObjectIfNotNil:(id)object {
    if(object) {
        [self addObject:object];
    }
}

void linkNSMutableArrayCategory(void){}

@end
