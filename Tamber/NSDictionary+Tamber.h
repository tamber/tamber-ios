//
//  NSDictionary+Tamber.h
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2020 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSDictionary (Tamber)

- (nullable NSDictionary *)tmb_dictionaryByRemovingNullsValidatingRequiredFields:(nonnull NSArray *)requiredFields;
- (nullable NSString *) tmb_json;

@end

void linkNSDictionaryCategory(void);
