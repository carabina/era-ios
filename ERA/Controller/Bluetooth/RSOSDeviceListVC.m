//
//  RSOSDeviceListVC.m
//  Emergency Reference Application
//
//  Created by Chris Lin on 11/29/17.
//  Copyright © 2017 RapidSOS. All rights reserved.
//

#import "RSOSDeviceListVC.h"
#import "RSOSDeviceListItemTVC.h"

#import "RSOSGlobalController.h"

#import "RSOSDataUserManager.h"

#import "VSNConstants.h"

NSString * const PeripheralNameKey = @"PeripheralNameKey";
NSString * const PeripheralObjectKey = @"PeripheralObjectKey";

NSString * const DeviceCellIdentifier = @"DeviceCellIdentifier";

@interface RSOSDeviceListVC () <UITableViewDelegate, UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableview;

@property (nonatomic) CBCentralManager *bluetoothManager;

@property (nonatomic) NSArray<CBUUID *> *bluetoothServiceUUIDs;

@property (nonatomic) NSMutableArray<CBPeripheral *> *availableDevices;

@end

@implementation RSOSDeviceListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.availableDevices = [NSMutableArray array];
    
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.tableview.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableview.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    self.tableview.backgroundColor = [UIColor clearColor];
    
    [self registerTableViewCellFromNib];
    
    
    // configure Bluetooth services
    
    // add service UUIDs to scan for
    NSString * VALRTServiceUUIDString = @"1802";
    NSArray *bluetoothServiceStrings = @[VALRTServiceUUIDString];
    
    NSMutableArray<CBUUID *> *temp = [NSMutableArray array];
    
    for (NSString *uuidString in bluetoothServiceStrings) {
        [temp addObject:[CBUUID UUIDWithString:uuidString]];
    }
    self.bluetoothServiceUUIDs = [NSArray arrayWithArray:temp];
    
    
    // create bluetooth manager
    
    self.bluetoothManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
}

- (void)dealloc {
    [self.bluetoothManager stopScan];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    [self.tableview reloadData];
    
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) registerTableViewCellFromNib{
    [self.tableview registerClass:[UITableViewCell class] forCellReuseIdentifier:@"TVC_DEVICELISTITEM"];
}


- (void)confirmDisconnectPeripheral:(CBPeripheral *)peripheral atIndexPath:(NSIndexPath *)indexPath {
    
    NSString *peripheralName = (peripheral.name != nil ? peripheral.name : @"");
    
    [RSOSGlobalController promptWithVC:self Title:@"Disconnect Device" Message:[NSString stringWithFormat:@"Are you sure you want to disconnect from %@", peripheralName] ButtonYes:@"Disconnect" ButtonNo:@"Cancel" CallbackYes:^{
        
        [self.bluetoothManager cancelPeripheralConnection:peripheral];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        });
        
    } CallbackNo:^{
        
         // do nothing
    }];
}

#pragma mark - UITableView Delegate

