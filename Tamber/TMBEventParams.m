//
//  TMBEventParams.m
//  Tamber
//
//  Created by Alexander Robbins on 5/3/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import "TMBEventParams.h"

NSString *const TMBSessionStartedBehavior = @"tmb_session_started";
NSString *const TMBSessionEndedBehavior = @"tmb_session_ended";
NSString *const TMBPushRenderedBehavior = @"tmb_push_rendered";
NSString *const TMBPushReceivedBehavior = @"tmb_push_received";
NSString *const TMBPushEngagedBehavior = @"tmb_push_engaged";

@implementation TMBEventParams

@synthesize additionalAPIParameters = _additionalAPIParameters;

- (instancetype)init {
    self = [super init];
    if (self) {
        _additionalAPIParameters = @{};
    }
    return self;
}

+ (instancetype)eventWithItem:(id) item behavior:(NSString *)behavior{
    return [[self.class alloc] initWithUser:nil item:item behavior:behavior amount:nil hit:false context:nil created:nil];
}

+ (instancetype)eventWithItem:(id) item behavior:(NSString *)behavior context:(NSArray*)context {
    return [[self.class alloc] initWithUser:nil item:item behavior:behavior amount:nil hit:false context:context created:nil];
}

+ (instancetype)eventWithItem:(id) item behavior:(NSString *)behavior amount:(NSNumber*)amount context:(NSArray*)context {
    return [[self.class alloc] initWithUser:nil item:item behavior:behavior amount:amount hit:false context:context created:nil];
}

+ (instancetype)eventWithItem:(id) item behavior:(NSString *)behavior hit:(BOOL)hit context:(NSArray*)context {
    return [[self.class alloc] initWithUser:nil item:item behavior:behavior amount:nil hit:hit context:context created:nil];
}

+ (instancetype)eventWithItem:(id) item behavior:(NSString *)behavior amount:(NSNumber*)amount created:(NSDate*)created{
    return [[self.class alloc] initWithUser:nil item:item behavior:behavior amount:amount hit:false context:nil created:created];
}

+ (instancetype)eventWithUser:(NSString*) user item:(id) item behavior:(NSString *)behavior{
    return [[self.class alloc] initWithUser:user item:item behavior:behavior amount:nil hit:false context:nil created:nil];
}

+ (instancetype)eventWithUser:(NSString*) user item:(id) item behavior:(NSString *)behavior amount:(NSNumber*)amount created:(NSDate*)created {
    return [[self.class alloc] initWithUser:user item:item behavior:behavior amount:amount hit:false context:nil created:created];
}

+ (instancetype)eventWithUser:(NSString*) user item:(id) item behavior:(NSString *)behavior hit:(BOOL)hit context:(NSArray*)context{
    return [[self.class alloc] initWithUser:user item:item behavior:behavior amount:nil hit:hit context:context created:nil];
}

+ (instancetype)eventWithUser:(NSString*) user item:(id) item behavior:(NSString *)behavior amount:(NSNumber*)amount hit:(BOOL)hit context:(NSArray*)context created:(NSDate*)created {
    return [[self.class alloc] initWithUser:user item:item behavior:behavior amount:amount hit:hit context:context created:created];
}

- (instancetype)initWithUser:(NSString*) user item:(id) item behavior:(NSString *)behavior amount:(NSNumber*)amount hit:(BOOL)hit context:(NSArray*)context created:(NSDate*)created {
    self = [super init];
    if (self) {
        _user = user;
        _item = item;
        _behavior = behavior;
        _amount = amount;
        _hit = hit;
        _context = context;
        _created = created;
    }
    return self;
}

- (void) setGetRecs:(TMBDiscoverParams*)getRecs{
    _getRecs = getRecs;
}

#pragma mark - Reserved item-less events

+ (instancetype)sessionStarted{
    return [[self.class alloc] initWithUser:nil item:nil behavior:TMBSessionStartedBehavior amount:nil hit:false context:nil created:nil];
}

+ (instancetype)sessionStartedWithContext:(NSArray*)context created:(NSDate*)created{
    return [[self.class alloc] initWithUser:nil item:nil behavior:TMBSessionStartedBehavior amount:nil hit:false context:context created:created];
}

+ (instancetype)sessionEnded{
    return [[self.class alloc] initWithUser:nil item:nil behavior:TMBSessionEndedBehavior amount:nil hit:false context:nil created:nil];
}

+ (instancetype)sessionEndedWithContext:(NSArray*)context created:(NSDate*)created{
    return [[self.class alloc] initWithUser:nil item:nil behavior:TMBSessionEndedBehavior amount:nil hit:false context:context created:created];
}

+ (instancetype)pushRendered{
    return [[self.class alloc] initWithUser:nil item:nil behavior:TMBPushRenderedBehavior amount:nil hit:false context:nil created:nil];
}

+ (instancetype)pushRenderedWithContext:(NSArray*)context created:(NSDate*)created{
    return [[self.class alloc] initWithUser:nil item:nil behavior:TMBPushRenderedBehavior amount:nil hit:false context:context created:created];
}

+ (nullable instancetype)pushReceived{
    return [[self.class alloc] initWithUser:nil item:nil behavior:TMBPushReceivedBehavior amount:nil hit:false context:nil created:nil];
}

+ (nullable instancetype)pushReceivedWithContext:(nullable NSArray*)context created:(nullable NSDate*)created{
    return [[self.class alloc] initWithUser:nil item:nil behavior:TMBPushReceivedBehavior amount:nil hit:false context:context created:created];
}

+ (nullable instancetype)pushEngaged{
    return [[self.class alloc] initWithUser:nil item:nil behavior:TMBPushEngagedBehavior amount:nil hit:true context:nil created:nil];
}

+ (nullable instancetype)pushEngagedWithContext:(nullable NSArray*)context created:(nullable NSDate*)created{
    return [[self.class alloc] initWithUser:nil item:nil behavior:TMBPushEngagedBehavior amount:nil hit:true context:context created:created];
}

#pragma mark - TMBObjectEncodable

+ (NSString *)rootObjectName {
    return nil;
}

+ (NSDictionary *)propertyNamesToFormFieldNamesMapping {
    return @{
             @"user": @"user",
             @"item": @"item",
             @"behavior": @"behavior",
             @"amount": @"amount",
             @"created": @"created",
             @"getRecs": @"get_recs",
             };
}

@end
