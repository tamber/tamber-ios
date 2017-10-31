//
//  TMBUtils.m
//  Tamber
//
//  Created by Alexander Robbins on 10/15/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBUtils.h"

@implementation TMBUtils

+ (UIApplication *) sharedUIApplication {
    UIApplication* sharedApplication = nil;
    BOOL respondsToApplication = [UIApplication respondsToSelector:@selector(sharedApplication)];
    if (respondsToApplication) {
        sharedApplication = [UIApplication performSelector:@selector(sharedApplication)];
        if (!sharedApplication) {
            // WARNING: This should never be called from an extension
            NSException *exec = [[NSException alloc] initWithName:@"ApplicationNotAvailable" reason:@"Service Extensions can't access a shared application" userInfo:nil];
            [exec raise];
        }
    }
    return sharedApplication;
}

+ (BOOL) sharedUIApplicationActive {
    UIApplication *app = [TMBUtils sharedUIApplication];
    if (app){
        return [app applicationState] == UIApplicationStateActive;
    }
    return false;
}

+ (instancetype) getInstance {
    static id utils;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{ utils = [[self alloc] init]; });
    return utils;
}

+ (BOOL) autoUNCenterDelDisabled{
    TMBUtils *utils = [TMBUtils getInstance];
    return utils.disableNotificationCenterDelegate;
}

@end