- (void)configureCell:(UITableViewCell *)cell atIndex:(int)index {
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    if(index < self.availableDevices.count) {
        
        CBPeripheral *peripheral = self.availableDevices[index];
        cell.textLabel.text = peripheral.name;
        
        
        if(peripheral.state == CBPeripheralStateConnected) {
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
            cell.detailTextLabel.text = @"Connected";
        }
        else if(peripheral.state == CBPeripheralStateConnecting) {
            
            UIActivityIndicatorView *actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
            [actIndicator startAnimating];
            
            cell.accessoryView = actIndicator;
            cell.accessoryType = UITableViewCellAccessoryNone;
            cell.detailTextLabel.text = @"Connecting...";
        }
        else if(@available(iOS 9.0, *)) {
            
            if(peripheral.state == CBPeripheralStateDisconnecting) {
                UIActivityIndicatorView *actIndicator = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
                [actIndicator startAnimating];
                
                cell.accessoryView = actIndicator;
                cell.accessoryType = UITableViewCellAccessoryNone;
                cell.detailTextLabel.text = @"Disconnecting...";
                
            }
            else  { // CBPeripheralStateDisconnected
                
                cell.accessoryView = nil;
                cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
                cell.detailTextLabel.text = @"Connect";
                
            }
        }
        else {
            cell.accessoryView = nil;
            cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
            cell.detailTextLabel.text = @"Connect";
        }
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.availableDevices.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:DeviceCellIdentifier];
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:DeviceCellIdentifier];
    }
    
    [self configureCell:cell atIndex:(int) indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [RSOSDeviceListItemTVC getPreferredHeight];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if(indexPath.row < self.availableDevices.count) {
        
        CBPeripheral *peripheral = self.availableDevices[indexPath.row];
        peripheral.delegate = self;
        
        if(peripheral.state == CBPeripheralStateConnected) {
            
            [self confirmDisconnectPeripheral:peripheral atIndexPath:indexPath];
        }
        else if (peripheral.state == CBPeripheralStateDisconnected) {
            
            NSLog(@"connecting to peripheral: %@", peripheral.name);
            [self.bluetoothManager connectPeripheral:peripheral options:nil];
            
            [self.tableview reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
        }
        
    }
}

#pragma mark - UIButton Event Listeners

- (IBAction)onButtonRefreshClick:(id)sender {
    
    [self refreshDeviceList];
    [self.tableview reloadData];
}

- (void)refreshDeviceList {
    [self.bluetoothManager stopScan];
    
    NSArray *devicesCopy = self.availableDevices;
    
    for (CBPeripheral *device in devicesCopy) {
        if(device.state == CBPeripheralStateDisconnected) {
            [self.availableDevices removeObject:device];
        }
    }
    
    [self.bluetoothManager scanForPeripheralsWithServices:self.bluetoothServiceUUIDs options:nil];
}

#pragma mark CBCentralManagerDelegate methods

// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)centralManager {
    
    switch(centralManager.state) {
            
        case CBManagerStateUnknown:
            NSLog(@"CoreBluetooth BLE state is unknown");
            break;
            
        case CBManagerStateResetting:
            NSLog(@"CoreBluetooth BLE hardware resetting");
            break;
            
        case CBManagerStateUnsupported:
            NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
            break;
            
        case CBManagerStateUnauthorized:
            NSLog(@"CoreBluetooth BLE state is unauthorized");
            break;
            
        case CBManagerStatePoweredOff:
            NSLog(@"CoreBluetooth BLE hardware is powered off");
            break;
            
        case CBManagerStatePoweredOn:
            NSLog(@"CoreBluetooth BLE hardware is powered on");
            
            //scan for devices
            [self.bluetoothManager scanForPeripheralsWithServices:self.bluetoothServiceUUIDs options:nil];
            break;
    }
}

- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI {
    
    if(![self.availableDevices containsObject:peripheral]) {
        [self.availableDevices addObject:peripheral];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.tableview reloadData];
        });
    }
}

- (void)centralManager:(CBCentralManager *)central didDisconnectPeripheral:(CBPeripheral *)peripheral error:(NSError *)error {
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.tableview reloadData];
    });
    
}

// method called whenever we have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral {
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    
    NSString *connected = connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    
    [self.tableview reloadData];
    
}

- (void)centralManager:(CBCentralManager *)central didFailToConnectPeripheral:(CBPeripheral *)peripheral error:(nullable NSError *)error {
    
    NSLog(@"failed to connect to peripheral (%@): %@", peripheral.name, error.localizedDescription);
    
}


#pragma mark CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
    for (CBService *service in peripheral.services) {
        
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if([service.UUID isEqual:[CBUUID UUIDWithString:BLE_VSN_GATT_SERVICE_UUID]]) {
        [self enableALRTButtonForPeripheral:peripheral service:service];
    }
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    NSLog(@"Characteristic %@: did update value to %@", characteristic.description, characteristic.value);
    
    if([characteristic.UUID isEqual:[CBUUID UUIDWithString:BLE_FALL_KEYPRESS_DETECTION_UUID]]) {
        
        // v.ALRT button press handler
        
        [self vALRTPeripheral:peripheral didUpdateValueForCharacteristic:characteristic error:error];
    }
}

