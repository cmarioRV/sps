//
//  DetailViewController.h
//  SPSApp
//
//  Created by Inter-Telco MacAir on 2/09/15.
//  Copyright (c) 2015 FAC. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WorldWindView;

@interface DetailViewController : UIViewController

@property (strong, nonatomic) id detailItem;
@property (weak, nonatomic) IBOutlet UILabel *detailDescriptionLabel;
@property (nonatomic, readonly) WorldWindView* wwv;

@end

