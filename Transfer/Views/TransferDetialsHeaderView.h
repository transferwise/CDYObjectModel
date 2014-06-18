//
//  TransferDetialsHeaderView.h
//  Transfer
//
//  Created by Juhan Hion on 11.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntrinsicSizeUIView.h"

@interface TransferDetialsHeaderView : IntrinsicSizeUIView

@property (weak, nonatomic) NSString* transferNumber;
@property (weak, nonatomic) NSString* recipientName;
@property (weak, nonatomic) NSString* status;
@property (weak, nonatomic) NSString* statusWaiting;

@end
