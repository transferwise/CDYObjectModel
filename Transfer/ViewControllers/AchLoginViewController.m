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
#import "DoublePasswordEntryCell.h"
#import "DropdownCell.h"
#import "RecipientFieldCell.h"
#import "TypeFieldHelper.h"
#import "AchBank.h"
#import "FieldGroup.h"

@interface AchLoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *supportButton;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) Payment *payment;
@property (nonatomic, copy) InitiatePullBlock initiatePullBlock;
@property (nonatomic, strong) AchBank *form;
@property (nonatomic, strong) NSArray *formCells;
@property (nonatomic, strong) ObjectModel *objectModel;

@end

@implementation AchLoginViewController

- (instancetype)initWithForm:(AchBank *)form
					 payment:(Payment *)payment
				 objectModel:(ObjectModel *)objectModel
				initiatePull:(InitiatePullBlock)initiatePullBlock
{
	self = [super init];
	if (self)
	{
		self.form = form;
		self.payment = payment;
		self.objectModel = objectModel;
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
	
	if (self.form && self.form.fieldGroups.count > 0)
	{
		NSMutableArray *formFields = [[NSMutableArray alloc] init];
		
		for (FieldGroup *group in self.form.fieldGroups)
		{
			[formFields addObjectsFromArray:[TypeFieldHelper generateFieldsArray:self.tableViews[0]
																   fieldsGetter:^NSOrderedSet *{
																	   return group.fields;
																   }
																	 objectModel:self.objectModel]];
		}
		
		self.formCells = [NSArray arrayWithArray:formFields];
	}
}

- (void)viewWillAppear:(BOOL)animated
{
	[self refreshTableViewSizes];
	[self configureForInterfaceOrientation:self.interfaceOrientation];
	
	[self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];
	
	if([self hasMoreThanOneTableView])
	{
		[self setSectionCellsByTableView:@[@[self.formCells], @[]]];
	}
	else
	{
		[self setSectionCellsByTableView:@[@[self.formCells, @[]]]];
	}
	
	[self.tableViews makeObjectsPerformSelector:@selector(reloadData)];
	
	[self refreshTableViewSizes];
	[self configureForInterfaceOrientation:self.interfaceOrientation];
}

- (void)setupTableView:(UITableView*)tableView
{
	[tableView registerNib:[UINib nibWithNibName:@"DoublePasswordEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
	[tableView registerNib:[UINib nibWithNibName:@"RecipientFieldCell" bundle:nil] forCellReuseIdentifier:TWRecipientFieldCellIdentifier];
	[tableView registerNib:[UINib nibWithNibName:@"DropdownCell" bundle:nil] forCellReuseIdentifier:TWDropdownCellIdentifier];
}

#pragma mark - Support Button

- (IBAction)supportButtonPressed:(id)sender
{
	NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
	[[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
}

@end
