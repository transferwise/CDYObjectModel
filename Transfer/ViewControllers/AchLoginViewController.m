//
//  AchLoginViewController.m
//  Transfer
//
//  Created by Juhan Hion on 24.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "AchLoginViewController.h"
#import "SupportCoordinator.h"
#import "Constants.h"
#import "Payment.h"
#import "TransferBackButtonItem.h"

@interface AchLoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *supportButton;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) Payment *payment;
@property (nonatomic, copy) InitiatePullBlock initiatePullBlock;
@property (nonatomic, strong) AchBank *form;

@end

@implementation AchLoginViewController

- (instancetype)initWithForm:(AchBank *)form
					 payment:(Payment *)payment
				initiatePull:(InitiatePullBlock)initiatePullBlock
{
	self = [super init];
	if (self)
	{
		self.form = form;
		self.payment = payment;
		self.initiatePullBlock = initiatePullBlock;
	}
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
	for (UITableView* tableView in self.tableViews)
	{
		[self setupTableView:tableView];
	}
	
	self.cellHeight = IPAD ? 70.0f : 60.0f;
	
	[self setTitle:NSLocalizedString(@"ach.controller.login.title", nil)];
	[self.supportButton setTitle:NSLocalizedString(@"ach.controller.button.support", nil) forState:UIControlStateNormal];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	[self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonWithTapHandler:^{
		[[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
	}]];
}

- (void)setupTableView:(UITableView*)tableView
{
//	[tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
//	[tableView registerNib:[UINib nibWithNibName:@"CurrencySelectionCell" bundle:nil] forCellReuseIdentifier:TWCurrencySelectionCellIdentifier];
//	[tableView registerNib:[UINib nibWithNibName:@"RecipientFieldCell" bundle:nil] forCellReuseIdentifier:TWRecipientFieldCellIdentifier];
//	[tableView registerNib:[UINib nibWithNibName:@"RecipientEntrySelectionCell" bundle:nil] forCellReuseIdentifier:TRWRecipientEntrySelectionCellIdentifier];
//	[tableView registerNib:[UINib nibWithNibName:@"DropdownCell" bundle:nil] forCellReuseIdentifier:TWDropdownCellIdentifier];
//	[tableView registerNib:[UINib nibWithNibName:@"CountrySelectCell" bundle:nil] forCellReuseIdentifier:TWSelectionCellIdentifier];
}

#pragma mark - Support Button

- (IBAction)supportButtonPressed:(id)sender
{
	NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
	[[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
}


@end
