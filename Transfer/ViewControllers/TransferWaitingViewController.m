//
//  TransferWaitingViewController.m
//  Transfer
//
//  Created by Juhan Hion on 13.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferWaitingViewController.h"
#import "LightGrayButton.h"

@interface TransferWaitingViewController ()

@property (strong, nonatomic) IBOutlet UILabel *thankYouLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel1;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel2;
@property (strong, nonatomic) IBOutlet UILabel *messageLabel3;
@property (strong, nonatomic) IBOutlet UIButton *noTransferButton;

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
	[self.messageLabel1 setText:NSLocalizedString(@"transferdetails.controller.transfer.message1", nil)];
	[self.messageLabel2 setText:NSLocalizedString(@"transferdetails.controller.transfer.message2", nil)];
	[self.messageLabel3 setText:NSLocalizedString(@"transferdetails.controller.transfer.message3", nil)];
	[super setUpHeader];
}

- (IBAction)noTransferButtonTap:(id)sender {
}
@end
