//
//  TMBSwizzler.h
//  Tamber
//
//  Created by Alexander Robbins on 10/13/17.
//  Copyright © 2020 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>

// Code outright stolen from swrve (https://github.com/Swrve/swrve-ios-sd)
@interface TMBSwizzler : NSObject
+ (IMP) swizzleMethod:(SEL)selector inClass:(Class)c withImplementationIn:(NSObject*)newObject;
+ (void) deswizzleMethod:(SEL)selector inClass:(Class)c originalImplementation:(IMP)originalImplementation;
@end
