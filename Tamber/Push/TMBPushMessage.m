//
//  TMBPushMessage.m
//  Tamber
//
//  Created by Alexander Robbins on 10/14/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBPushMessage.h"
#import "NSDictionary+Tamber.h"

@implementation TMBPushMessage

+ (NSArray *)requiredFields {
    return @[TMBPushPayloadIdFieldName, TMBPushPayloadTypeFieldName];
}

+ (instancetype)decodedObjectFromAPIResponse:(NSDictionary *)response {
    NSDictionary *result = [response tmb_dictionaryByRemovingNullsValidatingRequiredFields:[self requiredFields]];
    if (!result) {
        return nil;
    }
    TMBPushMessage *message = [self new];
    message.pushId = result[TMBPushPayloadIdFieldName];
    message.type = result[TMBPushPayloadTypeFieldName];
    message.items = result[TMBPushPayloadItemsFieldName];
    if([[result allKeys] containsObject:TMBPushPayloadSrcItemFieldName]){
        message.srcItems = result[TMBPushPayloadSrcItemFieldName] ;
    }
    message.aps = result[@"aps"];
    return message;
}

+ (NSDictionary *)propertyNamesToFormFieldNamesMapping {
    return @{
             @"type":TMBPushPayloadTypeFieldName,
             @"pushId": TMBPushPayloadIdFieldName,
             @"items": TMBPushPayloadItemsFieldName,
             @"srcItems": TMBPushPayloadSrcItemFieldName,
             @"aps": @"aps",
             };
}
-(NSDictionary *) dict{
    NSMutableDictionary *keyPairs = [NSMutableDictionary dictionary];
    [[TMBPushMessage propertyNamesToFormFieldNamesMapping] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull propertyName, NSString *  _Nonnull formFieldName, __unused BOOL * _Nonnull stop) {
        id value = [self valueForKey:propertyName];
        if (value) {
            if ([value isKindOfClass:[NSArray class]]) {
                NSMutableArray *encodedValueTemp = [[NSMutableArray alloc] init];
                for(NSObject* obj in value){
                    [encodedValueTemp addObject:obj];
                }
                NSArray *encodedValue = [encodedValueTemp copy];
                keyPairs[formFieldName] = encodedValue;
            } else {
                keyPairs[formFieldName] = value;
            }
        }
    }];
    return keyPairs;
}
/*
 return @{
 @"tmb-type": _type,
 @"tmb-push-id": _pushId,
 @"tmb-items": _items,
 @"tmb-src-items": _srcItems,
 @"aps": _aps,
 };
 */
@end
