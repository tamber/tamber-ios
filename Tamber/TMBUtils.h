//
//  TMBUtils.h
//  Tamber
//
//  Created by Alexander Robbins on 10/15/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)
#define SYSTEM_VERSION_LESS_THAN(v)                 ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] == NSOrderedAscending)

@interface TMBUtils : NSObject

//@property (readwrite, nonatomic) BOOL autoLoadToken;
@property (readwrite, nonatomic) BOOL disableNotificationCenterDelegate;

+ (instancetype) getInstance;
+ (BOOL) autoUNCenterDelDisabled;

+ (UIApplication *) sharedUIApplication;
+ (BOOL) sharedUIApplicationActive;

@end
