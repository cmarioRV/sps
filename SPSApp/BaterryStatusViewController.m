//
//  BaterryStatusViewController.m
//  SPSApp
//
//  Created by Inter-Telco MacAir on 8/02/16.
//  Copyright (c) 2016 FAC. All rights reserved.
//

#import "BaterryStatusViewController.h"
#import "AppConstants.h"

@interface BaterryStatusViewController ()

@end

@implementation BaterryStatusViewController

-(id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if(self){
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(batteryStateChanged:) name:SPS_BLE_BAT_STATUS object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void)batteryStateChanged:(NSNotification *)notification {
}

@end
