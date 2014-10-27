//
//  TransferWaitingViewController.m
//  Transfer
//
//  Created by Juhan Hion on 13.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferWaitingViewController.h"
#import "LightBlueButton.h"
#import "ObjectModel+Payments.h"
#import "Constants.h"
#import "UploadMoneyViewController.h"
#import "UIViewController+SwitchToViewController.h"
#import "TransferBackButtonItem.h"
#import "Currency.h"
#import "PaymentMadeIndicator.h"

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
    NSString *timingString = NSLocalizedString(key,nil);
    if ([timingString isEqualToString:key])
    {
        timingString = NSLocalizedString(@"transfertime.default", nil);
    }
    [self.messageLabel1 setText:[NSString stringWithFormat:NSLocalizedString(@"transferdetails.controller.transfer.message", nil),timingString]];
    
    
	[super setUpHeader];
}

- (void)setBackOrCloseButton
{
	if (IPAD)
	{
		[super setBackOrCloseButton];
	}
	else
	{
		//On iphone this view might be shown as the end for payment process, thus special handling necessary
		[self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonWithTapHandler:^{
			[[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
		}]];
	}
}

- (IBAction)noTransferButtonTap:(id)sender {
    __weak typeof(self) weakSelf = self;
    [self.objectModel performBlock:^{
        [weakSelf.objectModel togglePaymentMadeForPayment:weakSelf.payment payInMethodName:nil];
    }];
	
	if (IPAD)
	{
		[[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
	}
	else
	{
		UploadMoneyViewController *controller = [[UploadMoneyViewController alloc] init];
		[controller setPayment:self.payment];
		[controller setObjectModel:self.objectModel];
		[controller setHideBottomButton:YES];
		[controller setShowContactSupportCell:YES];
		
		[self switchToViewController:controller];
	}
}

- (IBAction)gotItTapped:(id)sender
{
    [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
}

@end
