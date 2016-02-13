//
//  AppConstants.h
//  Condor v0.0.1_P
//
//  Created by Inter-Telco MacAir on 23/07/15.
//  Copyright (c) 2015 Fuerza Aérea Colombiana. All rights reserved.
//

#ifndef SPSApp_AppConstants_h
#define SPSApp_AppConstants_h

//#define CONDOR_TOOLBAR_HEIGHT (80)
#define SPS_MESSAGE_BAR_HEIGHT (200)
//#define CONDOR_LOGO_HEIGHT (80)
#define SPS_SETTING_CHANGED (@"gov.fac.cacom5.cetad.sps.setting.changed")


/* Notifications */
static NSString* const SPS_BLE_SERVICE_CHANGED_STATUS_NOTIFICATION = @"BLEServiceChangedStatusNotification";
static NSString* const SPS_BLUETOOTH_STATUS_CHANGED = @"BLEServiceDisconnectedNotification";
static NSString* const SPS_BLE_BAT_STATUS = @"BLEServiceBatteryNotification";



#define RWT_BLE_SERVICE_UUID		[CBUUID UUIDWithString:@"B8E06067-62AD-41BA-9231-206AE80AB550"]
#define RWT_POSITION_CHAR_UUID		[CBUUID UUIDWithString:@"BF45E40A-DE2A-4BC8-BBA0-E5D6065F1B4B"]






#define SPS_BLUETOOTH_DEVICE_INFO_GENERIC_SERVICE_UUID @"1800"
#define SPS_BLUETOOTH_DEVICE_INFO_SERVICE_UUID @"180A"
#define SPS_BLUETOOTH_LOC_AND_NAV_SERVICE_UUID @"1819"
#define SPS_BLUETOOTH_USER_DATA_SERVICE_UUID @"181C"

#define SPS_BLUETOOTH_APPEARANCE_CHARACTERISTIC_UUID @"2A01"
#define SPS_BLUETOOTH_ELEV_CHARACTERISTIC_UUID @"2A6C"
#define SPS_BLUETOOTH_LAT_CHARACTERISTIC_UUID @"2AAE"
#define SPS_BLUETOOTH_LON_CHARACTERISTIC_UUID @"2AAF"
#define SPS_BLUETOOTH_NAV_CHARACTERISTIC_UUID @"2A68"

#define SPS_BLUETOOTH_RN_SERIAL_PORT_PROFILE_UUID @"1101"
#define SPS_DEFAULT_SPP_UUID @"00001101-0000-1000-8000-00805F9B34FB"
#define BLE_DEVICE_SERVICE_UUID @"713D0000-503E-4C75-BA94-3148F18D941E"

#define BLE_DEVICE_VENDOR_NAME_UUID @"713D0001-503E-4C75-BA94-3148F18D941E"

#define NOTIFICATION_BLE_SHIELD_CHARACTERISTIC_VALUE_READ @"NOTIFICATION_BLE_SHIELD_CHARACTERISTIC_VALUE_READ"

////#define CONDOR_REFRESH_COMPLETE (@"gov.fac.cacom5.cetad.condor.refresh.complete")
//#define CONDOR_REFRESH (@"gov.fac.cacom5.cetad.condor.refresh")
//#define CONDOR_HIDDEN_LAYER (@"gov.fac.cacom5.cetad.condor.hiddenlayer")
//#define CONDOR_BR_CREATING_ENABLED (@"gov.fac.cacom5.cetad.condor.br.creating.enabled")
//#define CONDOR_BR_CREATING_SUBMODE_CHANGED (@"gov.fac.cacom5.cetad.condor.br.creating.submode.changed")
//#define CONDOR_AIRCRAFT_UPDATED (@"gov.fac.cacom5.cetad.condor.aircraft.added")
//#define CONDOR_AIRCRAFT_DELETED (@"gov.fac.cacom5.cetad.condor.aircraft.deleted")
//#define CONDOR_POINT_UPDATED (@"gov.fac.cacom5.cetad.condor.point.updated")
//#define CONDOR_POINT_DELETED (@"gov.fac.cacom5.cetad.condor.point.deleted")

#endif
