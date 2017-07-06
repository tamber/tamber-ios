//
//  TMBParser.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBEncoder.h"
#import "TMBDiscoverParams.h"
#import "TMBEventParams.h"
#import "NSDictionary+Tamber.h"
#import "NSArray+Tamber.h"

FOUNDATION_EXPORT NSString * TMBPercentEscapedStringFromString(NSString *string);
FOUNDATION_EXPORT NSString * TMBQueryStringFromParameters(NSDictionary *parameters);

@implementation TMBEncoder

+ (NSDictionary *)dictionaryForObject:(nonnull NSObject<TMBObjectEncodable> *)object {
    NSDictionary *keyPairs = [self keyPairDictionaryForObject:object];
    NSString *rootObjectName = [object.class rootObjectName];
    NSDictionary *dict = rootObjectName != nil ? @{ rootObjectName: keyPairs } : keyPairs;
    return dict;
}

+ (NSString *)stringByReplacingSnakeCaseWithCamelCase:(NSString *)input {
    NSArray *parts = [input componentsSeparatedByString:@"_"];
    NSMutableString *camelCaseParam = [NSMutableString string];
    [parts enumerateObjectsUsingBlock:^(NSString *part, NSUInteger idx, __unused BOOL *stop) {
        [camelCaseParam appendString:(idx == 0 ? part : [part capitalizedString])];
    }];
    
    return [camelCaseParam copy];
}

+ (NSDictionary *)keyPairDictionaryForObject:(nonnull NSObject<TMBObjectEncodable> *)object {
    NSMutableDictionary *keyPairs = [NSMutableDictionary dictionary];
    [[object.class propertyNamesToFormFieldNamesMapping] enumerateKeysAndObjectsUsingBlock:^(NSString * _Nonnull propertyName, NSString *  _Nonnull formFieldName, __unused BOOL * _Nonnull stop) {
        id value = [self formEncodableValueForObject:[object valueForKey:propertyName]];
        if (value) {
            if ([value isKindOfClass:[NSDictionary class]]) {
                NSString *jsonDictStr = [value tmb_json];
                keyPairs[formFieldName] = jsonDictStr;
            } else if ([value isKindOfClass:[NSArray class]]) {
                NSMutableArray *encodedValueTemp = [[NSMutableArray alloc] init];
                for(NSObject* obj in value){
                    [encodedValueTemp addObject:[self formEncodableValueForObject:obj]];
                }
                NSArray *encodedValue = [encodedValueTemp copy];
                NSLog(@"encodedValue:%@", encodedValue);
                keyPairs[formFieldName] = [encodedValue tmb_json];
            } else if([value isKindOfClass:[NSDate class]]) {
                keyPairs[formFieldName] = [NSNumber numberWithInt:[(NSDate*)value timeIntervalSince1970]];
            } else {
                keyPairs[formFieldName] = value;
            }
        }
    }];
    [object.additionalAPIParameters enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull additionalFieldName, id  _Nonnull additionalFieldValue, __unused BOOL * _Nonnull stop) {
        id value = [self formEncodableValueForObject:additionalFieldValue];
        if (value) {
            keyPairs[additionalFieldName] = value;
        }
    }];
    return [keyPairs copy];
}

+ (id)formEncodableValueForObject:(NSObject *)object {
    if ([object conformsToProtocol:@protocol(TMBObjectEncodable)]) {
        return [self keyPairDictionaryForObject:(NSObject<TMBObjectEncodable>*)object];
    } else {
         return object;
    }
}

+ (NSString *)stringByURLEncoding:(NSString *)string {
    return TMBPercentEscapedStringFromString(string);
}

+ (NSString *)queryStringFromParameters:(NSDictionary *)parameters {
    return TMBQueryStringFromParameters(parameters);
}

@end

// This code is adapted from https://github.com/AFNetworking/AFNetworking/blob/master/AFNetworking/AFURLRequestSerialization.m . The only modifications are to replace the AF namespace with the TMB namespace to avoid collisions with apps that are using both Tamber and AFNetworking.
NSString * TMBPercentEscapedStringFromString(NSString *string) {
    static NSString * const kTMBCharactersGeneralDelimitersToEncode = @":#[]@"; // does not include "?" or "/" due to RFC 3986 - Section 3.4
    static NSString * const kTMBCharactersSubDelimitersToEncode = @"!$&'()*+,;=";
    
    NSMutableCharacterSet * allowedCharacterSet = [[NSCharacterSet URLQueryAllowedCharacterSet] mutableCopy];
    [allowedCharacterSet removeCharactersInString:[kTMBCharactersGeneralDelimitersToEncode stringByAppendingString:kTMBCharactersSubDelimitersToEncode]];
    
    // FIXME: https://github.com/AFNetworking/AFNetworking/pull/3028
    // return [string stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
    
    static NSUInteger const batchSize = 50;
    
    NSUInteger index = 0;
    NSMutableString *escaped = @"".mutableCopy;
    
    while (index < string.length) {
#pragma GCC diagnostic push
#pragma GCC diagnostic ignored "-Wgnu"
        NSUInteger length = MIN(string.length - index, batchSize);
#pragma GCC diagnostic pop
        NSRange range = NSMakeRange(index, length);
        
        // To avoid breaking up character sequences such as 👴🏻👮🏽
        range = [string rangeOfComposedCharacterSequencesForRange:range];
        
        NSString *substring = [string substringWithRange:range];
        NSString *encoded = [substring stringByAddingPercentEncodingWithAllowedCharacters:allowedCharacterSet];
        [escaped appendString:encoded];
        
        index += range.length;
    }
    
    return escaped;
}

