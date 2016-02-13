//
//  MessageTableViewController.h
//  SPSApp
//
//  Created by Inter-Telco MacAir on 3/09/15.
//  Copyright (c) 2015 FAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MessageTableViewController : UITableViewController

- (MessageTableViewController*) initWithFrame:(CGRect)frame;
@property (strong, nonatomic) NSMutableArray *dataPackets;

@end
