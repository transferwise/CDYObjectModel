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

@class PlainRecipient;
@class PlainRecipientType;
@class ObjectModel;
@class Currency;
@protocol RecipientProfileValidation;

@interface RecipientViewController : DataEntryViewController

@property (nonatomic, copy) TRWActionBlock afterSaveAction;
@property (nonatomic, copy) NSString *footerButtonTitle;
@property (nonatomic, strong) Currency *preLoadRecipientsWithCurrency;
@property (nonatomic, strong) id<RecipientProfileValidation> recipientValidation;
@property (nonatomic, strong) ObjectModel *objectModel;


- (PlainRecipient *)selectedRecipient;
- (PlainRecipientType *)selectedRecipientType;
- (NSArray *)recipientTypes;

@end
