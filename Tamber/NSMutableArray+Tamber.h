//
//  NSMutableArray+Tamber.h
//  Tamber
//
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Tamber)

- (void) tmb_addObjectIfNotNil:(nullable id)object;

@end

void linkNSMutableArrayCategory(void);

NS_ASSUME_NONNULL_END
