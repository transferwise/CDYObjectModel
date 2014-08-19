//
//  TransactionsViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransactionsViewController.h"
#import "PaymentsOperation.h"
#import "UIColor+Theme.h"
#import "PaymentCell.h"
#import "ObjectModel.h"
#import "ObjectModel+Payments.h"
#import "TabBarActivityIndicatorView.h"
#import "UploadVerificationFileOperation.h"
#import "Payment.h"
#import "BankTransferViewController.h"
#import "ConfirmPaymentViewController.h"
#import "PaymentDetailsViewController.h"
#import "Recipient.h"
#import "RecipientType.h"
#import "UploadMoneyViewController.h"
#import "GoogleAnalytics.h"
#import "IdentificationNotificationView.h"
#import "UIView+Loading.h"
#import "CheckPersonalProfileVerificationOperation.h"
#import "PersonalProfileIdentificationViewController.h"
#import "PendingPayment.h"
#import "PaymentPurposeOperation.h"

#import "PullToRefreshView.h"
#import "TransferDetailsViewController.h"
#import "TransferWaitingViewController.h"
#import "TRWAlertView.h"
#import "TRWProgressHUD.h"
#import "UIGestureRecognizer+Cancel.h"
#import "CancelHelper.h"
#import "Currency.h"


NSString *const kPaymentCellIdentifier = @"kPaymentCellIdentifier";

@interface TransactionsViewController () <UIScrollViewDelegate, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, PullToRefreshViewDelegate>

@property (nonatomic, strong) PaymentsOperation *executedOperation;
@property (nonatomic, strong) IBOutlet UIView *loadingFooterView;
@property (nonatomic, strong) NSFetchedResultsController *payments;
@property (nonatomic, strong) IdentificationNotificationView *identificationView;
@property (nonatomic, assign) BOOL showIdentificationView;
@property (nonatomic, strong) CheckPersonalProfileVerificationOperation *checkOperation;
@property (nonatomic, assign) IdentificationRequired identificationRequired;
@property (nonatomic, strong) TransferwiseOperation *executedUploadOperation;
@property (nonatomic, weak) PullToRefreshView* refreshView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) CGPoint touchStart;

@end

@implementation TransactionsViewController

- (id)init {
    self = [super initWithNibName:@"TransactionsViewController" bundle:nil];
    if (self) {
        [self setTitle:NSLocalizedString(@"transactions.controller.title", nil)];
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self.tableView registerNib:[UINib nibWithNibName:@"PaymentCell" bundle:nil] forCellReuseIdentifier:kPaymentCellIdentifier];
    PullToRefreshView* refreshView = [PullToRefreshView addInstanceToScrollView:self.tableView];
    refreshView.targetHeight = 60.0f;
    refreshView.delegate = self;
    self.refreshView = refreshView;

    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:footer];

	IdentificationNotificationView *notificationView = [IdentificationNotificationView loadInstance];
	[self setIdentificationView:notificationView];
	[notificationView setTapHandler:^{
		[self pushIdentificationScreen];
	}];
    
    self.titleLabel.text = self.title;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.tableView setContentOffset:CGPointMake(0,- self.tableView.contentInset.top)];

    if (!self.payments) {
        NSFetchedResultsController *controller = [self.objectModel fetchedControllerForAllPayments];
        [self setPayments:controller];
        [controller setDelegate:self];
        [self.tableView reloadData];
    }

    [self refreshPaymentsList];
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
    [self.navigationController setNavigationBarHidden:IPAD animated:YES];

	[self checkPersonalVerificationNeeded];
}

