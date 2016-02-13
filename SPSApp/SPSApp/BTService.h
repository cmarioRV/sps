//
//  BTService.h
//  Arduino_Servo
//
//  Created by Owen Lacy Brown on 5/21/14.
//  Copyright (c) 2014 Razeware LLC. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreBluetooth/CoreBluetooth.h>

/* Services & Characteristics UUIDs */
#define SPS_BLE_SERVICE_UUID	[CBUUID UUIDWithString:@"B8E06067-62AD-41BA-9231-206AE80AB550"]
#define SPS_TEST [CBUUID UUIDWithString:@"F9266FD7-EF07-45D6-8EB6-BD74F13620F9"]


#define SPS_POSITION_CHAR_UUID	[CBUUID UUIDWithString:@"BF45E40A-DE2A-4BC8-BBA0-E5D6065F1B4B"]
#define SPS_BDDDR_CHAR_UUID		[CBUUID UUIDWithString:@"65C228DA-BAD1-4F41-B55F-3D177F4E2196"]
#define SPS_RX_CHAR_UUID		[CBUUID UUIDWithString:@"F897177B-AEE8-4767-8ECC-CC694FD5FCEE"]
#define SPS_FRAME_UUID		    [CBUUID UUIDWithString:@"F897177B-AEE8-4767-8ECC-CC694FD5FCED"]
#define SPS_TX_CHAR_UUID		[CBUUID UUIDWithString:@"BF45E40A-DE2A-4BC8-BBA0-E5D6065F1B4B"]
#define SPS_BAUDRATE_CHAR_UUID	[CBUUID UUIDWithString:@"2FBC0F31-726A-4014-B9FE-C8BE0652E982"]

#define SPS_MSG_RX_CHARACTERISTIC_UUID [CBUUID UUIDWithString:@"DFASDFAS"]

/* BTService */
@interface BTService : NSObject <CBPeripheralDelegate>

- (instancetype)initWithPeripheral:(CBPeripheral *)peripheral;
- (void)reset;
- (void)startDiscoveringServices;

- (void)writeText:(NSData*)text;

@end
