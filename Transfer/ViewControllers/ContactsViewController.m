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

NSString *const kRecipientCellIdentifier = @"kRecipientCellIdentifier";

@interface ContactsViewController () <NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, strong) NSFetchedResultsController *allRecipients;

@end

@implementation ContactsViewController

- (id)init
{
    self = [super initWithNibName:@"ContactsViewController" bundle:nil];
    if (self)
	{
        [self setTitle:NSLocalizedString(@"contacts.controller.title", nil)];
        UIBarButtonItem *addButton = [[UIBarButtonItem alloc] initWithImage:[UIImage imageNamed:@"AddButton.png"] style:UIBarButtonItemStylePlain target:self action:@selector(addContactPressed)];
        [self.navigationItem setRightBarButtonItem:addButton];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"RecipientCell" bundle:nil] forCellReuseIdentifier:kRecipientCellIdentifier];
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
        NSFetchedResultsController *controller = [self.objectModel fetchedControllerForAllUserRecipients];
        [self setAllRecipients:controller];
        [controller setDelegate:self];

        [self.tableView reloadData];
    }

    [self refreshRecipients];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];

	[[GoogleAnalytics sharedInstance] sendScreen:@"Recipients"];
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [[self.allRecipients sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.allRecipients sections] objectAtIndex:(NSUInteger) section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    RecipientCell *cell = [tableView dequeueReusableCellWithIdentifier:kRecipientCellIdentifier];
    Recipient *recipient = [self.allRecipients objectAtIndexPath:indexPath];
	
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
		Recipient *recipient = [self.allRecipients objectAtIndexPath:indexPath];
		
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
		UINavigationController *navigationController = [[UINavigationController alloc] initWithRootViewController:controller];
		[navigationController setNavigationBarHidden:YES];
		ConnectionAwareViewController *wrapper = [[ConnectionAwareViewController alloc] initWithWrappedViewController:navigationController];
		
		[self presentViewController:wrapper animated:YES completion:nil];
	}
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
	[self removeCancellingFromCell];
}

- (void)refreshRecipients
{
    MCLog(@"refreshRecipients");
    if (self.executedOperation)
	{
        return;
    }

    TabBarActivityIndicatorView *hud = [TabBarActivityIndicatorView showHUDOnController:self];
    [hud setMessage:NSLocalizedString(@"contacts.controller.refreshing.message", nil)];

    UserRecipientsOperation *operation = [UserRecipientsOperation recipientsOperation];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setResponseHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            MCLog(@"Have %d recipients", [self.allRecipients.fetchedObjects count]);

            [hud hide];

            [self setExecutedOperation:nil];

            [self handleListRefreshWithPossibleError:error];
        });
    }];

    [operation execute];
}

- (void)addContactPressed
{
	[[GoogleAnalytics sharedInstance] sendScreen:@"Add recipient"];

    RecipientViewController *controller = [[RecipientViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [controller setTitle:NSLocalizedString(@"recipient.controller.add.mode.title", nil)];
    [controller setFooterButtonTitle:NSLocalizedString(@"recipient.controller.add.button.title", nil)];
    RecipientProfileCommitter *committer = [[RecipientProfileCommitter alloc] init];
    [committer setObjectModel:self.objectModel];
    [controller setRecipientValidation:committer];
    [controller setAfterSaveAction:^{
        [[GoogleAnalytics sharedInstance] sendEvent:@"RecipientAdded" category:@"recipient" label:@"AddRecipientScreen"];
        [self.navigationController popViewControllerAnimated:YES];
    }];
    [self.navigationController pushViewController:controller animated:YES];
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
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"Delete recipient:%@", recipient.name);
        TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
        [hud setMessage:NSLocalizedString(@"contacts.controller.deleting.message", nil)];

        DeleteRecipientOperation *operation = [DeleteRecipientOperation operationWithRecipient:recipient];
        [self setExecutedOperation:operation];
        [operation setObjectModel:self.objectModel];
        [operation setResponseHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide];
                [self handleListRefreshWithPossibleError:error];
            });
        }];

        [operation execute];
    });
}

- (void)handleListRefreshWithPossibleError:(NSError *)error
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [self setExecutedOperation:nil];
        if (error) {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"contacts.refresh.error.title", nil)
                                                               message:NSLocalizedString(@"contacts.refresh.error.message", nil)];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
            [alertView show];

            return;
        }

        [self.tableView reloadData];
    });
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath
{
    UITableView *tableView = self.tableView;

    switch (type)
	{
        case NSFetchedResultsChangeInsert:
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeDelete:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
        case NSFetchedResultsChangeUpdate:
            [tableView reloadRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationNone];
            break;
        case NSFetchedResultsChangeMove:
            [tableView deleteRowsAtIndexPaths:[NSArray arrayWithObject:indexPath] withRowAnimation:UITableViewRowAnimationFade];
            [tableView insertRowsAtIndexPaths:[NSArray arrayWithObject:newIndexPath] withRowAnimation:UITableViewRowAnimationFade];
            break;
    }
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self.tableView endUpdates];
}

@end
