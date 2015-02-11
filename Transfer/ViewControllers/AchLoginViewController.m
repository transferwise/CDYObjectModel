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
#import "RecipientFieldCell.h"
#import "RecipientTypeField.h"
#import "NSMutableString+Issues.h"
#import "TRWAlertView.h"
#import "FieldGroup.h"
#import "AchResponseParser.h"

@interface AchLoginViewController ()

@property (strong, nonatomic) IBOutlet UIButton *supportButton;

@property (nonatomic, assign) CGFloat cellHeight;
@property (nonatomic, strong) Payment *payment;
@property (nonatomic, copy) InitiatePullBlock initiatePullBlock;
@property (nonatomic, strong) AchBank *form;
@property (nonatomic, strong) NSArray *formCells;
@property (nonatomic, strong) NSArray *formKeys;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (strong, nonatomic) IBOutlet UIView *footerView;
@property (strong, nonatomic) IBOutlet UIButton *payButton;
@property (strong, nonatomic) IBOutlet UILabel *messageOneLabel;
@property (strong, nonatomic) IBOutlet UILabel *messageTwoLabel;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *tableViewTopSpace;

@end

@implementation AchLoginViewController

#pragma mark - Init
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

#pragma mark - View lifecycle
- (void)viewDidLoad
{
    [super viewDidLoad];
	
	for (UITableView* tableView in self.tableViews)
	{
		[self setupTableView:tableView];
	}
	
	[self setFooter];
	self.cellHeight = IPAD ? 70.0f : 60.0f;
	
	[self setTitle:NSLocalizedString(@"ach.controller.login.title", nil)];
	[self.supportButton setTitle:NSLocalizedString(@"ach.controller.button.support", nil) forState:UIControlStateNormal];
	[self.payButton setTitle:[NSString stringWithFormat:NSLocalizedString(@"ach.controller.button.pay", nil), [self.payment payInString], self.form.title] forState:UIControlStateNormal];
	[self.messageOneLabel setText:NSLocalizedString(@"ach.controller.label.message.nostore", nil)];
	[self.messageTwoLabel setText:NSLocalizedString(@"ach.controller.label.message.secure", nil)];
	
	[self generateFormCells];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
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
	[self calculateTopOffset];
}

#pragma mark - TableView setup
- (void)setupTableView:(UITableView*)tableView
{
	[tableView registerNib:[UINib nibWithNibName:@"DoublePasswordEntryCell" bundle:nil] forCellReuseIdentifier:TWDoublePasswordEntryCellIdentifier];
	[tableView registerNib:[UINib nibWithNibName:@"RecipientFieldCell" bundle:nil] forCellReuseIdentifier:TWRecipientFieldCellIdentifier];
	[tableView registerNib:[UINib nibWithNibName:@"DropdownCell" bundle:nil] forCellReuseIdentifier:TWDropdownCellIdentifier];
}

- (void)generateFormCells
{
	if (self.form && self.form.fieldGroups.count > 0)
	{
		NSMutableArray *formFields = [[NSMutableArray alloc] init];
		NSMutableArray *formKeys = [[NSMutableArray alloc] init];
		
		for (FieldGroup *group in self.form.fieldGroups)
		{
			[formFields addObjectsFromArray:[TypeFieldHelper generateFieldsArray:self.tableViews[0]
																	fieldsGetter:^NSOrderedSet *{
																		return group.fields;
																	}
																	 objectModel:self.objectModel]];
		}
		
		if (!self.form.fieldType)
		{
			TextEntryCell *firstCell = (TextEntryCell *)formFields[0];
			[firstCell configureWithTitle:[NSString stringWithFormat:NSLocalizedString(@"ach.controller.label.firstfield", nil), firstCell.entryField.placeholder, self.form.title] value:nil];
		}
		
		self.formCells = [NSArray arrayWithArray:formFields];
		
		for (RecipientFieldCell *cell in self.formCells)
		{
			[formKeys addObject:cell.type.fieldForGroup.name];
		}
		
		self.formKeys = [NSArray arrayWithArray:formKeys];
	}
}

- (void)setFooter
{
	if (/*!IPAD &&*/ ![self hasMoreThanOneTableView])
	{
		self.footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		UITableView *table = (UITableView *)self.tableViews[0];
		table.tableFooterView = self.footerView;
	}
}

- (void)calculateTopOffset
{
	if (/*!IPAD &&*/ ![self hasMoreThanOneTableView])
	{
		CGRect footer = [self.footerView convertRect:self.footerView.frame toView:self.view];
		BOOL completelyVisible = CGRectContainsRect(self.view.frame, footer);
		
		//pad only when the footer is completely visible
		if (completelyVisible)
		{
			self.tableViewTopSpace.constant = 50;
		}
	}
}

#pragma mark - Buttons
- (IBAction)payButtonPressed:(id)sender
{
    [self.view endEditing:YES];
	NSString* errors = [self isValid];
	
	if (errors == nil)
	{
		__weak typeof(self) weakSelf = self;
		self.initiatePullBlock([self getFormValues], weakSelf.navigationController);
	}
	else
	{
		TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"ach.controller.error.title", nil) message:errors];
		[alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
		[alertView show];
	}
}

- (IBAction)supportButtonPressed:(id)sender
{
	NSString *subject = [NSString stringWithFormat:NSLocalizedString(@"support.email.payment.subject.base", nil), self.payment.remoteId];
	[[SupportCoordinator sharedInstance] presentOnController:self emailSubject:subject];
}

#pragma mark - Validation
- (NSString *)isValid
{
	NSMutableString *errors = [[NSMutableString alloc] init];
	
	for (RecipientFieldCell *cell in self.formCells)
	{
		RecipientTypeField *field = cell.type;
		
		NSString *value = [cell value];
		NSString *valueIssue = [field hasIssueWithValue:value];
		
		if (valueIssue)
		{
			[errors appendIssue:valueIssue];
		}
	}
	
	if (errors.length > 0)
	{
		return errors;
	}
	
	return nil;
}

#pragma mark - Helpers
- (NSDictionary *)getFormValues
{
	NSMutableDictionary *dict = [AchResponseParser initFormValues:self.form];
	
	for (NSInteger i = 0; i < [self.formKeys count] && i < [self.formCells count]; i++)
	{
		[dict setValue:[(RecipientFieldCell *)self.formCells[i] value] forKey:self.formKeys[i]];
	}
	
	return dict;
}

@end
