//
//  AppDelegate.h
//  SPSApp
//
//  Created by Inter-Telco MacAir on 2/09/15.
//  Copyright (c) 2015 FAC. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "BluetoothController.h"

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (readonly, strong, nonatomic) NSManagedObjectModel *managedObjectModel;
@property (readonly, strong, nonatomic) NSPersistentStoreCoordinator *persistentStoreCoordinator;
@property (readonly, strong, nonatomic) BluetoothController *bluetoothController;

- (void)saveContext;
- (NSURL *)applicationDocumentsDirectory;


@end

