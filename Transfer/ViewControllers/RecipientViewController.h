//
//  RecipientViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 5/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SuggestionDataEntryViewController.h"
#import "Constants.h"

@class ObjectModel;
@class Currency;
@class Recipient;
@protocol RecipientProfileValidation;

typedef NS_ENUM(short, RecipientReportingType) {
    RecipientReportingNone = 0,
    RecipientReportingNotLoggedIn,
    RecipientReportingLoggedIn
};

@interface RecipientViewController : SuggestionDataEntryViewController
@property (nonatomic, copy) TRWActionBlock afterSaveAction;
@property (nonatomic, copy) NSString *footerButtonTitle;
@property (nonatomic, strong) Currency *preLoadRecipientsWithCurrency;
@property (nonatomic, strong) id<RecipientProfileValidation> recipientValidation;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, assign) BOOL showMiniProfile;
@property (nonatomic, assign) RecipientReportingType reportingType;

@property (nonatomic, strong) Recipient* templateRecipient;
@property (nonatomic, strong) Recipient* updateRecipient;

//Set YES if adding recipient without payment flow.
@property (nonatomic, assign) BOOL noPendingPayment;

@end