- (void)viewDidAppear:(BOOL)animated {
	[super viewDidAppear:animated];
	
	//select first row for ipad
	if(IPAD && [self.payments.fetchedObjects count] > 0)
	{
		[self tableView:self.tableView didSelectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
	}

	[[GoogleAnalytics sharedInstance] sendScreen:@"View transfers"];
}
#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [[self.payments sections] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id <NSFetchedResultsSectionInfo> sectionInfo = [[self.payments sections] objectAtIndex:(NSUInteger) section];
    return [sectionInfo numberOfObjects];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:kPaymentCellIdentifier];
    Payment *payment = [self.payments objectAtIndexPath:indexPath];
	
	[cell configureWithPayment:payment
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
				 [self confirmPaymentCancel:payment cellIndex:indexPath];
			 }];

	//set cancelling visible when scrolling
	[self setCancellingVisibleForScrolling:cell indexPath:indexPath];
	
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Payment *payment = [self.payments objectAtIndexPath:indexPath];
    if ([payment.recipient.type hideFromCreationValue]) {
        return;
    }

	[[GoogleAnalytics sharedInstance] sendScreen:@"View payment"];
	[self removeCancellingFromCell];

    UIViewController *resultController;
    if ([payment isSubmitted])
	{
        if([payment.sourceCurrency.code caseInsensitiveCompare:@"USD"] == NSOrderedSame)
        {
            //Temporarily don't display pay in info for USD as no API available
            //Added Viewcontrolle rin code to avoid adding extraf iles for this trivial view
            //TODO: remove once USD API is ready
            
            CGRect labelFrame = self.view.frame;
            labelFrame.origin.x +=20;
            labelFrame.size.width -= 40;
            UILabel * infoLabel = [[UILabel alloc] initWithFrame:labelFrame];
            infoLabel.font = [UIFont systemFontOfSize:16];
            infoLabel.textColor = [UIColor colorWithWhite:9.0/15.0 alpha:1.0f];
            infoLabel.numberOfLines = 0;
            infoLabel.textAlignment = NSTextAlignmentCenter;
            infoLabel.text = NSLocalizedString(@"usd.not.supported", nil);
            
            UIView *contentView = [[UIView alloc] initWithFrame:self.view.frame];
            contentView.backgroundColor = [UIColor whiteColor];
            [contentView addSubview:infoLabel];
            
            UIViewController *placeholderController = [[UIViewController alloc] init];
            placeholderController.view = contentView;
            placeholderController.title = NSLocalizedString(@"usd.coming.soon",nil);
            resultController = placeholderController;
            
        }

		else if(IPAD)
		{
			TransferPayIPadViewController *controller = [[TransferPayIPadViewController alloc] init];
			controller.payment = payment;
            controller.objectModel = self.objectModel;
			controller.delegate = self;
			resultController = controller;
		}
		else
		{
			UploadMoneyViewController *controller = [[UploadMoneyViewController alloc] init];
			[controller setPayment:payment];
			[controller setObjectModel:self.objectModel];
			[controller setHideBottomButton:YES];
			[controller setShowContactSupportCell:YES];
			resultController = controller;
		}
    }
    else if (payment.status == PaymentStatusUserHasPaid)
    {
        TransferWaitingViewController *controller = [[TransferWaitingViewController alloc] init];
        controller.payment = payment;
        controller.objectModel = self.objectModel;
        resultController = controller;
    }
    else
	{
        TransferDetailsViewController *controller = [[TransferDetailsViewController alloc] init];
        controller.payment = payment;
        resultController = controller;
    }

    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    [self presentDetail:resultController];
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section {
	if (section == 0 && self.showIdentificationView) {
		return CGRectGetHeight(self.identificationView.frame);
	}

	return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
	if (section == 0 && self.showIdentificationView) {
		return self.identificationView;
	}

	return nil;
}

- (void)refreshPaymentsList {
    if (self.executedOperation) {
        return;
    }

    [self.tableView setTableFooterView:nil];

    [self refreshPaymentsWithOffset:0 hud:nil];
}

