//
//  MasterrViewController.m
//  SPSApp
//
//  Created by Inter-Telco MacAir on 2/09/15.
//  Copyright (c) 2015 FAC. All rights reserved.
//

#import "MasterViewController.h"
#import "Settings.h"
#import "AppConstants.h"



@interface MasterViewController ()
@property (nonatomic) UIAlertView* alertView;
@end


@implementation MasterViewController

@synthesize dictionaryOfCustomMsgs = _dictionaryOfCustomMsgs;
@synthesize btnSend = _btnSend;

- (void)awakeFromNib {
    [super awakeFromNib];
    self.preferredContentSize = CGSizeMake(320.0, 600.0);
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.dictionaryOfCustomMsgs = [[NSMutableDictionary alloc] initWithDictionary:[self getCustomMsgs]];
    
    self.msgTxtField.layer.cornerRadius = 5;
    self.msgTxtField.layer.borderColor = [[UIColor grayColor] CGColor];
    self.msgTxtField.layer.borderWidth = 1;
    
    self.alertView = [[UIAlertView alloc] initWithTitle:@"SPS Desconectado"
                                                message:@"Encienda el SPS"
                                               delegate:nil
                                      cancelButtonTitle:@"OK"
                                      otherButtonTitles:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(connectionStateChanged:) name:SPS_BLUETOOTH_STATUS_CHANGED object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSMutableDictionary*)getCustomMsgs
{
    NSArray *pathAppData = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathAppData objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory
                               stringByAppendingPathComponent:@"CustomMessages.plist"];
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:documentsPath];
    if (!dict)
    {
        NSString *pathBundle = [[NSBundle mainBundle] pathForResource:@"CustomMessages" ofType:@"plist"];
        dict = [[NSMutableDictionary alloc] initWithContentsOfFile:pathBundle];
        [dict writeToFile:documentsPath atomically:YES];
    }

    return dict;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 2;
}

- (NSString*) tableView:(UITableView*)tableView titleForHeaderInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return @"Opciones";
        case 1:
            return @"Mensajes predefinidos";
        default:
            return @"Empty";
    }
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    switch (section)
    {
        case 0:
            return 1;
        case 1:
            return [self.dictionaryOfCustomMsgs count];
        default:
            return 0;
    }
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* addCustomMsgID = @"AddCustomMsg";
    static NSString* customMsgID = @"CustomMsg";
    UITableViewCell* cell;
    NSLog(@"section :%d and row: %d", indexPath.section, indexPath.row);
    
    UIButton* deleteCustomMsgBtn;
    
    if([indexPath section] == 0)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:addCustomMsgID];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:addCustomMsgID];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
        }

        [[cell textLabel] setText:@"Agregar mensaje predefinido"];
        cell.textLabel.textColor = [UIColor greenColor];
        cell.backgroundColor = [UIColor blackColor];
    }
    else if([indexPath section] == 1)
    {
        cell = [tableView dequeueReusableCellWithIdentifier:customMsgID];
        if(cell == nil)
        {
            cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:customMsgID];
            [cell setSelectionStyle:UITableViewCellSelectionStyleNone];
            
        }

        [[cell textLabel] setText:[[self.dictionaryOfCustomMsgs allKeys] objectAtIndex:indexPath.row]];
        cell.textLabel.textColor = [UIColor whiteColor];
        cell.backgroundColor = [UIColor blackColor];

        if(![cell accessoryView])
        {
            deleteCustomMsgBtn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
            [deleteCustomMsgBtn setFrame:CGRectMake(0, 0, 80, 30)];
            [deleteCustomMsgBtn setTitle:@"Eliminar" forState:UIControlStateNormal];

            [deleteCustomMsgBtn.titleLabel setFont:[UIFont fontWithName:@"Copperplate" size:16.0]];
            [deleteCustomMsgBtn setTintColor:[UIColor colorWithRed:210.0/255.f green:58.0/255.f blue:255.0/255.f alpha:1.0]];
            
            deleteCustomMsgBtn.contentHorizontalAlignment = UIControlContentHorizontalAlignmentCenter;
            deleteCustomMsgBtn.contentVerticalAlignment   = UIControlContentVerticalAlignmentCenter;
            [deleteCustomMsgBtn addTarget:self action:@selector(deleteCustomMsgItem:)
                         forControlEvents:UIControlEventTouchUpInside];
            deleteCustomMsgBtn.autoresizingMask = UIViewAutoresizingFlexibleHeight;
            [cell setAccessoryView:deleteCustomMsgBtn];
        }
    }
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:[tableView indexPathForSelectedRow] animated:YES];
    
    if(indexPath.section == 0)
    {
        if(indexPath.row == 0)
        {
            UIAlertView* alertView = [[UIAlertView alloc] initWithTitle:@"Ingrese el mensaje"
                                                        message:nil
                                                        delegate:self
                                                        cancelButtonTitle:@"OK"
                                                        otherButtonTitles:@"Cancelar", nil];

            alertView.alertViewStyle = UIAlertViewStylePlainTextInput;
            [alertView show];
        }
    }
    else
    {
        NSString* key = [[self.dictionaryOfCustomMsgs allKeys] objectAtIndex:indexPath.row];
        self.msgTxtField.text = [self.msgTxtField.text stringByAppendingString:key];
    }
}

