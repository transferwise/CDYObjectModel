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

@class PlainCurrency;
@class PlainRecipient;
@class PlainRecipientType;
@protocol RecipientProfileValidation;
@class ObjectModel;

@interface RecipientViewController : DataEntryViewController

@property (nonatomic, copy) TRWActionBlock afterSaveAction;
@property (nonatomic, copy) NSString *footerButtonTitle;
@property (nonatomic) PlainCurrency *preLoadRecipientsWithCurrency;
@property (nonatomic, strong, readonly) PlainRecipient *selectedRecipient;
@property (nonatomic, strong, readonly) PlainRecipientType *selectedRecipientType;
@property (nonatomic, strong, readonly) NSArray *recipientTypes;
@property (nonatomic, strong) id<RecipientProfileValidation> recipientValidation;
@property (nonatomic, strong) ObjectModel *objectModel;

@end
