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
    
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    TMBEventParams *params = [TMBEventParams eventWithUser:@"user_a" item:@"item_1" behavior:@"like" value:nil created:[NSDate date]];
    XCTestExpectation *trackExp = [self expectationWithDescription:@"Event tracked"];
    [_client trackEvent:params responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSString *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [trackExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testRecs {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    TMBDiscoverParams *params = [TMBDiscoverParams discoverParamsWithUser:@"user_jctzgisbru" number:nil];
    XCTestExpectation *discoverExp = [self expectationWithDescription:@"Discover recommended"];
    [_client discoverRecommendations:params responseCompletion:^(TMBDiscoverResponse *object, NSHTTPURLResponse *response, NSString *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [discoverExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
}

- (void)testDefaultClient {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
    TMBDiscoverParams *params = [TMBDiscoverParams discoverRecommendations:[NSNumber numberWithInt:50]];
    XCTestExpectation *discoverExp = [self expectationWithDescription:@"Discover recommended"];
    [[Tamber client] discoverRecommendations:params responseCompletion:^(TMBDiscoverResponse *object, NSHTTPURLResponse *response, NSString *errorMessage) {
        XCTAssertNil(errorMessage);
        XCTAssertNotNil(object);
        [discoverExp fulfill];
    }];
    [self waitForExpectationsWithTimeout:5.0f handler:nil];
    TMBEventParams *eventParams = [TMBEventParams eventWithItem:@"item_1" behavior:@"like"];
    XCTestExpectation *trackExp = [self expectationWithDescription:@"Event tracked"];
    [[Tamber client] trackEvent:eventParams responseCompletion:^(TMBEventResponse *object, NSHTTPURLResponse *response, NSString *errorMessage) {
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
