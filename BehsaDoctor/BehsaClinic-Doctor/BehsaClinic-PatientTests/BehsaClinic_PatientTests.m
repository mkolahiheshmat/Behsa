//
//  BehsaClinic_PatientTests.m
//  BehsaClinic-PatientTests
//
//  Created by Yarima on 3/1/17.
//  Copyright © 2017 Arash Z. Jahangiri. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ConvertToPersianDate.h"
@interface BehsaClinic_PatientTests : XCTestCase

@end

@implementation BehsaClinic_PatientTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample {
    // This is an example of a functional test case.
    // Use XCTAssert and related functions to verify your tests produce the correct results.
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

- (void)testConvertShamsiToUnixDate{
    double fromDateDouble = [ConvertToPersianDate ConvertToUNIXDateWithShamsiYear:1395 month:12 day:11];
    XCTAssertEqual(fromDateDouble,1488326400);
}
@end
