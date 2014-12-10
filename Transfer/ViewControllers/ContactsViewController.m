//
//  ContactsViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ContactsViewController.h"
#import "Constants.h"
#import "RecipientCell.h"
#import "UIColor+Theme.h"
#import "UserRecipientsOperation.h"
#import "TRWAlertView.h"
#import "TRWProgressHUD.h"
#import "RecipientViewController.h"
#import "DeleteRecipientOperation.h"
#import "NewPaymentViewController.h"
#import "RecipientProfileCommitter.h"
#import "ObjectModel+Currencies.h"
#import "ObjectModel+Recipients.h"
#import "Recipient.h"
#import "Currency.h"
#import "ObjectModel+CurrencyPairs.h"
#import "TabBarActivityIndicatorView.h"
#import "_RecipientType.h"
#import "RecipientType.h"
#import "GoogleAnalytics.h"
#import "AddressBookManager.h"
#import "ConnectionAwareViewController.h"
#import "RecipientsFooterView.h"
#import "ContactDetailsViewController.h"
#import "ReferralsCoordinator.h"
#import "SendButtonFlashHelper.h"
#import "CurrenciesOperation.h"
#import "CurrencyPairsOperation.h"

NSString *const kRecipientCellIdentifier = @"kRecipientCellIdentifier";

@interface ContactsViewController () <UITableViewDelegate, UITableViewDataSource, RecipientsFooterViewDelegate, ContactDetailsDeleteDelegate>

@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, strong) NSArray *allRecipients;
@property (nonatomic, strong) RecipientsFooterView *footerView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet UILabel *noRecipientsMessage;

@end

@implementation ContactsViewController

- (id)init
{
    self = [super initWithNibName:@"ContactsViewController" bundle:nil];
    if (self)
	{
        [self setTitle:NSLocalizedString(@"contacts.controller.title", nil)];
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, 88, 44)];
        [button addTarget:self  action:@selector(addContactPressed) forControlEvents:UIControlEventTouchUpInside];
        [button setImage:[UIImage imageNamed:@"AddButton"] forState:UIControlStateNormal];
		[button setImageEdgeInsets:UIEdgeInsetsMake(0, 58, 0, -17)];
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithCustomView:button];
        [self.navigationItem setRightBarButtonItem:addButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"RecipientCell" bundle:nil] forCellReuseIdentifier:kRecipientCellIdentifier];
    
    self.titleLabel.text = self.title;
    
    self.noRecipientsMessage.text = NSLocalizedString(@"empty.contacts", nil);
    
    [self loadAllRequiredData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];

    if (!self.allRecipients)
	{
        [self setAllRecipients:[self.objectModel allUserRecipientsForDisplay]];
        [self.tableView reloadData];
    }

    [self refreshRecipients];
	
	self.tableView.tableFooterView = self.footerView;
    
    if(IPAD)
    {
        [self.navigationController setNavigationBarHidden:YES animated:YES];
    }
    else
    {
        [self.navigationController setNavigationBarHidden:NO animated:YES];
    }
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[[GoogleAnalytics sharedInstance] sendScreen:@"Recipients"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    [SendButtonFlashHelper setSendFlash:NO];
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    for(RecipientCell* cell in [self.tableView visibleCells])
    {
        [cell setIsCancelVisible:NO animated:NO];
    }
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    //last row will be invite cell
    return self.allRecipients.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipientCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipientCellIdentifier];
    Recipient *recipient = [self.allRecipients objectAtIndex:indexPath.row];
	
    [cell configureWithRecipient:recipient
		   willShowCancelBlock:^{
			   //this will be called each time a touch starts
			   //including the touch that hides the button
			   //so not cancelling if the same cell is receiving touches
			   if(self.cancellingCellIndex && self.cancellingCellIndex.row != indexPath.row)
			   {
				   [self removeCancellingFromCell];
			   }
		   }
			didShowCancelBlock:^{
				self.cancellingCellIndex = indexPath;
			}
			didHideCancelBlock:^{
				self.cancellingCellIndex = nil;
			}
			 cancelTappedBlock:^{
				 [self confirmRecipientDelete:recipient indexPath:indexPath];
			 }];
	
	UITapGestureRecognizer* recognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(sendTapped:)];
	[recognizer setNumberOfTapsRequired:1];
	[cell.sendLabel addGestureRecognizer:recognizer];
	
	//set cancelling visible when scrolling
	[self setCancellingVisibleForScrolling:cell indexPath:indexPath];

    return cell;
}

