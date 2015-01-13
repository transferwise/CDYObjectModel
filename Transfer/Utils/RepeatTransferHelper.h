//
//  RepeatTransferHelper.h
//  Transfer
//
//  Created by Mats Trovik on 13/01/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Payment;
@class ObjectModel;

@interface RepeatTransferHelper : NSObject

-(void)repeatTransfer:(Payment*)payment objectModel:(ObjectModel*)objectModel;

@end
