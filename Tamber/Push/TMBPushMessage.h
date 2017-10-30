//
//  TMBPushMessage.h
//  Tamber
//
//  Created by Alexander Robbins on 10/14/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TMBObjectDecodable.h"

NS_ASSUME_NONNULL_BEGIN
static NSString *const TMBPushPayloadIdFieldName = @"tmb-push-id";
static NSString *const TMBPushPayloadTypeFieldName = @"tmb-type";
static NSString *const TMBPushPayloadItemsFieldName = @"tmb-items";
static NSString *const TMBPushPayloadSrcItemFieldName = @"tmb-src-items";
NS_ASSUME_NONNULL_END

@interface TMBPushMessage : NSObject<TMBObjectDecodable>

@property (nullable, readwrite, nonatomic) NSDictionary *aps;
@property (nullable, readwrite, nonatomic) NSString *type;
@property (nullable, readwrite, nonatomic) NSString *pushId;
@property (nullable, readwrite, nonatomic) NSArray *items;
@property (nullable, readwrite, nonatomic) NSArray *srcItems;

@end
