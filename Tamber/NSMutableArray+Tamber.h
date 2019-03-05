//
//  NSMutableArray+Tamber.h
//  AFNetworking-iOS
//
//  Created by Jeremy Levine on 3/5/19.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface NSMutableArray (Tamber)

- (void) tmb_addObjectIfNotNil:(nullable id)object;

@end

void linkNSMutableArrayCategory(void);

NS_ASSUME_NONNULL_END