- (void)refreshPaymentsWithOffset:(NSInteger)offset hud:(TabBarActivityIndicatorView *)hud {
    PaymentsOperation *operation = [PaymentsOperation operationWithOffset:offset];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setCompletion:^(NSInteger totalCount, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];
            [self.refreshView refreshComplete];

            [self setExecutedOperation:nil];
            if (totalCount > [self.payments.fetchedObjects count]) {
                [self.tableView setTableFooterView:self.loadingFooterView];
            } else {
                [self.tableView setTableFooterView:nil];
            }
            [self.tableView reloadData];
        });
    }];

    [operation execute];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self checkReloadNeeded];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    if (!decelerate) {
        [self checkReloadNeeded];
    }
    [self.refreshView scrollViewDidEndDragging];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshView scrollViewDidScroll];
}


- (void)checkReloadNeeded {
    if (!self.tableView.tableFooterView) {
        return;
    }

    if (self.executedOperation) {
        return;
    }

    BOOL footerVisible = CGRectIntersectsRect(self.tableView.bounds, self.loadingFooterView.frame);
    if (!footerVisible) {
        return;
    }

    [self refreshPaymentsWithOffset:[self.payments.fetchedObjects count] hud:nil];
}

- (void)controllerWillChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView beginUpdates];
}

- (void)controller:(NSFetchedResultsController *)controller didChangeObject:(id)anObject
       atIndexPath:(NSIndexPath *)indexPath forChangeType:(NSFetchedResultsChangeType)type
      newIndexPath:(NSIndexPath *)newIndexPath {
    UITableView *tableView = self.tableView;

    switch (type) {

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

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.tableView endUpdates];
}

- (void)checkPersonalVerificationNeeded {
	MCLog(@"checkPersonalVerificationNeeded", nil);
	if (self.checkOperation) {
		MCLog(@"Check in progress");
		return;
	}

	CheckPersonalProfileVerificationOperation *operation = [CheckPersonalProfileVerificationOperation operation];
	[self setCheckOperation:operation];
    __weak typeof(self) weakSelf = self;
	[operation setResultHandler:^(IdentificationRequired identificationRequired) {
		[weakSelf setCheckOperation:nil];

		[weakSelf setIdentificationRequired:identificationRequired];

		BOOL somethingNeeded = identificationRequired != IdentificationNoneRequired;

		if (somethingNeeded != weakSelf.showIdentificationView) {
			[weakSelf setShowIdentificationView:somethingNeeded];
			[weakSelf.tableView reloadData];
		}
	}];
	[operation execute];
}

- (void)pushIdentificationScreen {
	MCLog(@"pushIdentificationScreen");
	PersonalProfileIdentificationViewController *controller = [[PersonalProfileIdentificationViewController alloc] init];
    controller.objectModel = self.objectModel;
	[controller setHideSkipOption:YES];
	[controller setIdentificationRequired:self.identificationRequired];
	[controller setProposedFooterButtonTitle:NSLocalizedString(@"transactions.identification.done.button.title", nil)];
    [controller setCompletionMessage:NSLocalizedString(@"transactions.identification.uploading.message", nil)];
    __weak typeof(self) weakSelf = self;
    [controller setCompletionHandler:^(BOOL skipIdentification, NSString *paymentPurpose, VerificationStepSuccessBlock successBlock, PaymentErrorBlock errorBlock) {
        [weakSelf uploadPaymentPurpose:paymentPurpose errorHandler:errorBlock completionHandler:^{
            [weakSelf.navigationController popViewControllerAnimated:YES];
            if(successBlock)
            {
                successBlock();
            }
        }];
    }];
	[self.navigationController pushViewController:controller animated:YES];
}

