//
//  DetailViewController.m
//  SPSApp
//
//  Created by Inter-Telco MacAir on 2/09/15.
//  Copyright (c) 2015 FAC. All rights reserved.
//

#import "DetailViewController.h"
#import "WorldWind.h"
#import "WorldWind/WorldWindView.h"
#import "WorldWind/Layer/WWBMNGLandsatCombinedLayer.h"
#import "WorldWind/Layer/WWBMNGLayer.h"
#import "WorldWind/Layer/WWLayerList.h"
#import "WorldWind/Render/WWSceneController.h"
#import "AppConstants.h"
#import "MessageTableViewController.h"
#import "WWOpenStreetMapLayer.h"
#import "WWBingLayer.h"
#import "Settings.h"
#import "BaterryStatusViewController.h"

@interface DetailViewController ()

@end

@implementation DetailViewController

MessageTableViewController* messageBar;
BaterryStatusViewController* batteryMessageViewController;

// Layers
WWOpenStreetMapLayer* openStreetMapLayer;
WWBingLayer* bingLayer;

#pragma mark - Managing the detail item

- (void)setDetailItem:(id)newDetailItem {
    if (_detailItem != newDetailItem) {
        _detailItem = newDetailItem;
    }
}


- (void) loadView
{
    self.view = [[UIView alloc] init];
    
    [self createWorldWindView];
    [self createMessageBar];
    [self createBatteryStatusMessage];
    [self layout];
}
/*
-(void)viewWillLayoutSubviews{
    
    if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7)
    {
        self.view.clipsToBounds = YES;
        CGRect screenRect = [[UIScreen mainScreen] bounds];
        CGFloat screenHeight = 0.0;
        if(UIDeviceOrientationIsPortrait([[UIApplication sharedApplication] statusBarOrientation]))
            screenHeight = screenRect.size.height;
        else
            screenHeight = screenRect.size.width;
        CGRect screenFrame = CGRectMake(0, 20, self.view.frame.size.width,screenHeight-20);
        CGRect viewFr = [self.view convertRect:self.view.frame toView:nil];
        if (!CGRectEqualToRect(screenFrame, viewFr))
        {
            self.view.frame = screenFrame;
            self.view.bounds = CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height);
        }
    }
}
*/
- (void) createWorldWindView
{
    _wwv = [[WorldWindView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
    if (_wwv == nil)
    {
        NSLog(@"Unable to create a WorldWindView");
        return;
    }
    
    [self.view addSubview:_wwv];
}

-(void)createMessageBar
{
    CGRect frm = CGRectMake(0, self.view.frame.size.height - SPS_MESSAGE_BAR_HEIGHT,
                            self.view.frame.size.width, SPS_MESSAGE_BAR_HEIGHT);
    messageBar = [[MessageTableViewController alloc] initWithFrame:frm];

    [self.view addSubview:[messageBar view]];
    [self addChildViewController:messageBar];
}

-(void)createBatteryStatusMessage{
    batteryMessageViewController = [[BaterryStatusViewController alloc] initWithNibName:@"BaterryStatusViewController" bundle:nil];
    
    [self.view addSubview:[batteryMessageViewController view]];
    [self addChildViewController:batteryMessageViewController];
}

- (void) layout
{
    NSDictionary* viewsDictionary = NSDictionaryOfVariableBindings(_wwv);
    
    [_wwv setTranslatesAutoresizingMaskIntoConstraints:NO];

    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"H:|[_wwv]|" options:0 metrics:nil
                                                                          views:viewsDictionary]];
    [[self view] addConstraints:[NSLayoutConstraint constraintsWithVisualFormat:@"V:|[_wwv]|" options:0
                                                                        metrics:nil views:viewsDictionary]];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WWLog(@"View Did Load. World Wind iOS Version %@", WW_VERSION);
    
    WWLayerList* layers = [[_wwv sceneController] layers];
    
    WWLayer* layer = [[WWBMNGLayer alloc] init];
    
    bingLayer = [[WWBingLayer alloc] init];
    [bingLayer setEnabled:[Settings getBoolForName:[[NSString alloc] initWithFormat:@"gov.fac.cacom5.cetad.sps.layer.enabled.%@", [bingLayer displayName]] defaultValue:YES]];
    
    openStreetMapLayer = [[WWOpenStreetMapLayer alloc] init];
    [openStreetMapLayer setEnabled:[Settings getBoolForName:[[NSString alloc] initWithFormat:@"gov.fac.cacom5.cetad.sps.layer.enabled.%@", [openStreetMapLayer displayName]] defaultValue:YES]];
    
    [layers addLayer:layer];
    [layers addLayer:bingLayer];
    [layers addLayer:openStreetMapLayer];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