- (void)peripheral:(CBPeripheral *)peripheral didWriteValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    NSLog(@"Did write value: %@ for characteristic: %@", characteristic.value, characteristic.description);
    
    if(error) {
        NSLog(@"Error: %@",[error localizedDescription]);
    }
}


#pragma mark VSN ALRT methods

- (void)enableALRTButtonForPeripheral:(CBPeripheral *)peripheral service:(CBService *)service {
    
    for (CBCharacteristic *aChar in service.characteristics) {
        
        if ([aChar.UUID isEqual:[CBUUID UUIDWithString:BLE_VERIFICATION_SERVICE_UUID]]) { // 2
            
            // write the verification key
            [self writeVerificationKey:peripheral characteristic:aChar error:nil];
            
            // enable button press detection
            [self enableButton:peripheral];
            
        }
    }
}

- (void)vALRTPeripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error {
    
    // V.ALRT button press detected
    
    char characteristic_val[2];
    [characteristic.value getBytes:characteristic_val length:2];
    
    // verify that value is down-press (0x01) and not up-press (0x00)
    if(*characteristic_val == 0x01) {
        
        
        // confirm callflow trigger with user
        
        [RSOSGlobalController promptWithVC:self Title:@"Confirmation" Message:@"Are you sure you want to trigger a 911 call?" ButtonYes:@"Yes" ButtonNo:@"No" CallbackYes:^{
            
            // trigger Emergency API callflow
            [[RSOSDataUserManager sharedInstance] requestTriggerCallWithCallback:^(RSOSResponseStatusDataModel *status) {
                
                if ([status isSuccess] == YES) {
                    [RSOSGlobalController showHudSuccessWithMessage:@"You will be connected to 911 very soon" DismissAfter:-1 Callback:nil];
                }
                else {
                    [RSOSGlobalController showHudErrorWithMessage:status.message DismissAfter:-1 Callback:nil];
                }
            }];
        }
         
                                CallbackNo:^{
                                    
                                }];
        
    }
}

/*
 *  @method writeVerificationKey:
 *
 *  @param p CBPeripheral to write to
 *
 *  @discussion Write the value to the app to verify the app(newer version)
 *
 */
-(void) writeVerificationKey:(CBPeripheral *)peripheral characteristic:(CBCharacteristic *)aChar error:(NSError *)error {
    
    // Add our constructed device information to our UITextView
    NSString *temporaryText = [NSString stringWithFormat:@"%@\n", @"writing verification key..."];  // 4
    NSLog(@"%@", temporaryText);
    
    //write the verification key
    NSData *data = [NSData dataWithBytes:(Byte[]){0x80,0xBE,0xF5,0xAC,0xFF} length:5];
    [peripheral writeValue:data forCharacteristic:aChar type:CBCharacteristicWriteWithResponse];
    
}

/*
 *  @method enableButton:
 *
 *  @param p CBPeripheral to write to
 *
 *  @discussion Enables notifications on the simple keypress service
 *
 */

-(void)enableButton:(CBPeripheral *)peripheral {
    
    for (CBService *service in peripheral.services) {
        
        if([service.UUID isEqual:[CBUUID UUIDWithString:BLE_VSN_GATT_SERVICE_UUID]]) {
            
            for (CBCharacteristic *characteristic in service.characteristics) {
                
                // enable the button short press
                if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:BLE_KEYPRESS_DETECTION_UUID]]) {
                    
                    // Add our constructed device information to our UITextView
                    NSString *temporaryText = [NSString stringWithFormat:@"%@\n", @"Enabling button short press..."];  // 4
                    NSLog(@"%@", temporaryText);
                    
                    NSLog(@"CBService is: %@", [service.UUID description]);
                    NSLog(@"characteristic is: %@", [characteristic.UUID description]);
                    
                    char val = 0x01;
                    NSData *data = [[NSData alloc] initWithBytes:&val length:1];
                    [peripheral writeValue:data forCharacteristic:characteristic type:CBCharacteristicWriteWithResponse];
                    
                }
                else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:BLE_FALL_KEYPRESS_DETECTION_UUID]]) { // 2
                    [peripheral setNotifyValue:YES forCharacteristic:characteristic];
                }
            }
        }
    }
}


@end
