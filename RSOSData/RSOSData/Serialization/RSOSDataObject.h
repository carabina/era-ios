//
//  RSOSDataObject.h
//  EmergencyReferenceApp
//
//  Created by Gabe Mahoney on 1/31/18.
//  Copyright © 2018 RapidSOS. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@protocol RSOSDataSerializable

@required
- (instancetype)initWithDictionary:(NSDictionary *)dict;
- (void)setWithDictionary:(NSDictionary *)dict;
- (NSDictionary *)serializeToDictionary;

@end

@interface RSOSDataObject<ObjectType> : NSObject<RSOSDataSerializable>

@property (strong, nonatomic) NSString *displayName;
@property (strong, nonatomic) NSString *type;
@property (strong, nonatomic, nullable) NSString *units;
@property (strong, nonatomic) NSMutableArray<ObjectType> *values;

- (instancetype)initWithDisplayName:(NSString *)name type:(NSString *)type;
- (instancetype)initWithDisplayName:(NSString *)name type:(NSString *)type units: (NSString *) units;

- (ObjectType)getPrimaryValue;
- (void)setPrimaryValue:(ObjectType)value;
- (void) addValue: (id) value;
- (void) replaceValueAtIndex: (int) index withValue: (id) value;
- (void)deletePrimaryValue;
- (void) deleteValueAtIndex: (int) index;
- (BOOL)isSet;

@end

NS_ASSUME_NONNULL_END
