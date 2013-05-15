//
//  RecipientViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 5/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "DataEntryViewController.h"
#import "Constants.h"

@class Currency;
@class Recipient;
@class RecipientType;

@interface RecipientViewController : DataEntryViewController

@property (nonatomic, copy) TRWActionBlock afterSaveAction;
@property (nonatomic, copy) NSString *footerButtonTitle;
@property (nonatomic) Currency *preloadRecipientsWithCurrency;
@property (nonatomic, strong, readonly) Recipient *selectedRecipient;
@property (nonatomic, strong, readonly) RecipientType *selectedRecipientType;
@property (nonatomic, strong, readonly) NSArray *recipientTypes;

@end
