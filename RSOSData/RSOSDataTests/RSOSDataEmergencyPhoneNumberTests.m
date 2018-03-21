//
//  RSOSDataEmergencyPhoneNumberTests.m
//  RSOSDataTests
//
//  Created by Gabe Mahoney on 2/14/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RSOSDataPhoneNumber.h"

@interface RSOSDataEmergencyPhoneNumberTests : XCTestCase

@end

NSString * const RSOSDataPhoneNumberTestNumber = @"+12345678888";
NSString * const RSOSDataPhoneNumberTestLabel = @"Test Phone Label";
NSString * const RSOSDataPhoneNumberTestNote = @"This is a test note for a phone number.";


@implementation RSOSDataEmergencyPhoneNumberTests


- (void)testSerialization {
    
    RSOSDataPhoneNumber *phoneNumber = [[RSOSDataPhoneNumber alloc] init];
    
    phoneNumber.phoneNumber = RSOSDataPhoneNumberTestNumber;
    phoneNumber.label = RSOSDataPhoneNumberTestLabel;
    phoneNumber.note = RSOSDataPhoneNumberTestNote;
    
    NSDictionary *dict = [phoneNumber serializeToDictionary];
    
    XCTAssertNotNil(dict, @"Serialization of RSOSDataPhoneNumber failed");
    
    id object = dict[@"number"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataPhoneNumberTestNumber);
    
    object = dict[@"label"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataPhoneNumberTestLabel);
    
    object = dict[@"note"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataPhoneNumberTestNote);
    
}

- (void)testDeserialization {
    
    NSDictionary *dict = @{
                           @"number":RSOSDataPhoneNumberTestNumber,
                           @"label":RSOSDataPhoneNumberTestLabel,
                           @"note":RSOSDataPhoneNumberTestNote
                           };
    
    RSOSDataPhoneNumber *phoneNumber = [[RSOSDataPhoneNumber alloc] initWithDictionary:dict];
    
    XCTAssertNotNil(phoneNumber, @"RSOSDataPhoneNumber failed to de-serialize");
    XCTAssertEqualObjects(phoneNumber.phoneNumber, RSOSDataPhoneNumberTestNumber);
    XCTAssertEqualObjects(phoneNumber.label, RSOSDataPhoneNumberTestLabel);
    XCTAssertEqualObjects(phoneNumber.note, RSOSDataPhoneNumberTestNote);
    
}

@end
