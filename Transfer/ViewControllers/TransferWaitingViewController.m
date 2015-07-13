//
//  TransferWaitingViewController.m
//  Transfer
//
//  Created by Juhan Hion on 13.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "Constants.h"
#import "Currency.h"
#import "CustomInfoViewController+NoPayInMethods.h"
#import "CustomInfoViewController+Notifications.h"
#import "LightBlueButton.h"
#import "NSString+Presentation.h"
#import "ObjectModel+Payments.h"
#import "PaymentMadeIndicator.h"
#import "PaymentMethodDisplayHelper.h"
#import "PaymentMethodSelectorViewController.h"
#import "PushNotificationsHelper.h"
#import "TransferBackButtonItem.h"
#import "TransferWaitingViewController.h"
#import "UIViewController+SwitchToViewController.h"
#import "UploadMoneyViewController.h"

@interface TransferWaitingViewController ()

@property (strong, nonatomic) IBOutlet UILabel *thankYouLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel1;
@property (strong, nonatomic) IBOutlet ColoredButton *noTransferButton;
@property (weak, nonatomic) IBOutlet ColoredButton *gotItButton;

@end

@implementation TransferWaitingViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	[self.noTransferButton setTitle:NSLocalizedString(@"transferdetails.controller.button.notransfer", nil) forState:UIControlStateNormal];
    self.noTransferButton.hidden = !self.payment.paymentMadeIndicator || (![self.payment.paymentMadeIndicator isCancellable]);
    [self.gotItButton setTitle:NSLocalizedString(@"transferdetails.controller.button.gotit", nil) forState:UIControlStateNormal];
}

- (void)setUpAccounts
{
	//overridden to display nothing
}

- (void)setUpAmounts
{
	//overridden to display nothing
}

- (void)setUpHeader
{
	[self.thankYouLabel setText:NSLocalizedString(@"transferdetails.controller.transfer.thankyou", nil)];
    
    NSString *key = [NSString stringWithFormat:@"transfertime.%@.%@",self.payment.sourceCurrency.code,self.payment.paymentMadeIndicator.payInMethodName];
    NSString *fallbackKey = [NSString stringWithFormat:@"transfertime.%@",self.payment.sourceCurrency.code];
    NSString *timingString = [NSString localizedStringForKey:key withFallback:[NSString localizedStringForKey:fallbackKey withFallback:NSLocalizedString(@"transfertime.default", nil)]];
    [self.messageLabel1 setText:[NSString stringWithFormat:NSLocalizedString(@"transferdetails.controller.transfer.message", nil),timingString]];
	[super setUpHeader];
}

- (IBAction)noTransferButtonTap:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self.objectModel performBlock:^{
        [weakSelf.objectModel togglePaymentMadeForPayment:weakSelf.payment payInMethodName:nil];
        dispatch_async(dispatch_get_main_queue(), ^{
            if (IPAD)
            {
                [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil userInfo:@{@"paymentId":self.payment.remoteId}];
            }
        });
    }];
	
	if (!IPAD)
	{
        UIViewController* controller;
        if([PaymentMethodDisplayHelper displayErrorForPayment: self.payment])
        {
            CustomInfoViewController* errorScreen = [CustomInfoViewController failScreenNoPayInMethodsForCurrency:self.payment.sourceCurrency];
            [errorScreen presentOnViewController:self.navigationController.parentViewController];
            return;
        }
        else if ([PaymentMethodDisplayHelper displayMethodForPayment: self.payment] == kDisplayAsList)
        {
            PaymentMethodSelectorViewController* selector = [[PaymentMethodSelectorViewController alloc] init];
            selector.objectModel = self.objectModel;
            selector.payment = self.payment;
            controller = selector;
        }
        else
        {
            UploadMoneyViewController *uploadController = [[UploadMoneyViewController alloc] init];
            [uploadController setPayment:self.payment];
            [uploadController setObjectModel:self.objectModel];
            [uploadController setHideBottomButton:YES];
            [uploadController setShowContactSupportCell:YES];
            controller = uploadController;
        }
		
		
		[self switchToViewController:controller];
	}
}

- (IBAction)gotItTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
}

+(instancetype)endOfFlowInstanceForPayment:(Payment*)payment objectModel:(ObjectModel*)objectModel
{
    TransferWaitingViewController *waitingController = [[TransferWaitingViewController alloc] init];
    waitingController.payment = payment;
    waitingController.objectModel = objectModel;
    waitingController.showClose = YES;
    waitingController.promptForNotifications = [PushNotificationsHelper shouldPresentNotificationsPrompt];

    return waitingController;
}

@end
