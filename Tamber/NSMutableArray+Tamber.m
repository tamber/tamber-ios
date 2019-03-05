//
//  NSMutableArray+Tamber.m
//  AFNetworking-iOS
//
//  Created by Jeremy Levine on 3/5/19.
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
