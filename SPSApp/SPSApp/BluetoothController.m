//
//  BluetoothController.m
//  SPSApp
//
//  Created by Inter-Telco MacAir on 3/09/15.
//  Copyright (c) 2015 FAC. All rights reserved.
//

#import "BluetoothController.h"
#import "AppConstants.h"
#import "BTDiscovery.h"
#import "BTService.h"

@interface BluetoothController ()
@property (strong, nonatomic) NSTimer *timerTXDelay;
@property (nonatomic, retain) NSString* currentText;
@property (nonatomic) BOOL allowTX;
@end

@implementation BluetoothController

#pragma mark - Scan Bluetooth devices

+(instancetype)sharedInstance
{
    static BluetoothController *this = nil;
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        this = [[BluetoothController alloc] init];
    });
    
    return this;
}

- (instancetype)init {
    self = [super init];
    if (self) {
        self.allowTX = YES;
        
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionChanged:) name:SPS_BLE_SERVICE_CHANGED_STATUS_NOTIFICATION object:nil];
        
        [BTDiscovery sharedInstance];
    }
    return self;
}

- (void)dealloc {
    
    [[NSNotificationCenter defaultCenter] removeObserver:self name:SPS_BLE_SERVICE_CHANGED_STATUS_NOTIFICATION object:nil];
}

-(void)scanDevices
{
    // Scan for all available CoreBluetooth LE devices
    NSArray *services = @[[CBUUID UUIDWithString:SPS_BLUETOOTH_USER_DATA_SERVICE_UUID], [CBUUID UUIDWithString:SPS_BLUETOOTH_DEVICE_INFO_SERVICE_UUID]];
    
    dispatch_queue_t queue = dispatch_queue_create("bluetoothQueue", NULL);
    
    //CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue];
    self.centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:queue];
    
    //[self.centralManager scanForPeripheralsWithServices:services options:nil];
    //self.centralManager = centralManager;
}


-(void)startScanning
{
    // Scan for all available CoreBluetooth LE devices
    //NSArray *services = @[[CBUUID UUIDWithString:SPS_BLUETOOTH_USER_DATA_SERVICE_UUID], [CBUUID UUIDWithString:SPS_BLUETOOTH_DEVICE_INFO_SERVICE_UUID], [CBUUID UUIDWithString:SPS_BLUETOOTH_RN_SERIAL_PORT_PROFILE_UUID], [CBUUID UUIDWithString:SPS_DEFAULT_SPP_UUID], [CBUUID UUIDWithString:BLE_DEVICE_SERVICE_UUID], [CBUUID UUIDWithString:BLE_DEVICE_VENDOR_NAME_UUID], [CBUUID UUIDWithString:SPS_BLUETOOTH_DEVICE_INFO_GENERIC_SERVICE_UUID], @[RWT_BLE_SERVICE_UUID]];
    
    [self.centralManager scanForPeripheralsWithServices:@[RWT_BLE_SERVICE_UUID] options:nil];
    
    //CBCentralManager *centralManager = [[CBCentralManager alloc] initWithDelegate:self queue:nil];
    //[centralManager scanForPeripheralsWithServices:services options:nil];
    //self.centralManager = centralManager;
    
    //[self.centralManager scanForPeripheralsWithServices:services options:nil];
}

#pragma mark - CBCentralManagerDelegate

// method called whenever you have successfully connected to the BLE peripheral
- (void)centralManager:(CBCentralManager *)central didConnectPeripheral:(CBPeripheral *)peripheral
{
    [peripheral setDelegate:self];
    [peripheral discoverServices:nil];
    self.connected = [NSString stringWithFormat:@"Connected: %@", peripheral.state == CBPeripheralStateConnected ? @"YES" : @"NO"];
    NSLog(@"%@", self.connected);
}

// CBCentralManagerDelegate - This is called with the CBPeripheral class as its main input parameter. This contains most of the information there is to know about a BLE peripheral.
- (void)centralManager:(CBCentralManager *)central didDiscoverPeripheral:(CBPeripheral *)peripheral advertisementData:(NSDictionary *)advertisementData RSSI:(NSNumber *)RSSI
{
    NSString *localName = [advertisementData objectForKey:CBAdvertisementDataLocalNameKey];
    if ([localName length] > 0) {
        NSLog(@"Found the heart rate monitor: %@", localName);
        [self.centralManager stopScan];
        self.spsPeripheral = peripheral;
        peripheral.delegate = self;
        [self.centralManager connectPeripheral:peripheral options:nil];
    }
}

