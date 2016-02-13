//
//  BTService.m
//  Arduino_Servo
//
//  Created by Owen Lacy Brown on 5/21/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import "BTService.h"
#import "AppConstants.h"
#import "DataReceivedPacket.h"


@interface BTService()
@property (strong, nonatomic) CBPeripheral *peripheral;
@property (strong, nonatomic) CBCharacteristic *positionCharacteristic;
@property (strong, nonatomic) CBCharacteristic *RXCharacteristic;
@property (nonatomic) NSMutableString* currentMsg;
@end

@implementation BTService

#pragma mark - Lifecycle

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral {
  self = [super init];
  if (self) {
    self.peripheral = peripheral;
    [self.peripheral setDelegate:self];
      self.currentMsg = [[NSMutableString alloc] init];
  }
  return self;
}

- (void)dealloc {
  [self reset];
}

- (void)startDiscoveringServices {
  [self.peripheral discoverServices:@[SPS_BLE_SERVICE_UUID]];
}

- (void)reset {
  
  if (self.peripheral) {
    self.peripheral = nil;
  }
  
  // Deallocating therefore send notification
  [self sendBTServiceNotificationWithIsBluetoothConnected:NO];
}

#pragma mark - CBPeripheralDelegate

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverServices:(NSError *)error {
  NSArray *services = nil;
    NSArray *uuidsForBTService = @[SPS_POSITION_CHAR_UUID, SPS_RX_CHAR_UUID];
  
  if (peripheral != self.peripheral) {
    //NSLog(@"Wrong Peripheral.\n");
    return ;
  }
  
  if (error != nil) {
    //NSLog(@"Error %@\n", error);
    return ;
  }
  
  services = [peripheral services];
  if (!services || ![services count]) {
    //NSLog(@"No Services");
    return ;
  }
  
  for (CBService *service in services) {
    if ([[service UUID] isEqual:SPS_BLE_SERVICE_UUID]) {
        /*for ( CBCharacteristic *characteristic in service.characteristics ) {
            if ([characteristic.UUID isEqual:[SPS_RX_CHAR_UUID]]) {
                //Everything is found, read characteristic !
                [peripheral readValueForCharacteristic:characteristic];
            }
            else if([characteristic.UUID isEqual:[SPS_POSITION_CHAR_UUID]])
            {
                [peripheral readValueForCharacteristic:characteristic];
            }
        }*/
      [peripheral discoverCharacteristics:@[SPS_POSITION_CHAR_UUID, SPS_RX_CHAR_UUID] forService:service];
    }
  }
}

- (void)peripheral:(CBPeripheral *)peripheral didDiscoverCharacteristicsForService:(CBService *)service error:(NSError *)error {
  NSArray     *characteristics    = [service characteristics];
  
  if (peripheral != self.peripheral) {
    //NSLog(@"Wrong Peripheral.\n");
    return ;
  }
  
  if (error != nil) {
    //NSLog(@"Error %@\n", error);
    return ;
  }
  
  for (CBCharacteristic *characteristic in characteristics) {
    if ([[characteristic UUID] isEqual:SPS_POSITION_CHAR_UUID]) {
      self.positionCharacteristic = characteristic;
        
      // Send notification that Bluetooth is connected and all required characteristics are discovered
      //[self sendBTServiceNotificationWithIsBluetoothConnected:YES];
    }
    else if([[characteristic UUID] isEqual:SPS_RX_CHAR_UUID]){
        self.RXCharacteristic = characteristic;
        [peripheral setNotifyValue:YES forCharacteristic:self.RXCharacteristic];
    }
  }
    
    // Send notification that Bluetooth is connected and all required characteristics are discovered
    [self sendBTServiceNotificationWithIsBluetoothConnected:YES];
}