- (void)uploadPaymentPurpose:(NSString *)purpose errorHandler:(PaymentErrorBlock)errorBlock completionHandler:(TRWActionBlock)completion {
    if ((self.identificationRequired & IdentificationPaymentPurposeRequired) != IdentificationPaymentPurposeRequired) {
        [[GoogleAnalytics sharedInstance] sendAppEvent:@"Verification" withLabel:@"sent"];
        [self uploadIdImageWithErrorHandler:errorBlock completionHandler:completion];
        return;
    }

    PaymentPurposeOperation *operation = [PaymentPurposeOperation operationWithPurpose:purpose forProfile:@"personal"];
    [self setExecutedUploadOperation:operation];
    [operation setObjectModel:self.objectModel];
    __weak typeof(self) weakSelf = self;
    [operation setResultHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                errorBlock(error);
                return;
            }

            [[GoogleAnalytics sharedInstance] sendAppEvent:@"Verification" withLabel:@"sent"];
            MCLog(@"uploadPaymentPurpose done");
            [weakSelf uploadIdImageWithErrorHandler:errorBlock completionHandler:completion];
        });
    }];

    [operation execute];
}

- (void)uploadIdImageWithErrorHandler:(PaymentErrorBlock)errorBlock completionHandler:(TRWActionBlock)completion {
    MCLog(@"uploadIdImageWithErrorHandler");
    if ((self.identificationRequired & IdentificationIdRequired) != IdentificationIdRequired) {
        [self uploadAddressImageWithErrorHandler:errorBlock completionHandler:completion];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self uploadImageFromPath:[PendingPayment idPhotoPath] withId:@"id" completion:^(NSError *error) {
        if (error) {
            errorBlock(error);
        } else {
            [weakSelf uploadAddressImageWithErrorHandler:errorBlock completionHandler:completion];
        }
    }];
}

- (void)uploadAddressImageWithErrorHandler:(PaymentErrorBlock)errorBlock completionHandler:(TRWActionBlock)completion {
    MCLog(@"uploadAddressImageWithErrorHandler");
    if ((self.identificationRequired & IdentificationAddressRequired) != IdentificationAddressRequired) {
        completion();
    } else {
        [self uploadImageFromPath:[PendingPayment addressPhotoPath] withId:@"address" completion:^(NSError *error) {
            if (error) {
                errorBlock(error);
            } else {
                completion();
            }
        }];
    }
}

- (void)uploadImageFromPath:(NSString *)path withId:(NSString *)verified completion:(FileUploadBlock)completion {
    UploadVerificationFileOperation *operation = [UploadVerificationFileOperation verifyOperationFor:verified profile:@"personal" filePath:path];
    [self setExecutedUploadOperation:operation];

    [operation setCompletionHandler:completion];

    [operation execute];
}
#pragma mark - TransferPayIPadViewController delegate
- (void)cancelPaymentWithConfirmation:(Payment *)payment
{
	[CancelHelper cancelPayment:payment host:self objectModel:self.objectModel cancelBlock:^(NSError *error) {
        if(error)
        {
            NSLog(@"ERROR!");
        }
        else{
            NSLog(@"SUCCESS!!");
        }
    } dontCancelBlock:nil];
}

#pragma mark - SwipeToCancel
- (PaymentCell *)getPaymentCell:(NSIndexPath *)index
{
	PaymentCell* cell = (PaymentCell *)[self.tableView cellForRowAtIndexPath:index];
	return cell;
}

- (void)removeCancellingFromCell
{
	if (self.cancellingCellIndex != nil)
	{
		[[self getPaymentCell:self.cancellingCellIndex] setIsCancelVisible:NO animated:YES];
		self.cancellingCellIndex = nil;
	}
}

- (void)confirmPaymentCancel:(Payment *)payment cellIndex:(NSIndexPath *)cellIndex
{
	[CancelHelper cancelPayment:payment host:self objectModel:self.objectModel cancelBlock:^(NSError *error) {
        if(error)
        {
            NSLog(@"ERROR!");
        }
        else{
            [self removeCancellingFromCell];
            NSLog(@"SUCCESS!!");
        }
        [self removeCancellingFromCell];
    } dontCancelBlock:^{
        [self removeCancellingFromCell];
    }];
}

#pragma mark - PullToRefresh

-(void)refreshRequested:(PullToRefreshView *)refreshView
{
    [self refreshPaymentsList];
}

@end
