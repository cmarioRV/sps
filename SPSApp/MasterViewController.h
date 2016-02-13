//
//  MasterrViewController.h
//  SPSApp
//
//  Created by Inter-Telco MacAir on 2/09/15.
//  Copyright (c) 2015 FAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ViewControllerDelegate <NSObject>
- (void)sendMsg:(UIViewController *)controller didFinishEnteringItem:(NSString *)item;
@end

@interface MasterViewController : UIViewController <UITableViewDelegate, UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UIButton *btnSend;

@property (weak, nonatomic) IBOutlet UITableView *tableViewCustomMsgs;
@property(nonatomic) NSMutableDictionary* dictionaryOfCustomMsgs;
@property (strong, nonatomic) NSManagedObjectContext *managedObjectContext;
@property (weak, nonatomic) IBOutlet UITextView *msgTxtField;
@property (nonatomic, weak) id <ViewControllerDelegate> delegate;
- (IBAction)sendMessage:(id)sender;
- (IBAction)deleteCustomMsgItem:(id)sender;
- (IBAction)deleteMessage:(id)sender;

@end
