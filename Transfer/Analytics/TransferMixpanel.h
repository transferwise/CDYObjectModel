//
//  TransferMixpanel.h
//  Transfer
//
//  Created by Jaanus Siim on 26/03/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransferAnalytics.h"

@class ObjectModel;

@interface TransferMixpanel : NSObject <TransferAnalytics>

@property (nonatomic, strong) ObjectModel *objectModel;

@end
