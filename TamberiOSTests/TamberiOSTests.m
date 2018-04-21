//
//  TamberiOSTests.m
//  TamberiOSTests
//
//  Created by Alexander Robbins on 5/4/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Tamber/Tamber.h>

const NSString *testProjectKey = @"Mu6DUPXdDYe98cv5JIfX";
const NSString *testEngineKey = @"SbWYPBNdARfIDa0IIO9L";

const NSString *defaultUser = @"user_jctzgisbru";

NSString *userA;
NSString *userB;
NSString *item1;
NSString *item2;

@interface TamberiOSTests : XCTestCase
@property (nullable, readwrite, nonatomic) TMBClient *client;
@end

@implementation TamberiOSTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    [Tamber setPublishableProjectKey:testProjectKey publishableEngineKey:testEngineKey];
    [Tamber setUser:defaultUser];
    _client = [TMBClient apiClientWithPublishableProjectKey:testProjectKey publishableEngineKey:testEngineKey];
    userA = [[NSProcessInfo processInfo] globallyUniqueString];
    userB = [[NSProcessInfo processInfo] globallyUniqueString];
    item1 = [[NSProcessInfo processInfo] globallyUniqueString];
    item2 = [[NSProcessInfo processInfo] globallyUniqueString];
    NSLog(@"setup complete");
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    NSNumber * v =  [NSNumber numberWithDouble:0.3];
//    NSLog(@"v:%@", [v doubleValue]);
    TMBEventParams *params = [TMBEventParams eventWithUser:@"user_a" item:@"item_1" behavior:@"like" amount:v hit:true context:@[@"recommended", @"detail-view", @"tmb_ios"] created:[NSDate date]];
    XCTestExpectation *trackExp = [self expectationWithDescription:@"Event tracked"];
    [_client trackEvent:params responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [trackExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}


- (void)testBasicUserOps {
    // 1. Create user with events
    NSString *tempUid = [[NSProcessInfo processInfo] globallyUniqueString];
    [Tamber setUser:tempUid];
    TMBUserParams *userParams = [TMBUserParams defaultUser];
    TMBEventParams *eparams = [TMBEventParams eventWithItem:@"item_1" behavior:@"like"];
    userParams.events = @[ eparams ];
    XCTestExpectation *uCreateExp = [self expectationWithDescription:@"User created"];
    [[Tamber client] createUser:userParams responseCompletion:^(TMBUser *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [uCreateExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
    
    // 2. Retrieve created user
    XCTestExpectation *uRetrieveExp = [self expectationWithDescription:@"User retrieved"];
    userParams = [TMBUserParams userWithId:tempUid];
    [[Tamber client] retrieveUser:userParams responseCompletion:^(TMBUser *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [uRetrieveExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
    
    // 3. Update user with metadata
    XCTestExpectation *uUpdateExp = [self expectationWithDescription:@"User updated"];
    NSDictionary *metadata = @{ @"key": @"value" };
    userParams = [TMBUserParams userWithMetadata:metadata];
    [[Tamber client] updateUser:userParams responseCompletion:^(TMBUser *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [uUpdateExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
    
    // 4. Search for user with the newly updated metadata
    XCTestExpectation *uSearchExp = [self expectationWithDescription:@"User search completed"];
    [[Tamber client] searchUsers:metadata responseCompletion:^(TMBUserSearchResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        NSLog(@"search results: %@", object.users);
        XCTAssertNotNil(object);
        [uSearchExp fulfill];
    }];
    
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
    
    // 5. Set push token
    [Tamber setUserPushToken:@"test_token"];
    
    // 6. Set push min interval
    [Tamber setUserPushMinInterval:24*60*60];
    
    // 7. Set location
    CLLocation * loc = [[CLLocation alloc] initWithLatitude:37.33182 longitude:122.03118];
    [Tamber setUserLocation:loc];
    
    // 8. Make test user
    XCTestExpectation *testUserExp = [self expectationWithDescription:@"makeTestUser completed"];
    [Tamber makeTestUser:^(){
        [testUserExp fulfill];
    }];
     [self waitForExpectationsWithTimeout:400.0f handler:nil];
    
    [Tamber setUser:defaultUser];
}

- (void)testNewUserOps {
    // Create user with events
    NSString *tempUid = [[NSProcessInfo processInfo] globallyUniqueString];
    [Tamber setUser:tempUid];
    NSLog(@"temp-uid:%@", tempUid);
    
    // Make test user
    XCTestExpectation *testUserExp = [self expectationWithDescription:@"makeTestUser completed"];
    [Tamber makeTestUser:^(){
        NSLog(@"make test user complete");
        [testUserExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:400.0f handler:nil];
    
    NSString *testToken = @"test_token";
    [Tamber setUserPushToken:testToken];
     [NSThread sleepForTimeInterval:0.5f];
    int minInterval = 24*60*60;
    // Set push min interval
    [Tamber setUserPushMinInterval:minInterval];
    [NSThread sleepForTimeInterval:0.5f];
    // Set location
    CLLocation * location = [[CLLocation alloc] initWithLatitude:37.33182 longitude:122.03118];
    [Tamber setUserLocation:location];
    
     [NSThread sleepForTimeInterval:0.5f];
    
    // Check user metadata
    NSDictionary *metadata = @{
                               TMBTestUserFieldName:[NSNumber numberWithBool:TRUE],
                               TMBPushTokenFieldName:testToken,
                               TMBPushMinIntervalFieldName: [NSNumber numberWithInt:minInterval],
                               TMBTimezoneFieldName: [[NSTimeZone localTimeZone] name],
                                   @"latitude": [NSNumber numberWithDouble:location.coordinate.latitude], @"longitude":[NSNumber numberWithDouble:location.coordinate.longitude]
                               };
    
    // wait for those requests to complete
    [NSThread sleepForTimeInterval:4.0f];
    
    XCTestExpectation *userRetrieveExp = [self expectationWithDescription:@"retrieve user completed"];
    TMBUserParams *userParams = [TMBUserParams userWithId:tempUid];
    [[Tamber client] retrieveUser:userParams responseCompletion:^(TMBUser *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        NSLog(@"object.metadata:%@  \nmetadata:%@", object.metadata, metadata);
        XCTAssertTrue([object.metadata isEqualToDictionary:metadata]);
        [userRetrieveExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:400.0f handler:nil];
    [Tamber setUser:defaultUser];
}

//Test merging from an existing user with events to a novel user. This simulates handling of user signup.
- (void)testUserMerge_ToNovelUser {
    NSString *existingUser = [[NSProcessInfo processInfo] globallyUniqueString];
    NSString *newUser = [[NSProcessInfo processInfo] globallyUniqueString];
    NSLog(@"existing user: %@  new user: %@", existingUser, newUser);
    [Tamber setUser:existingUser];
    TMBEventParams *eventParams = [TMBEventParams eventWithItem:item1 behavior:@"like"];
    XCTestExpectation *trackExp = [self expectationWithDescription:@"Event 1 tracked"];
    [[Tamber client] trackEvent:eventParams responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [trackExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
    
    XCTestExpectation *mergeFailExp = [self expectationWithDescription:@"User A merged to B"];
    [[Tamber client] mergeUser:existingUser toUser:newUser noCreate:true responseCompletion:^(TMBUser *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNotNil(errorMessage);
        NSLog(@"merge to novel user with noCreate true error:%@", errorMessage);
        [mergeFailExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
    
    XCTestExpectation *mergeExp = [self expectationWithDescription:@"User A merged to B"];
    [[Tamber client] mergeToUser:newUser responseCompletion:^(TMBUser *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        NSLog(@"Merge User Response Object: %@", object);
        XCTAssertTrue([object.events count] == 1);
        [mergeExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
    
    
    [Tamber setUser:defaultUser];
}

//Test merging from an existing user with events to another existing user with events. This simulates handling of user login.
- (void)testUserMerge_ExistingUser {
    TMBEventParams *eventParams = [TMBEventParams eventWithUser: userA item:item1 behavior:@"like"];
    XCTestExpectation *trackExp = [self expectationWithDescription:@"Event 1 tracked"];
    [[Tamber client] trackEvent:eventParams responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [trackExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];

     TMBEventParams *eventParamsB = [TMBEventParams eventWithUser: userB item:item2 behavior:@"like"];
    trackExp = [self expectationWithDescription:@"Event 2 tracked"];
    [[Tamber client] trackEvent:eventParamsB responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [trackExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
    
    XCTestExpectation *mergeExp = [self expectationWithDescription:@"User A merged to B"];
    [[Tamber client] mergeUser:userA toUser:userB noCreate:false responseCompletion:^(TMBUser *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        NSLog(@"Merge User Response Object: %@", object);
        XCTAssertTrue([object.events count] == 2);
        [mergeExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testDefaultClient {
    
    TMBEventParams *eventParams = [TMBEventParams eventWithItem:@"item_1" behavior:@"like"];
    XCTestExpectation *trackExp = [self expectationWithDescription:@"Event tracked"];
    [[Tamber client] trackEvent:eventParams responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [trackExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
    
    TMBDiscoverParams *params = [TMBDiscoverParams discoverRecommended:[NSNumber numberWithInt:50]];
    XCTestExpectation *discoverExp = [self expectationWithDescription:@"Discover recommended"];
    [[Tamber client] discoverRecommendations:params responseCompletion:^(TMBDiscoverResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [discoverExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testItemlessEvents {
    
    TMBEventParams *eventParams = [TMBEventParams pushRenderedWithContext:@[TMBPushContext] created:nil];
    XCTestExpectation *trackExp = [self expectationWithDescription:@"Itemless `tmb_push_rendered` event tracked"];
    [[Tamber client] trackEvent:eventParams responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [trackExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
    
    TMBEventParams *eventParams2 = [TMBEventParams sessionStarted];
    XCTestExpectation *trackExp2 = [self expectationWithDescription:@"Itemless `tmb_session_started` event tracked"];
    [[Tamber client] trackEvent:eventParams2 responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [trackExp2 fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
    
    TMBEventParams *eventParams3 = [TMBEventParams sessionEnded];
    XCTestExpectation *trackExp3 = [self expectationWithDescription:@"Itemless `tmb_session_ended` event tracked"];
    [[Tamber client] trackEvent:eventParams3 responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [trackExp3 fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testItemObjectEvents {
    TMBItem *item = [TMBItem itemWithId:@"item_id"
                             properties:@{
                                          @"type":@"book",
                                          @"title":@"The Moon is a Harsh Mistress",
                                          @"img_url":@"https://img.domain.com/book/The_Moon_is_a_Harsh Mistress.jpg",
                                          @"stock":[NSNumber numberWithInteger:34]
                                          }
                                   tags:@[@"sci-fi", @"bestseller"]
                     ];
    TMBEventParams *eventParams = [TMBEventParams eventWithItem:item behavior:@"like" context:@[@"homepage", @"featured"]];
    XCTestExpectation *trackExp = [self expectationWithDescription:@"Full item object event tracked"];
    [[Tamber client] trackEvent:eventParams responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [trackExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}
- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
