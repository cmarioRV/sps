//
//  MessageTableViewController.m
//  SPSApp
//
//  Created by Inter-Telco MacAir on 3/09/15.
//  Copyright (c) 2015 FAC. All rights reserved.
//

#import "MessageTableViewController.h"
#import "DataReceivedPacket.h"
#import "AppConstants.h"

@interface MessageTableViewController ()

@end

@implementation MessageTableViewController

@synthesize dataPackets;

CGRect myFrame2;

- (MessageTableViewController*) initWithFrame:(CGRect)frame
{
    self = [super init];
    
    myFrame2 = frame;
    self.dataPackets = [NSMutableArray arrayWithCapacity:10];
    return self;
}

- (void) loadView
{
    self.view = [[UITableView alloc] initWithFrame:myFrame2];
    self.view.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleTopMargin;
    self.view.autoresizesSubviews = YES;
    self.view.clipsToBounds = YES;

    //[self.tableView setFrame:myFrame2];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.backgroundColor = [UIColor blackColor];
    //self.view = self.tableView;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

-(void)viewDidAppear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(notificationBLEShieldCharacteristicValueRead:) name:NOTIFICATION_BLE_SHIELD_CHARACTERISTIC_VALUE_READ object:nil];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NOTIFICATION_BLE_SHIELD_CHARACTERISTIC_VALUE_READ object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Lista de mensajes";
        default:
            return @"Empty";
    }
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
#warning Incomplete method implementation.
    // Return the number of rows in the section.
    //return 3;
    return dataPackets.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *cellIdentifier = @"messageCell";
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    UILabel* accesoryLabel;
    
    if(cell == nil)
    {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellIdentifier];
        [cell setFont:[UIFont fontWithName:@"Copperplate" size:16.0]];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor blackColor];
    }
    
    DataReceivedPacket* dp = [self.dataPackets objectAtIndex:indexPath.row];
    
        if(![cell accessoryView])
        {
            accesoryLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 180, 30)];
            accesoryLabel.text = dp.formattedDate;
            [accesoryLabel setFont:[UIFont fontWithName:@"Copperplate" size:16.0]];
            accesoryLabel.textAlignment = NSTextAlignmentLeft;
            accesoryLabel.textColor = [UIColor whiteColor];
            accesoryLabel.backgroundColor = [UIColor blackColor];
            accesoryLabel.contentMode = UIViewContentModeCenter;
            accesoryLabel.autoresizingMask = UIViewAutoresizingFlexibleHeight;
/*
            
            deleteCustomMsgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            deleteCustomMsgBtn.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter;
            [deleteCustomMsgBtn addTarget:self action:@selector(deleteCustomMsgItem:)
                         forControlEvents:UIControlEventTouchUpInside];
            deleteCustomMsgBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
 */
            [cell setAccessoryView:accesoryLabel];
        }
    
    

    //NSString *dataAsString = [[NSString alloc] initWithData:dp.data encoding:NSASCIIStringEncoding];
    cell.textLabel.text = @"";
    cell.textLabel.text = dp.stringData;
    
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 30.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    //view.tintColor = [UIColor blackColor];
    view.tintColor = [UIColor colorWithRed:35.0/255.f green:35.0/255.f blue:35.0/255.f alpha:1.0];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont fontWithName:@"Copperplate" size:20.0]];
    //[header.textLabel setTextColor:[UIColor whiteColor]];
    [header.textLabel setTextColor:[UIColor colorWithRed:87.0/255.f green:193.0/255.f blue:250.0/255.f alpha:1.0]];
}

- (void)notificationBLEShieldCharacteristicValueRead:(NSNotification*)notification {
    //BtLog(@"");

    dispatch_async(dispatch_get_main_queue(), ^{
    [self.tableView beginUpdates];
    DataReceivedPacket *dataPacket = notification.object;
    [self.dataPackets addObject:dataPacket];
    NSIndexPath *ip = [NSIndexPath indexPathForRow:[self.dataPackets count]-1 inSection:0];
    NSArray *paths = [NSArray arrayWithObject:[NSIndexPath indexPathForRow:[self.dataPackets count]-1 inSection:0]];
    [self.tableView insertRowsAtIndexPaths:paths withRowAnimation:YES];
    [self.tableView endUpdates];
    [self.tableView scrollToRowAtIndexPath:ip atScrollPosition:UITableViewScrollPositionTop animated:YES];
    });
}
/*
- (NSString *)getRawHexString:(NSData*)rawData {
    NSMutableString *cData = [NSMutableString stringWithCapacity:([rawData length] * 2)];
    const unsigned char *dataBuffer = [rawData bytes];
    int i;
    for (i = 0; i < [rawData length]; ++i) {
        [cData appendFormat:@"%02lX", (unsigned long)dataBuffer[i]];
    }
    return [NSString stringWithFormat:@"0x%@", [cData uppercaseString]];
}
*/
/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
