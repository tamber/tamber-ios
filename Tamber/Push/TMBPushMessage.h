//
//  TMBPushMessage.h
//  Tamber
//
//  Created by Alexander Robbins on 10/14/17.
//  Copyright © 2019 Tamber. All rights reserved.
//

#import "TMBUtils.h"
#import "TMBObjectDecodable.h"

@class TMBDiscovery;

NS_ASSUME_NONNULL_BEGIN
static NSString *const TMBPushPayloadIdFieldName = @"tmb-push-id";
static NSString *const TMBPushPayloadTypeFieldName = @"tmb-type";
static NSString *const TMBPushPayloadItemsFieldName = @"tmb-items";
static NSString *const TMBPushPayloadSrcItemsFieldName = @"tmb-src-items";
static NSString *const TMBPushPayloadMessageFieldName = @"tmb-push-message";
NS_ASSUME_NONNULL_END

@interface TMBPushMessage : NSObject<TMBObjectDecodable>

- (nullable NSDictionary *) dict;

@property (nullable, readwrite, nonatomic) NSDictionary *aps;
@property (nullable, readwrite, nonatomic) NSString *type;
@property (nullable, readwrite, nonatomic) NSString *message;
@property (nullable, readwrite, nonatomic) NSString *pushId;
@property (nullable, readwrite, nonatomic) NSArray<TMBDiscovery *> *items;
@property (nullable, readwrite, nonatomic) NSArray<TMBDiscovery *> *srcItems;

@end