-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 20.0;
}

-(void)tableView:(UITableView *)tableView willDisplayHeaderView:(UIView *)view forSection:(NSInteger)section
{
    //view.tintColor = [UIColor blackColor];
    view.tintColor = [UIColor colorWithRed:35.0/255.f green:35.0/255.f blue:35.0/255.f alpha:1.0];
    
    UITableViewHeaderFooterView *header = (UITableViewHeaderFooterView *)view;
    [header.textLabel setFont:[UIFont fontWithName:@"Copperplate" size:20.0]];
    [header.textLabel setTextColor:[UIColor colorWithRed:87.0/255.f green:193.0/255.f blue:250.0/255.f alpha:1.0]];
    header.textLabel.textAlignment = NSTextAlignmentCenter;
}

-(void)tableView:(UITableView *)tableView willDisplayFooterView:(UIView *)view forSection:(NSInteger)section
{
    view.tintColor = [UIColor blackColor];
    view.tintColor = [UIColor colorWithRed:25.0/255.f green:25.0/255.f blue:25.0/255.f alpha:1.0];
    
    UITableViewHeaderFooterView *footer = (UITableViewHeaderFooterView *)view;
    [footer.textLabel setTextColor:[UIColor whiteColor]];
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    NSString *title = [alertView buttonTitleAtIndex:buttonIndex];
    
    if([title isEqualToString:@"OK"])
    {
        NSString* msg = [[alertView textFieldAtIndex:0] text];
        if(![msg isEqualToString:@""])
        {
            [self.dictionaryOfCustomMsgs setValue:@"" forKey:msg];

            NSArray *pathAppData = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
            NSString *documentsDirectory = [pathAppData objectAtIndex:0];
            NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:@"CustomMessages.plist"];
            NSMutableDictionary *dict = [[NSMutableDictionary alloc] initWithContentsOfFile:documentsPath];
            [dict setValue:@"" forKey:msg];
            
            [dict writeToFile:documentsPath atomically:YES];
            
            [self.tableViewCustomMsgs reloadData];
        }
    }
}

-(void)deleteCustomMsgItem:(id)sender
{
    CGPoint buttonPosition = [sender convertPoint:CGPointZero toView:self.tableViewCustomMsgs];
    NSIndexPath *indexPath = [self.tableViewCustomMsgs indexPathForRowAtPoint:buttonPosition];
    [self.dictionaryOfCustomMsgs removeObjectForKey:[[self.dictionaryOfCustomMsgs allKeys] objectAtIndex:indexPath.row]];
    
    NSArray *pathAppData = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [pathAppData objectAtIndex:0];
    NSString *documentsPath = [documentsDirectory stringByAppendingPathComponent:@"CustomMessages.plist"];
    [self.dictionaryOfCustomMsgs writeToFile:documentsPath atomically:YES];
    
    [self.tableViewCustomMsgs reloadData];
}

- (IBAction)deleteMessage:(id)sender
{
    self.msgTxtField.text = @"";
}

- (IBAction)sendMessage:(id)sender
{
    [self.delegate sendMsg:self didFinishEnteringItem:(NSString *)self.msgTxtField.text];
    self.msgTxtField.text = @"";
}

- (void)connectionStateChanged:(NSNotification *)notification {
    
    dispatch_async(dispatch_get_main_queue(), ^{
    //NSDictionary* sd= [notification userInfo];
    //BOOL isConnected = [[sd valueForKey:@"isConnected"] boolValue];
    //if(isConnected)
    if([[notification object] boolValue])
    {
        if(self.alertView.isVisible)
        {
            [self.alertView dismissWithClickedButtonIndex:-1 animated:YES];
        }
        _btnSend.enabled = YES;
    }
    else
    {
        if(!self.alertView.isVisible)
        {
            [self.alertView show];
        }
        _btnSend.enabled = NO;
    }
    });
}

@end