// method called whenever the device state changes.
- (void)centralManagerDidUpdateState:(CBCentralManager *)central
{
    // Determine the state of the peripheral
    if ([central state] == CBCentralManagerStatePoweredOff) {
        NSLog(@"CoreBluetooth BLE hardware is powered off");
    }
    else if ([central state] == CBCentralManagerStatePoweredOn) {
        NSLog(@"CoreBluetooth BLE hardware is powered on and ready");
        [self startScanning];
    }
    else if ([central state] == CBCentralManagerStateUnauthorized) {
        NSLog(@"CoreBluetooth BLE state is unauthorized");
    }
    else if ([central state] == CBCentralManagerStateUnknown) {
        NSLog(@"CoreBluetooth BLE state is unknown");
    }
    else if ([central state] == CBCentralManagerStateUnsupported) {
        NSLog(@"CoreBluetooth BLE hardware is unsupported on this platform");
    }
}

#pragma mark - CBPeripheralDelegate

// CBPeripheralDelegate - Invoked when you discover the peripheral's available services.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error
{
    for (CBService *service in peripheral.services) {
        NSLog(@"Discovered service: %@", service.UUID);
        [peripheral discoverCharacteristics:nil forService:service];
    }
}

// Invoked when you discover the characteristics of a specified service.
- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error
{
    if ([service.UUID isEqual:[CBUUID UUIDWithString:SPS_BLUETOOTH_USER_DATA_SERVICE_UUID]])  {  // 1
        for (CBCharacteristic *aChar in service.characteristics)
        {
            // Request heart rate notifications
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:SPS_BLUETOOTH_ELEV_CHARACTERISTIC_UUID]]) { // 2
                [self.spsPeripheral setNotifyValue:YES forCharacteristic:aChar];
                NSLog(@"Found heart rate measurement characteristic");
            }
            // Request body sensor location
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:SPS_BLUETOOTH_LAT_CHARACTERISTIC_UUID]]) { // 3
                [self.spsPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found body sensor location characteristic");
            }
            // Request body sensor location
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:SPS_BLUETOOTH_LON_CHARACTERISTIC_UUID]]) { // 3
                [self.spsPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found body sensor location characteristic");
            }
            // Request body sensor location
            else if ([aChar.UUID isEqual:[CBUUID UUIDWithString:SPS_BLUETOOTH_NAV_CHARACTERISTIC_UUID]]) { // 3
                [self.spsPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found body sensor location characteristic");
            }
        }
    }
    // Retrieve Device Information Services for the Manufacturer Name
    if ([service.UUID isEqual:[CBUUID UUIDWithString:SPS_BLUETOOTH_LOC_AND_NAV_SERVICE_UUID]])  { // 4
        for (CBCharacteristic *aChar in service.characteristics)
        {
            if ([aChar.UUID isEqual:[CBUUID UUIDWithString:SPS_BLUETOOTH_NAV_CHARACTERISTIC_UUID]]) {
                [self.spsPeripheral readValueForCharacteristic:aChar];
                NSLog(@"Found a device manufacturer name characteristic");
            }
        }
    }
}

// Invoked when you retrieve a specified characteristic's value, or when the peripheral device notifies your app that the characteristic's value has changed.
- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // Updated value for heart rate measurement received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPS_BLUETOOTH_ELEV_CHARACTERISTIC_UUID]]) { // 1
        // Get the Heart Rate Monitor BPM
        [self getHeartBPMData:characteristic error:error];
    }
    // Retrieve the characteristic value for manufacturer name received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPS_BLUETOOTH_LAT_CHARACTERISTIC_UUID]]) {  // 2
        [self getManufacturerName:characteristic];
    }
    // Retrieve the characteristic value for the body sensor location received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPS_BLUETOOTH_LON_CHARACTERISTIC_UUID]]) {  // 3
        [self getBodyLocation:characteristic];
    }
    // Retrieve the characteristic value for the body sensor location received
    if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPS_BLUETOOTH_NAV_CHARACTERISTIC_UUID]]) {  // 3
        [self getBodyLocation:characteristic];
    }
    
    // Add your constructed device information to your UITextView
    self.deviceInfo.text = [NSString stringWithFormat:@"%@\n%@\n%@\n", self.connected, self.bodyData, self.manufacturer];  // 4
}

#pragma mark - CBCharacteristic helpers

