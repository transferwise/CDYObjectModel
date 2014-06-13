//
//  TransferDetialsRecipientView.h
//  Transfer
//
//  Created by Juhan Hion on 12.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Recipient;

@interface TransferDetialsRecipientView : UIView

- (void)configureWithRecipient:(Recipient *)recipient;

@end