- (void)peripheral:(CBPeripheral *)peripheral didUpdateValueForCharacteristic:(CBCharacteristic *)characteristic error:(NSError *)error
{
    if ([characteristic.UUID isEqual:SPS_RX_CHAR_UUID]) {
        NSData *data = [characteristic value];
        NSUInteger capacity = data.length * 2;
        NSMutableString *sbuf = [NSMutableString stringWithCapacity:capacity];
        const unsigned char *buf = data.bytes;
        NSInteger i;
        for (i=0; i<data.length; ++i) {
            [sbuf appendFormat:@"%02X", (NSUInteger)buf[i]];
        }
        
        NSString* dfa = @"";
    }
    
    
    
    
    
    
    
    
    // Updated value for heart rate measurement received
    if ([characteristic.UUID isEqual:SPS_RX_CHAR_UUID]) { // 1
        NSString* b = [[NSString alloc] initWithData:[characteristic value] encoding:NSASCIIStringEncoding];
        if(!([b isEqualToString:@"@"]))
        {
        DataReceivedPacket *dataPacket = [[DataReceivedPacket alloc] init];
        
        
        NSData *data = [characteristic value];
        
        dataPacket.data = data;
        
        if([[[NSString alloc] initWithData:[characteristic value] encoding:NSASCIIStringEncoding] hasSuffix:@";"])
        {
            NSDateFormatter *dateFormat = [[NSDateFormatter alloc]init];
            [dateFormat setDateFormat:@"YYYY/MM/dd HH:mm:ss"];
            NSString *dateString = [dateFormat stringFromDate:[NSDate date]];
            dataPacket.formattedDate = dateString;
            
            dataPacket.stringData = [NSMutableString stringWithString:self.currentMsg];
            NSString* str = [[NSString alloc] initWithData:[characteristic value] encoding:NSASCIIStringEncoding];
            [dataPacket.stringData appendString:[str substringToIndex:str.length - 1]];
            [[NSNotificationCenter defaultCenter] postNotificationName:NOTIFICATION_BLE_SHIELD_CHARACTERISTIC_VALUE_READ object:dataPacket];
        }
        else
        {
            [self.currentMsg appendString:[[NSString alloc] initWithData:[characteristic value] encoding:NSASCIIStringEncoding]];
        }
    }
        else{
            [self.currentMsg setString:@""];
        }
    }
    else if([characteristic.UUID isEqual:SPS_FRAME_UUID]){
        
    }
        // Retrieve the characteristic value for manufacturer name received
    //if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:SPS_NAME_CHARACTERISTIC_UUID]]) {  // 2
        //[self getManufacturerName:characteristic];
    //}
    // Retrieve the characteristic value for the body sensor location received
    //else if ([characteristic.UUID isEqual:[CBUUID UUIDWithString:POLARH7_HRM_BODY_LOCATION_CHARACTERISTIC_UUID]]) {  // 3
        //[self getBodyLocation:characteristic];
    //}
    
    // Add your constructed device information to your UITextView
    //self.deviceInfo.text = [NSString stringWithFormat:@"%@\n%@\n%@\n", self.connected, self.bodyData, self.manufacturer];  // 4
}

#pragma mark - Private

- (void)writeText:(NSData*)text {
  // TODO: Add implementation
    if (!self.positionCharacteristic) {
        return;
    }
    
    NSData *data = data = [NSData dataWithBytes:&text length:sizeof(text)];
    [self.peripheral writeValue:text
              forCharacteristic:self.positionCharacteristic
                           type:CBCharacteristicWriteWithResponse];
}

- (void)sendBTServiceNotificationWithIsBluetoothConnected:(BOOL)isBluetoothConnected {
  NSDictionary *connectionDetails = @{@"isConnected": @(isBluetoothConnected)};
  [[NSNotificationCenter defaultCenter] postNotificationName:SPS_BLE_SERVICE_CHANGED_STATUS_NOTIFICATION object:self userInfo:connectionDetails];
}

- (void) getHeartBPMData:(CBCharacteristic *)characteristic error:(NSError *)error
{
}

@end
