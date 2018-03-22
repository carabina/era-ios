//
//  RSOSDataEmergencyContactTests.m
//  RSOSDataTests
//
//  Created by Gabe Mahoney on 2/14/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RSOSDataEmergencyContact.h"

@interface RSOSDataEmergencyContactTests : XCTestCase

@end


NSString * const RSOSDataEmergencyContactTestEmail = @"test.contact@example.com";
NSString * const RSOSDataEmergencyContactTestFullName = @"Testy McContact";
NSString * const RSOSDataEmergencyContactTestPhone = @"+12345678888";
NSString * const RSOSDataEmergencyContactTestLabel = @"Test Contact";
NSString * const RSOSDataEmergencyContactTestNote = @"This is a test contact.";

@implementation RSOSDataEmergencyContactTests

- (void)testSerialization {
    
    RSOSDataEmergencyContact *contact = [[RSOSDataEmergencyContact alloc] init];
    
    contact.emailAddress = RSOSDataEmergencyContactTestEmail;
    contact.fullName = RSOSDataEmergencyContactTestFullName;
    contact.phoneNumber = RSOSDataEmergencyContactTestPhone;
    contact.label = RSOSDataEmergencyContactTestLabel;
    contact.note = RSOSDataEmergencyContactTestNote;
    
    NSDictionary *dict = [contact serializeToDictionary];
    
    XCTAssertNotNil(dict, @"Serialization of RSOSDataEmergencyContact failed");
    
    id object = dict[@"email"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataEmergencyContactTestEmail);
    
    object = dict[@"full_name"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataEmergencyContactTestFullName);
    
    object = dict[@"phone"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataEmergencyContactTestPhone);
    
    object = dict[@"label"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataEmergencyContactTestLabel);
    
    object = dict[@"note"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataEmergencyContactTestNote);
    
}

- (void)testDeserialization {
    
    NSDictionary *dict = @{
                           @"email":RSOSDataEmergencyContactTestEmail,
                           @"full_name":RSOSDataEmergencyContactTestFullName,
                           @"phone":RSOSDataEmergencyContactTestPhone,
                           @"label":RSOSDataEmergencyContactTestLabel,
                           @"note":RSOSDataEmergencyContactTestNote
                           };
    
    RSOSDataEmergencyContact *contact = [[RSOSDataEmergencyContact alloc] initWithDictionary:dict];
    
    XCTAssertNotNil(contact, @"RSOSDataEmergencyContact failed to de-serialize");
    XCTAssertEqualObjects(contact.emailAddress, RSOSDataEmergencyContactTestEmail);
    XCTAssertEqualObjects(contact.fullName, RSOSDataEmergencyContactTestFullName);
    XCTAssertEqualObjects(contact.phoneNumber, RSOSDataEmergencyContactTestPhone);
    XCTAssertEqualObjects(contact.label, RSOSDataEmergencyContactTestLabel);
    XCTAssertEqualObjects(contact.note, RSOSDataEmergencyContactTestNote);
    
}

@end
