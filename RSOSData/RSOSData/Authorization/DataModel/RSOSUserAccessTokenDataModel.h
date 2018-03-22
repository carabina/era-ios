//
//  RSOSUserAccessTokenDataModel.h
//  EmergencyReferenceApp
//
//  Created by Gabe Mahoney on 1/4/18.
//  Copyright © 2018 rapidsos. All rights reserved.
//

#import "RSOSAccessTokenDataModel.h"

@interface RSOSUserAccessTokenDataModel : RSOSAccessTokenDataModel

@property (strong, nonatomic, nullable) NSString *username;
@property (strong, nonatomic, nullable) NSString *password;

@end