- (void)sendTapped:(UITapGestureRecognizer *)gestureRecognizer
{
	[self removeCancellingFromCell];
	CGPoint point = [gestureRecognizer locationInView:self.tableView];
	NSIndexPath* indexPath = [self.tableView indexPathForRowAtPoint:point];
	
	if (indexPath)
	{
		Recipient *recipient = [self.allRecipients objectAtIndex:indexPath.row];
		
		if ([recipient.type hideFromCreationValue])
		{
			return;
		}
		
		if (![self.objectModel canMakePaymentToCurrency:recipient.currency])
		{
			TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"payment.controller.currency.payment.error.title", nil)
															   message:[NSString stringWithFormat:NSLocalizedString(@"payment.controller.currency.payment.error.message", nil), recipient.currency.code]];
			[alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
			[alertView show];
			return;
		}
		
		[[GoogleAnalytics sharedInstance] sendScreen:@"New payment to"];
		NewPaymentViewController *controller = [[NewPaymentViewController alloc] init];
		[controller setObjectModel:self.objectModel];
		[controller setRecipient:recipient];
		ConnectionAwareViewController *wrapper = [ConnectionAwareViewController createWrappedNavigationControllerWithRoot:controller navBarHidden:YES];
		[self presentViewController:wrapper animated:YES completion:nil];
	}
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
	[self removeCancellingFromCell];
    ContactDetailsViewController* detailController = [[ContactDetailsViewController alloc] init];
    detailController.objectModel = self.objectModel;
    detailController.recipient = [self.allRecipients objectAtIndex:indexPath.row];
    detailController.deletionDelegate = self;
    [self presentDetail:detailController];
}

-(void)loadAllRequiredData
{
    self.noRecipientsMessage.hidden = YES;
    
    //Retrieve currency pairs.
    CurrenciesOperation *currenciesOperation = [CurrenciesOperation operation];
    currenciesOperation.objectModel = self.objectModel;
    [self setExecutedOperation:currenciesOperation];
    __weak typeof (self) weakSelf = self;
    [currenciesOperation setResultHandler:^(NSError* error)
     {
         CurrencyPairsOperation *operation = [CurrencyPairsOperation pairsOperation];
         [weakSelf setExecutedOperation:operation];
         [operation setObjectModel:weakSelf.objectModel];
         
         [operation setCurrenciesHandler:^(NSError *error) {
             [weakSelf setExecutedOperation:nil];
             [weakSelf refreshRecipients];
         }];
         [operation execute];
     }];
    [currenciesOperation execute];
}

- (void)refreshRecipients
{
    MCLog(@"refreshRecipients");
    if (self.executedOperation)
	{
        return;
    }

    self.noRecipientsMessage.hidden = YES;
    [SendButtonFlashHelper setSendFlash:NO];
    
    UserRecipientsOperation *operation = [UserRecipientsOperation recipientsOperation];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setResponseHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
			self.allRecipients = [self.objectModel allUserRecipientsForDisplay];
            MCLog(@"Have %lu recipients", (unsigned long)self.allRecipients.count);

            [self setExecutedOperation:nil];

            [self handleListRefreshWithPossibleError:error];
        });
    }];

    [operation execute];
}

- (IBAction)addContactPressed
{
	[[GoogleAnalytics sharedInstance] sendScreen:@"Add recipient"];

    RecipientViewController *controller = [[RecipientViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setTitle:NSLocalizedString(@"recipient.controller.add.mode.title", nil)];
    [controller setFooterButtonTitle:NSLocalizedString(@"recipient.controller.add.button.title", nil)];
    RecipientProfileCommitter *committer = [[RecipientProfileCommitter alloc] init];
    [committer setObjectModel:self.objectModel];
    [controller setRecipientValidation:committer];
    __weak typeof(self) weakSelf = self;
    [controller setAfterSaveAction:^{
        [[GoogleAnalytics sharedInstance] sendNewRecipentEventWithLabel:@"AddRecipientScreen"];
        [weakSelf closeModal];
    }];
    controller.noPendingPayment = YES;
    
    ConnectionAwareViewController *wrapper = [ConnectionAwareViewController createWrappedNavigationControllerWithRoot:controller navBarHidden:NO];
    
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,40,40)];
    [closeButton setImage:[UIImage imageNamed:@"CloseButton"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(closeModal) forControlEvents:UIControlEventTouchUpInside];
    if(!IPAD)
    {
        closeButton.imageEdgeInsets = UIEdgeInsetsMake(0.0, -20, 0, 0);
    }
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    [controller.navigationItem setLeftBarButtonItem:dismissButton];
    
    [self presentViewController:wrapper animated:YES completion:nil];

}

