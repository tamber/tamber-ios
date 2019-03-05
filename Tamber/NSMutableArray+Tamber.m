//
//  NSMutableArray+Tamber.m
//  Tamber
//
//  Copyright © 2017 Tamber. All rights reserved.
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