#pragma mark -

@interface TMBQueryStringPair : NSObject
@property (readwrite, nonatomic, strong) id field;
@property (readwrite, nonatomic, strong) id value;

- (instancetype)initWithField:(id)field value:(id)value;

- (NSString *)URLEncodedStringValue;
@end

@implementation TMBQueryStringPair

- (instancetype)initWithField:(id)field value:(id)value {
    self = [super init];
    if (!self) {
        return nil;
    }
    
    _field = field;
    _value = value;
    
    return self;
}

- (NSString *)URLEncodedStringValue {
    if (!self.value || [self.value isEqual:[NSNull null]]) {
        return TMBPercentEscapedStringFromString([self.field description]);
    } else {
        return [NSString stringWithFormat:@"%@=%@", TMBPercentEscapedStringFromString([self.field description]), TMBPercentEscapedStringFromString([self.value description])];
    }
}

@end

#pragma mark -

FOUNDATION_EXPORT NSArray * TMBQueryStringPairsFromDictionary(NSDictionary *dictionary);
FOUNDATION_EXPORT NSArray * TMBQueryStringPairsFromKeyAndValue(NSString *key, id value);

NSString * TMBQueryStringFromParameters(NSDictionary *parameters) {
    NSMutableArray *mutablePairs = [NSMutableArray array];
    for (TMBQueryStringPair *pair in TMBQueryStringPairsFromDictionary(parameters)) {
        [mutablePairs addObject:[pair URLEncodedStringValue]];
    }
    
    return [mutablePairs componentsJoinedByString:@"&"];
}

NSArray * TMBQueryStringPairsFromDictionary(NSDictionary *dictionary) {
    return TMBQueryStringPairsFromKeyAndValue(nil, dictionary);
}

NSArray * TMBQueryStringPairsFromKeyAndValue(NSString *key, id value) {
    NSMutableArray *mutableQueryStringComponents = [NSMutableArray array];
    NSString *descriptionSelector = NSStringFromSelector(@selector(description));
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:descriptionSelector ascending:YES selector:@selector(compare:)];
    
    if ([value isKindOfClass:[NSDictionary class]]) {
        NSDictionary *dictionary = value;
        // Sort dictionary keys to ensure consistent ordering in query string, which is important when deserializing potentially ambiguous sequences, such as an array of dictionaries
        for (id nestedKey in [dictionary.allKeys sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            id nestedValue = dictionary[nestedKey];
            if (nestedValue) {
                if ([nestedValue isKindOfClass:[NSDictionary class]]) {
                    NSString *jsonDictStr = [nestedValue tmb_json];
                    [mutableQueryStringComponents addObjectsFromArray:TMBQueryStringPairsFromKeyAndValue(nestedKey, jsonDictStr)];
                } else {
                    [mutableQueryStringComponents addObjectsFromArray:TMBQueryStringPairsFromKeyAndValue((key ? [NSString stringWithFormat:@"%@[%@]", key, nestedKey] : nestedKey), nestedValue)];
                }
            }
        }
    } else if ([value isKindOfClass:[NSArray class]]) {
        NSArray *array = value;
        NSString *jsonDictStr = [array tmb_json];
        [mutableQueryStringComponents addObjectsFromArray:TMBQueryStringPairsFromKeyAndValue(key, jsonDictStr)];
//        for (id nestedValue in array) {
//            
//            [mutableQueryStringComponents addObjectsFromArray:TMBQueryStringPairsFromKeyAndValue([NSString stringWithFormat:@"%@[]", key], nestedValue)];
//        }
    } else if ([value isKindOfClass:[NSSet class]]) {
        NSSet *set = value;
        for (id obj in [set sortedArrayUsingDescriptors:@[ sortDescriptor ]]) {
            [mutableQueryStringComponents addObjectsFromArray:TMBQueryStringPairsFromKeyAndValue(key, obj)];
        }
    } else {
        [mutableQueryStringComponents addObject:[[TMBQueryStringPair alloc] initWithField:key value:value]];
    }
    
    return mutableQueryStringComponents;
}

