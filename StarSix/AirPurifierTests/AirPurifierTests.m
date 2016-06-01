//
//  AirPurifierTests.m
//  AirPurifierTests
//
//  Created by bluE on 14-8-13.
//  Copyright (c) 2014年 skyware. All rights reserved.
//

#import <XCTest/XCTest.h>

@interface AirPurifierTests : XCTestCase

@end

@implementation AirPurifierTests

- (void)setUp
{
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown
{
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testExample
{
//    XCTFail(@"No implementation for \"%s\"", __PRETTY_FUNCTION__);
}


//测试以WF开头的正则表达式
-(void)testRegsPreWF
{
    NSString *WFPre = @"^WF.{12}$";
    NSPredicate *pre = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",WFPre];
//    BOOL isCorrect = [pre evaluateWithObject:@"WFaaaaa"];
    XCTAssertEqual([pre evaluateWithObject:@"WFDDDDEEEEAAA!"], YES);
    XCTAssertEqual([pre evaluateWithObject:@"aaasfa"], NO);
    
}
@end
