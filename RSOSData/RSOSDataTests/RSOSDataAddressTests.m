//
//  RSOSDataAddressTests.m
//  RSOSDataTests
//
//  Created by Gabe Mahoney on 2/14/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "RSOSDataAddress.h"

@interface RSOSDataAddressTests : XCTestCase

@end

NSString * const RSOSDataAddressTestCountryCode = @"US";
NSString * const RSOSDataAddressTestLabel = @"Test Label";
CGFloat const RSOSDataAddressTestLatitude = 41.0;
CGFloat const RSOSDataAddressTestLongitude = -71.0;
NSString * const RSOSDataAddressTestLocality = @"New York";
NSString * const RSOSDataAddressTestPostalCode = @"10009";
NSString * const RSOSDataAddressTestRegion = @"NY";
NSString * const RSOSDataAddressTestStreetAddress = @"234 W 39th Street";
NSString * const RSOSDataAddressTestNote = @"This is a test address.";

@implementation RSOSDataAddressTests

- (void)testSerialization {
    
    RSOSDataAddress *address = [[RSOSDataAddress alloc] init];
    address.countryCode = RSOSDataAddressTestCountryCode;
    address.label = RSOSDataAddressTestLabel;
    address.latitude = RSOSDataAddressTestLatitude;
    address.longitude = RSOSDataAddressTestLongitude;
    address.locality = RSOSDataAddressTestLocality;
    address.postalCode = RSOSDataAddressTestPostalCode;
    address.region = RSOSDataAddressTestRegion;
    address.streetAddress = RSOSDataAddressTestStreetAddress;
    address.note = RSOSDataAddressTestNote;
    
    NSDictionary *dict = [address serializeToDictionary];
    
    XCTAssertNotNil(dict, @"Serialization of RSOSDataAddress failed");
    
    id object = dict[@"country_code"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataAddressTestCountryCode);
    
    object = dict[@"label"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataAddressTestLabel);
    
    object = dict[@"latitude"];
    XCTAssertNotNil(object);
    XCTAssertEqualWithAccuracy([object doubleValue], RSOSDataAddressTestLatitude, 0.001);
    
    object = dict[@"longitude"];
    XCTAssertNotNil(object);
    XCTAssertEqualWithAccuracy([object doubleValue], RSOSDataAddressTestLongitude, 0.001);
    
    object = dict[@"locality"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataAddressTestLocality);
    
    object = dict[@"postal_code"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataAddressTestPostalCode);
    
    object = dict[@"region"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataAddressTestRegion);
    
    object = dict[@"street_address"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataAddressTestStreetAddress);
    
    object = dict[@"note"];
    XCTAssertNotNil(object);
    XCTAssertEqualObjects(object, RSOSDataAddressTestNote);
    
}

- (void)testDeserialization {
    
    NSDictionary *dict = @{
                           @"country_code":RSOSDataAddressTestCountryCode,
                           @"label":RSOSDataAddressTestLabel,
                           @"latitude":@(RSOSDataAddressTestLatitude),
                           @"longitude":@(RSOSDataAddressTestLongitude),
                           @"locality":RSOSDataAddressTestLocality,
                           @"postal_code":RSOSDataAddressTestPostalCode,
                           @"region":RSOSDataAddressTestRegion,
                           @"street_address":RSOSDataAddressTestStreetAddress,
                           @"note":RSOSDataAddressTestNote
                           };
    
    RSOSDataAddress *address = [[RSOSDataAddress alloc] initWithDictionary:dict];
    
    XCTAssertNotNil(address, @"Address failed to de-serialize");
    XCTAssertEqualObjects(address.countryCode, RSOSDataAddressTestCountryCode);
    XCTAssertEqualObjects(address.label, RSOSDataAddressTestLabel);
    XCTAssertEqualWithAccuracy(address.latitude, RSOSDataAddressTestLatitude, 0.0001);
    XCTAssertEqualWithAccuracy(address.longitude, RSOSDataAddressTestLongitude, 0.0001);
    XCTAssertEqualObjects(address.locality, RSOSDataAddressTestLocality);
    XCTAssertEqualObjects(address.postalCode, RSOSDataAddressTestPostalCode);
    XCTAssertEqualObjects(address.region, RSOSDataAddressTestRegion);
    XCTAssertEqualObjects(address.streetAddress, RSOSDataAddressTestStreetAddress);
    XCTAssertEqualObjects(address.note, RSOSDataAddressTestNote);
}

@end
