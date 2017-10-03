//
//  TamberiOSTests.m
//  TamberiOSTests
//
//  Created by Alexander Robbins on 5/4/17.
//  Copyright © 2017 Tamber. All rights reserved.
//

#import <XCTest/XCTest.h>
#import <Tamber/Tamber.h>

//const NSString *testProjectKey = @"Mu6DUPXdDYe98cv5JIfX";
//const NSString *testEngineKey = @"SbWYPBNdARfIDa0IIO9L";
const NSString *defaultUser = @"user_jctzgisbru";

NSString *userA;
NSString *userB;
NSString *item1;
NSString *item2;

@interface TamberiOSTests : XCTestCase
@property (strong, nonatomic) TMBClient *client;
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
    double nan = NAN;
    NSNumber * v =  [NSNumber numberWithDouble:0.3];
//    NSLog(@"v:%@", [v doubleValue]);
    TMBEventParams *params = [TMBEventParams eventWithUser:@"user_a" item:@"item_1" behavior:@"like" amount:v hit:true context:@[@"recommended", @"detail-view"] created:[NSDate date]];
    XCTestExpectation *trackExp = [self expectationWithDescription:@"Event tracked"];
    [_client trackEvent:params responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [trackExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testRecs {
    TMBDiscoverNextParams *nextParams = [TMBDiscoverNextParams discoverNext:[NSNumber numberWithInt:8]];
    XCTestExpectation *discoverNextExp = [self expectationWithDescription:@"Discover next"];
    [_client discoverNext:nextParams responseCompletion:^(TMBDiscoverResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [discoverNextExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
    
    TMBDiscoverNextParams *nextParamsFull = [TMBDiscoverNextParams discoverNext:item1 number:[NSNumber numberWithInt:8] excludeItems:@[item2] randomness:[NSNumber numberWithFloat:0.1]  filter:nil getProperties:true];
    XCTestExpectation *discoverNextExp2 = [self expectationWithDescription:@"Discover next with item, exclude_items, randomness, and get_properties set"];
    [_client discoverNext:nextParamsFull responseCompletion:^(TMBDiscoverResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [discoverNextExp2 fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
    
    TMBDiscoverParams *params = [TMBDiscoverParams discoverParamsWithUser:defaultUser number:nil];
    XCTestExpectation *discoverExp = [self expectationWithDescription:@"Discover recommended"];
    [_client discoverRecommendations:params responseCompletion:^(TMBDiscoverResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [discoverExp fulfill];
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
    
    TMBDiscoverParams *params = [TMBDiscoverParams discoverRecommendations:[NSNumber numberWithInt:50]];
    XCTestExpectation *discoverExp = [self expectationWithDescription:@"Discover recommended"];
    [[Tamber client] discoverRecommendations:params responseCompletion:^(TMBDiscoverResponse *object, NSHTTPURLResponse *response, NSError *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [discoverExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testItemlessEvents {
    
    TMBEventParams *eventParams = [TMBEventParams pushRenderedWithContext:@[@"tmb_push"] created:nil];
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

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