// Instance method to get the heart rate BPM information
- (void) getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error
{
    // Get the Heart Rate Monitor BPM
    NSData *data = [characteristic value];      // 1
    const uint8_t *reportData = [data bytes];
    uint16_t bpm = 0;
    
    if ((reportData[0] & 0x01) == 0) {          // 2
        // Retrieve the BPM value for the Heart Rate Monitor
        bpm = reportData[1];
    }
    else {
        bpm = CFSwapInt16LittleToHost(*(uint16_t *)(&reportData[1]));  // 3
    }
    // Display the heart rate value to the UI if no error occurred
    if( (characteristic.value)  || !error ) {   // 4
        self.heartRate = bpm;
        //self.heartRateBPM.text = [NSString stringWithFormat:@"%i bpm", bpm];
        //self.heartRateBPM.font = [UIFont fontWithName:@"Futura-CondensedMedium" size:28];
        [self doHeartBeat];
        //self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:(60. / self.heartRate) target:self selector:@selector(doHeartBeat) userInfo:nil repeats:NO];
    }
    return;
}
// Instance method to get the manufacturer name of the device
- (void) getManufacturerName:(CBCharacteristic *)characteristic
{
    NSString *manufacturerName = [[NSString alloc] initWithData:characteristic.value encoding:NSUTF8StringEncoding];  // 1
    self.manufacturer = [NSString stringWithFormat:@"Manufacturer: %@", manufacturerName];    // 2
    return;
}
// Instance method to get the body location of the device
- (void) getBodyLocation:(CBCharacteristic *)characteristic
{
    NSData *sensorData = [characteristic value];         // 1
    uint8_t *bodyData = (uint8_t *)[sensorData bytes];
    if (bodyData ) {
        uint8_t bodyLocation = bodyData[0];  // 2
        self.bodyData = [NSString stringWithFormat:@"Body Location: %@", bodyLocation == 1 ? @"Chest" : @"Undefined"]; // 3
    }
    else {  // 4
        self.bodyData = [NSString stringWithFormat:@"Body Location: N/A"];
    }
    return;
}
// Helper method to perform a heartbeat animation
- (void)doHeartBeat
{
    /*
    CALayer *layer = [self heartImage].layer;
    CABasicAnimation *pulseAnimation = [CABasicAnimation animationWithKeyPath:@"transform.scale"];
    pulseAnimation.toValue = [NSNumber numberWithFloat:1.1];
    pulseAnimation.fromValue = [NSNumber numberWithFloat:1.0];
    
    pulseAnimation.duration = 60. / self.heartRate / 2.;
    pulseAnimation.repeatCount = 1;
    pulseAnimation.autoreverses = YES;
    pulseAnimation.timingFunction = [CAMediaTimingFunction functionWithName:kCAMediaTimingFunctionEaseIn];
    [layer addAnimation:pulseAnimation forKey:@"scale"];
    
    self.pulseTimer = [NSTimer scheduledTimerWithTimeInterval:(60. / self.heartRate) target:self selector:@selector(doHeartBeat) userInfo:nil repeats:NO];
     */
}

- (void)connectionChanged:(NSNotification *)notification {
    // Connection status changed. Indicate on GUI.
    BOOL isConnected = [(NSNumber *) (notification.userInfo)[@"isConnected"] boolValue];
    [[NSNotificationCenter defaultCenter] postNotificationName:SPS_BLUETOOTH_STATUS_CHANGED object:[NSNumber numberWithBool:isConnected]];
}



- (void)sendMsg:(NSString*)text {
    NSString * message = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSData *data = [message dataUsingEncoding:NSASCIIStringEncoding];
    
    if (!self.allowTX) { // 1
        return;
    }
    if(self.currentText == message)
    {
        return;
    }
    
    // Validate value
    self.currentText = message;

    // Send position to BLE Shield (if service exists and is connected)
    if ([BTDiscovery sharedInstance].bleService) { // 4
        [[BTDiscovery sharedInstance].bleService writeText:data];
        //lastPosition = position;
        
        // Start delay timer
        /*
        self.allowTX = NO;
        if (!self.timerTXDelay) { // 5
            self.timerTXDelay = [NSTimer scheduledTimerWithTimeInterval:0.1 target:self selector:@selector(timerTXDelayElapsed) userInfo:nil repeats:NO];
        }*/
    }
}

- (void)timerTXDelayElapsed {
    self.allowTX = YES;
    [self stopTimerTXDelay];
    
    // Send current slider position
    [self sendMsg:self.currentText];
}

- (void)stopTimerTXDelay {
    if (!self.timerTXDelay) {
        return;
    }
    
    [self.timerTXDelay invalidate];
    self.timerTXDelay = nil;
}

@end
