//
//  TransferPayIPadViewController.m
//  Transfer
//
//  Created by Juhan Hion on 15.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferPayIPadViewController.h"
#import "TransferDetialsHeaderView.h"
#import "NSString+DeviceSpecificLocalisation.h"
#import "UploadMoneyViewController.h"

@interface TransferPayIPadViewController ()

@property (strong, nonatomic) IBOutlet TransferDetialsHeaderView *headerView;
@property (strong, nonatomic) IBOutlet UIButton *payButton;
@property (strong, nonatomic) IBOutlet UIButton *supportButton;
@property (strong, nonatomic) IBOutlet UIButton *cancelButton;

@end

@implementation TransferPayIPadViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)setUpHeader
{
	[super setUpHeader];
	//init buttons here
}

- (void)setUpAmounts
{
	//empty
}

- (void)setUpAccounts
{
	//empty
}

-(IBAction)buttonaction
{
    UploadMoneyViewController *controller = [[UploadMoneyViewController alloc] init];
    [controller setPayment:self.payment];
    [controller setObjectModel:self.objectModel];
    [controller setHideBottomButton:YES];
    [controller setShowContactSupportCell:YES];
    [self.navigationController pushViewController:controller animated:YES];
}
@end
