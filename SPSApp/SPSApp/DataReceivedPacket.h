//
//  DataReceivedPacket.h
//  SPSApp
//
//  Created by Inter-Telco MacAir on 22/01/16.
//  Copyright (c) 2016 FAC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DataReceivedPacket : NSObject
@property (strong, nonatomic) NSData *data;
@property (strong, nonatomic) NSMutableString *stringData;
@property (strong, nonatomic) NSString *formattedDate;
@end
