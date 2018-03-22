//
//  RSOSDataEmailTests.m
//  RSOSDataTests
//
//  Created by Gabe Mahoney on 2/14/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RSOSDataEmail.h"

@interface RSOSDataEmailTests : XCTestCase

@end

NSString * const RSOSDataEmailTestEmailAddress = @"foo.bar@example.com";
NSString * const RSOSDataEmailTestLabel = @"This is a test label.";
NSString * const RSOSDataEmailTestNote = @"This is a test Note";

@implementation RSOSDataEmailTests

- (void)testSerialization {
    
    RSOSDataEmail *email = [[RSOSDataEmail alloc] init];
    
    email.emailAddress = RSOSDataEmailTestEmailAddress;
    email.label = RSOSDataEmailTestLabel;
    email.note = RSOSDataEmailTestNote;
    
    NSDictionary *dict = [email serializeToDictionary];
    
    XCTAssertNotNil(dict, @"Serialization of RSOSDataEmail failed");
    
    id object = dict[@"email_address"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataEmailTestEmailAddress);
    
    object = dict[@"label"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataEmailTestLabel);
    
    object = dict[@"note"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataEmailTestNote);
    
}

- (void)testDeserialization {
    
    NSDictionary *dict = @{
                           @"email_address":RSOSDataEmailTestEmailAddress,
                           @"label":RSOSDataEmailTestLabel,
                           @"note":RSOSDataEmailTestNote
                           };
    
    RSOSDataEmail *email = [[RSOSDataEmail alloc] initWithDictionary:dict];
    
    XCTAssertNotNil(email, @"RSOSDataEmail failed to de-serialize");
    XCTAssertEqualObjects(email.emailAddress, RSOSDataEmailTestEmailAddress);
    XCTAssertEqualObjects(email.label, RSOSDataEmailTestLabel);
    XCTAssertEqualObjects(email.note, RSOSDataEmailTestNote);
    
}

@end