-(void)closeModal
{
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)inviteFriends
{
	ReferralsCoordinator* coordinator = [ReferralsCoordinator sharedInstanceWithObjectModel:self.objectModel];
	[coordinator presentOnController:self];
}

- (void)confirmRecipientDelete:(Recipient *)recipient indexPath:(NSIndexPath *)indexPath
{
	TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"contacts.controller.delete.conformation.title", nil)
                                                       message:[NSString stringWithFormat:NSLocalizedString(@"contacts.controller.delete.confirmation.message", nil), recipient.name]];
    [alertView setLeftButtonTitle:NSLocalizedString(@"button.title.delete", nil) rightButtonTitle:NSLocalizedString(@"button.title.cancel", nil)];

    [alertView setLeftButtonAction:^{
        [self deleteRecipient:recipient];
		[self removeCancellingFromCell];
    }];
	[alertView setRightButtonAction:^{
		[self removeCancellingFromCell];
    }];

    [alertView show];
}

- (void)deleteRecipient:(Recipient *)recipient
{
	[self clearDeletedRecipient:recipient];
	
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"Delete recipient:%@", recipient.name);
        TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
        [hud setMessage:NSLocalizedString(@"contacts.controller.deleting.message", nil)];

        DeleteRecipientOperation *operation = [DeleteRecipientOperation operationWithRecipient:recipient];
        [self setExecutedOperation:operation];
        [operation setObjectModel:self.objectModel];
		
        [operation setResponseHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
				[self setExecutedOperation:nil];
                [hud hide];
                [self refreshRecipients];
				
                if(!IPAD)
				{
					[self.navigationController popViewControllerAnimated:YES];
				}
            });
        }];

        [operation execute];
    });
}

- (void)clearDeletedRecipient:(Recipient *)recipient
{
	//clear selected view before deleting in case recipient to be deleted is selected
	ContactDetailsViewController* detailsController = (ContactDetailsViewController*)[self currentDetailController];
	if(detailsController.recipient == recipient)
	{
		[self presentDetail:nil];
	}
	
	//delete recipient from current recipient so it cannot be used to initiate transfers while deletion is in progress
	NSMutableArray *mutableRecipients = [[NSMutableArray alloc] initWithArray:self.allRecipients];
	[mutableRecipients removeObject:recipient];
	[self.tableView reloadData];
}

- (void)handleListRefreshWithPossibleError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setExecutedOperation:nil];
        if (error)
		{
            return;
        }
		
        NSInteger currentCount = self.allRecipients.count;
		[self.tableView reloadData];
        NSInteger delta = [self.tableView numberOfRowsInSection:0] - currentCount;
		
        if (delta >0)
        {
            [self.tableView reloadRowsAtIndexPaths:[ContactsViewController generateIndexPathsFrom:currentCount
																						withCount:delta]
							  withRowAnimation:UITableViewRowAnimationFade];
        }
		if (currentCount > 0)
		{
			[self setFooter];
		}
        else
        {
            self.noRecipientsMessage.hidden = NO;
            self.noRecipientsMessage.alpha = 0.0f;
            [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                self.noRecipientsMessage.alpha = 1.0f;
            } completion:nil];
            if(self.isViewLoaded && self.view.window)
            {
                [SendButtonFlashHelper setSendFlash:YES];
            }
        }
    });
}

- (void)setFooter
{
	if (!IPAD)
	{
		self.footerView = [[[NSBundle mainBundle] loadNibNamed:@"RecipientsFooterView" owner:self options:nil] objectAtIndex:0];
        [self.footerView setAmountString:[[ReferralsCoordinator sharedInstanceWithObjectModel:self.objectModel] rewardAmountString]];
		self.footerView.delegate = self;
		self.footerView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
		self.tableView.tableFooterView = self.footerView;
	}
}

#pragma mark - Contact Detail Deletion
-(void)contactDetailsController:(ContactDetailsViewController *)controller didDeleteContact:(Recipient *)deletedRecipient
{
    [self confirmRecipientDelete:deletedRecipient indexPath:nil];
}

#pragma mark - Clear Data
- (void)clearData
{
	self.allRecipients = nil;
	[self.tableView reloadData];
}

@end
