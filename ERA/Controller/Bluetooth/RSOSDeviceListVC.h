//
//  RSOSDeviceListVC.h
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreBluetooth/CoreBluetooth.h>

@interface RSOSDeviceListVC : UIViewController <CBCentralManagerDelegate,CBPeripheralDelegate>

@end
