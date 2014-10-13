//
//  TransferDetialsRecipientView.h
//  Transfer
//
//  Created by Juhan Hion on 12.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "IntrinsicSizeUIView.h"

@class Recipient;

@interface TransferDetialsRecipientView : IntrinsicSizeUIView

- (void)configureBlank;

- (void)configureWithRecipient:(Recipient *)recipient;

@end
