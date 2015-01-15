//
//  IntroductionViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ObjectModel;
@class Recipient;
@class Currency;

@interface NewPaymentViewController : UIViewController

@property (nonatomic, strong) Recipient *recipient;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, assign) BOOL dummyPresentation;

//Pre-population
@property (nonatomic, strong) NSNumber* suggestedSourceAmount;
@property (nonatomic, strong) NSNumber* suggestedTargetAmount;
@property (nonatomic, strong) Currency* suggestedSourceCurrency;
@property (nonatomic, strong) Currency* suggestedTargetCurrency;
@property (nonatomic, assign) BOOL suggestedTransactionIsFixedTarget;

@end
