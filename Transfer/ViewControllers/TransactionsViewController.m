//
//  TransactionsViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//


#import "BankTransferViewController.h"
#import "CancelHelper.h"
#import "CheckPersonalProfileVerificationOperation.h"
#import "ConfirmPaymentViewController.h"
#import "ConnectionAwareViewController.h"
#import "Currency.h"
#import "CustomInfoViewController+NoPayInMethods.h"
#import "GoogleAnalytics.h"
#import "LoggedInPaymentFlow.h"
#import "MOMStyle.h"
#import "NavigationBarCustomiser.h"
#import "NewPaymentHelper.h"
#import "NewPaymentViewController.h"
#import "ObjectModel+Payments.h"
#import "ObjectModel.h"
#import "Payment.h"
#import "PaymentCell.h"
#import "PaymentMethodDisplayHelper.h"
#import "PaymentMethodSelectorViewController.h"
#import "PaymentPurposeOperation.h"
#import "PaymentsOperation.h"
#import "PendingPayment.h"
#import "PersonalProfileIdentificationViewController.h"
#import "PullPaymentDetailsOperation.h"
#import "PullToRefreshView.h"
#import "Recipient.h"
#import "RecipientType.h"
#import "RecipientTypesOperation.h"
#import "SectionButtonFlashHelper.h"
#import "SetSSNOperation.h"
#import "TRWAlertView.h"
#import "TRWProgressHUD.h"
#import "TabBarActivityIndicatorView.h"
#import "TransactionsViewController.h"
#import "TransferDetailsViewController.h"
#import "TransferWaitingViewController.h"
#import "UIColor+Theme.h"
#import "UIGestureRecognizer+Cancel.h"
#import "UIView+Loading.h"
#import "UploadMoneyViewController.h"
#import "UploadVerificationFileOperation.h"

static const NSInteger refreshInterval = 300;

NSString *const kPaymentCellIdentifier = @"kPaymentCellIdentifier";

@interface TransactionsViewController () <UIScrollViewDelegate, NSFetchedResultsControllerDelegate, UITableViewDelegate, UITableViewDataSource, PullToRefreshViewDelegate>

@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, strong) IBOutlet UIView *loadingFooterView;
@property (nonatomic, strong) NSArray *payments;
@property (nonatomic, assign) BOOL showIdentificationView;
@property (nonatomic, strong) CheckPersonalProfileVerificationOperation *checkOperation;
@property (nonatomic, assign) IdentificationRequired identificationRequired;
@property (nonatomic, strong) TransferwiseOperation *executedUploadOperation;
@property (nonatomic, weak) PullToRefreshView* refreshView;
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (nonatomic) CGPoint touchStart;
@property (weak, nonatomic) IBOutlet UILabel *noTransfersMessage;

//iPad
@property (weak, nonatomic) IBOutlet UIView *verificationBar;
@property (weak, nonatomic) IBOutlet UILabel *verificationBartitle;
@property (weak, nonatomic) IBOutlet UIButton *viewButton;
@property (nonatomic) BOOL isViewAppearing;

@property (nonatomic, strong) NewPaymentHelper *paymentHelper;
@property (nonatomic, strong) PaymentFlow *paymentFlow;
@property (nonatomic, strong) NSDate* refreshTimestamp;

@property (nonatomic, weak) Payment *lastSelectedPayment;

//set this to refresh selected payment details on iPad
@property (nonatomic) BOOL refreshPaymentDetail;
//if this is set, then the first payment after data refresh will be selected
@property (nonatomic) BOOL dontSelectPaymentOnce;

@end

@implementation TransactionsViewController

#pragma mark - Init

- (id)init
{
    self = [super initWithNibName:@"TransactionsViewController" bundle:nil];
    if (self)
	{
        [self setTitle:NSLocalizedString(@"transactions.controller.title", nil)];
		
		//Observe notification to remove selected payment for iPad
        [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToPaymentsList:) name:TRWMoveToPaymentsListNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

#pragma mark - View life-cycle

- (void)viewDidLoad
{
    [super viewDidLoad];

	self.loadingFooterView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [self.tableView registerNib:[UINib nibWithNibName:@"PaymentCell" bundle:nil] forCellReuseIdentifier:kPaymentCellIdentifier];
    PullToRefreshView* refreshView = [PullToRefreshView addInstanceToScrollView:self.tableView];
    refreshView.delegate = self;
    self.refreshView = refreshView;

    UIView *footer = [[UIView alloc] initWithFrame:CGRectZero];
    [self.tableView setTableFooterView:footer];
    
    self.verificationBar.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"verificationBackground"]];
    self.verificationBartitle.text = NSLocalizedString(@"validation.documents.needed",nil);
    [self.viewButton setTitle:NSLocalizedString(@"validation.view",nil) forState:UIControlStateNormal];
    
    self.titleLabel.text = self.title;
    
    self.noTransfersMessage.text = NSLocalizedString(@"empty.transfers",nil);
	self.tableView.accessibilityLabel = @"Transfers list";
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
	
	self.noTransfersMessage.hidden = YES;

    if (!self.payments)
    {
        self.payments = [[NSArray alloc] initWithArray:[self.objectModel allPayments]];
    }
    
    [self.tableView reloadData];
    
    if(self.deeplinkPaymentID)
    {
        [self presentDeeplinkPayment];
    }
    else if(self.refreshOnAppear || ABS([self.refreshTimestamp timeIntervalSinceNow]) > refreshInterval)
    {
        [self.tableView setContentOffset:CGPointMake(0,- self.tableView.contentInset.top)];
        self.isViewAppearing = YES;
		[self refreshPaymentsList];
        self.refreshOnAppear = NO;
    }
	else if([self.payments count] < 1)
	{
		[self showNoTransfersMessageAndFlashButton];
	}
    else
    {
        [self checkIfInviteHighlightingIsNeeded];
    }
		
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
    [self.navigationController setNavigationBarHidden:IPAD animated:YES];

    [self configureForVerificationNeeded:self.showIdentificationView];
	[self checkPersonalVerificationNeeded];
	
	[self presentDetail:nil];
    
    self.paymentFlow = nil;
    self.paymentHelper = nil;
    
    //If we are arriving from tranfer creation process' end then don't bother selecting anything
    //after refresh the first payment will be selected.
    if (!self.dontSelectPaymentOnce)
    {
        [self selectRowContainingPayment:self.lastSelectedPayment];
    }
    else
    {
        self.dontSelectPaymentOnce = NO;
    }
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[GoogleAnalytics sharedInstance] sendScreen:GAViewTransfers];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isViewAppearing = NO;
    if(!IPAD)
    {
        [NavigationBarCustomiser applyDefault:self.navigationController.navigationBar];
    }
    [SectionButtonFlashHelper setSendFlash:NO];
    [SectionButtonFlashHelper setInviteFlash:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.refreshView refreshComplete];
}

#pragma mark - Inteface orientation

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    for(PaymentCell* cell in [self.tableView visibleCells])
    {
        [cell setIsActionButtonVisible:NO animated:NO];
    }
}

#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.payments.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PaymentCell *cell = [tableView dequeueReusableCellWithIdentifier:kPaymentCellIdentifier];
    Payment *payment = [self.payments objectAtIndex:indexPath.row];
	
	[cell configureWithPayment:payment
	 willShowActionButtonBlock:^{
		 //this will be called each time a touch starts
		 //including the touch that hides the button
		 //so not cancelling if the same cell is receiving touches
		 if(self.cancellingCellIndex && self.cancellingCellIndex.row != indexPath.row)
		 {
			 [self removeCancellingFromCell];
		 }
	 }
	  didShowActionButtonBlock:^{
		  self.cancellingCellIndex = indexPath;
	  }
	  didHideActionButtonBlock:^{
		  self.cancellingCellIndex = nil;
	  }
			 actionTappedBlock:^{
				 [self actionTappedOnPayment:payment cellIndex:indexPath];
    }];

	//set cancelling visible when scrolling
	[self setCancellingVisibleForScrolling:cell indexPath:indexPath];
    
    return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    Payment *payment = [self.payments objectAtIndex:indexPath.row];
    if ([payment.recipient.type hideFromCreationValue])
	{
        return;
    }

	[[GoogleAnalytics sharedInstance] sendScreen:GAViewPayment];
	[self removeCancellingFromCell];

    self.lastSelectedPayment = payment;
    [self showPayment:payment];

}

#pragma mark - Payment List actions
- (void)moveToPaymentsList:(NSNotification*)note
{
    
    MCLog(@"PAYMENT LIST AHOY!");
	//cancel latest selection, we arrive here, because a new payment has been created.
	self.lastSelectedPayment = nil;
	self.refreshPaymentDetail = YES;
	self.dontSelectPaymentOnce = YES;
    
    self.payments = [self.objectModel allPayments];
    [self.tableView reloadData];
    
    NSNumber *paymentId = note.userInfo[@"paymentId"];
    if(IPAD && paymentId)
    {
        NSArray* filtered = [self.payments filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"remoteId == %@", paymentId]];
        if([filtered count] >0)
        {
            [self selectRowContainingPayment:[filtered lastObject]];
        }
    }
}

- (void)refreshPaymentsList
{
	if (self.executedOperation)
	{
        return;
    }
    
    [self.tableView setTableFooterView:nil];
    
    RecipientTypesOperation* operation = [RecipientTypesOperation operation];
    self.executedOperation = operation;
    
    __weak typeof(self) weakSelf = self;
    operation.resultHandler = ^(NSError *error, NSArray* listOfRecipientTypeCodes){
        weakSelf.executedOperation = nil;
        [weakSelf refreshPaymentsWithOffset:0 hud:nil];
    };
    operation.objectModel = self.objectModel;
    [operation execute];
}

- (void)refreshPaymentsWithOffset:(NSInteger)offset hud:(TabBarActivityIndicatorView *)hud
{
    self.noTransfersMessage.hidden = YES;
    [SectionButtonFlashHelper setSendFlash:NO];
    
    PaymentsOperation *operation = [PaymentsOperation operationWithOffset:offset];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setCompletion:^(NSInteger totalCount, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];
            
            if(!error && offset == 0)
            {
                self.refreshTimestamp = [NSDate date];
            }
            
			NSInteger currentCount = self.payments.count;
			self.payments = [self.objectModel allPayments];
			NSInteger delta = self.payments.count - currentCount;

            [self setExecutedOperation:nil];
			
			[self.tableView reloadData];
            
            if(!error && totalCount == 0)
            {
				[self showNoTransfersMessageAndFlashButton];
            }
            else
            {
                [self checkIfInviteHighlightingIsNeeded];
            }
			
            BOOL footerUpdateScheduled = NO;
			//data may already be locally stored, this will be overwritten
			if (delta > 0)
			{
                footerUpdateScheduled = YES;
                [CATransaction begin];
                __weak typeof(self) weakSelf = self;
                [CATransaction setCompletionBlock:^{
                    if (totalCount > self.payments.count)
                    {
                        [weakSelf.tableView setTableFooterView:self.loadingFooterView];
                    }
                    else
                    {
                        [weakSelf.tableView setTableFooterView:nil];
                    }

                }];
                [self.tableView reloadRowsAtIndexPaths:[TransactionsViewController generateIndexPathsFrom:currentCount
                                                                                                withCount:delta]
                                      withRowAnimation:UITableViewRowAnimationFade];
                [CATransaction commit];
            }
			
			if(self.isViewAppearing || self.refreshPaymentDetail)
			{
				self.isViewAppearing = self.refreshPaymentDetail = NO;
				
				[self selectRowContainingPayment:self.lastSelectedPayment];
			}
            
            if(!footerUpdateScheduled)
            {
                if (totalCount > self.payments.count)
                {
                    [self.tableView setTableFooterView:self.loadingFooterView];
                }
                else
                {
                    [self.tableView setTableFooterView:nil];
                }
            }
            
            [self.refreshView refreshComplete];
            
        });
    }];

    [operation execute];
}

- (void)showNoTransfersMessageAndFlashButton
{
	self.noTransfersMessage.hidden = NO;
	self.noTransfersMessage.alpha = 0.0f;
	__weak typeof(self) weakSelf = self;
	[UIView animateWithDuration:0.2f
						  delay:0.0f
						options:UIViewAnimationOptionCurveEaseOut
					 animations:^{
						 self.noTransfersMessage.alpha = 1.0f;
					 }
					 completion:^(BOOL finished) {
						 if(weakSelf.isViewLoaded && weakSelf.view.window)
						 {
							 [SectionButtonFlashHelper setSendFlash:YES];
						 }
					 }];
}

-(void)checkIfInviteHighlightingIsNeeded
{
    NSCountedSet* countedStatuses = [NSCountedSet setWithArray:[self.payments valueForKey:@"status"]];
    
    NSUInteger numberOfCompleted = [countedStatuses countForObject:@(PaymentStatusTransferred)];
    if (numberOfCompleted == 1){
        [SectionButtonFlashHelper flashInviteSectionIfNeeded];
    }


}

#pragma mark - Select row
- (void)selectRowContainingPayment:(Payment *)payment
{
	//don't select anything when not on iPad
	if (!IPAD || self.payments.count < 1)
	{
		return;
	}
	
	NSIndexPath *paymentIndexPath;
	
	//if no payment to select select the first payment
	//if payment is not in the list of avialble payment, select the first payment
	if(!payment || ![self.payments containsObject:payment])
	{
		paymentIndexPath = [NSIndexPath indexPathForRow:0
											  inSection:0];
	}
	//get index path for the payment. payments are displayed lineraly
	else
	{
		paymentIndexPath = [NSIndexPath indexPathForRow:[self.payments indexOfObject:payment]
											  inSection:0];
	}

	NSAssert(paymentIndexPath, @"paymentIndexPath can not be nil");
	
	[self tableView:self.tableView didSelectRowAtIndexPath:paymentIndexPath];
	[self.tableView selectRowAtIndexPath:paymentIndexPath
								animated:NO
						  scrollPosition:UITableViewScrollPositionMiddle];
    self.lastSelectedPayment = payment;
}

#pragma mark - ScrollView delegate
- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self checkReloadNeeded];
    [self.refreshView scrollViewDidEndDecelerating:scrollView];
}

- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if (!decelerate)
	{
        [self checkReloadNeeded];
    }
    [self.refreshView scrollViewDidEndDragging:scrollView willDecelerate:decelerate];
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.refreshView scrollViewDidScroll:scrollView];
}

#pragma mark - Helpers
- (void)checkReloadNeeded
{
    if (!self.tableView.tableFooterView)
	{
        return;
    }

    if (self.executedOperation)
	{
        return;
    }

    BOOL footerVisible = CGRectIntersectsRect(self.tableView.bounds, self.loadingFooterView.frame);
    if (!footerVisible)
	{
        return;
    }

    [self refreshPaymentsWithOffset:self.payments.count hud:nil];
}

- (void)showPayment:(Payment *)payment
{
	UIViewController *resultController;
	if ([payment isSubmitted])
	{
		if(IPAD)
		{
			TransferPayIPadViewController *controller = [[TransferPayIPadViewController alloc] init];
			controller.payment = payment;
			controller.objectModel = self.objectModel;
			controller.delegate = self;
			resultController = controller;
		}
		else
		{
            if([PaymentMethodDisplayHelper displayErrorForPayment: payment])
            {
                CustomInfoViewController* errorScreen = [CustomInfoViewController failScreenNoPayInMethodsForCurrency:payment.sourceCurrency];
                [errorScreen presentOnViewController:self.navigationController.parentViewController];
                return;
            }
			else if([PaymentMethodDisplayHelper displayMethodForPayment: payment] == kDisplayAsList)
			{
				PaymentMethodSelectorViewController* selector = [[PaymentMethodSelectorViewController alloc] init];
				selector.objectModel = self.objectModel;
				selector.payment = payment;
				resultController = selector;
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
        controller.objectModel = self.objectModel;
		resultController = controller;
	}
	
	[self presentDetail:resultController];
}

#pragma mark - Verification
- (void)checkPersonalVerificationNeeded
{
	MCLog(@"checkPersonalVerificationNeeded", nil);
	if (self.checkOperation)
	{
		MCLog(@"Check in progress");
		return;
	}

    TRWProgressHUD *hud = nil;
    if(self.deeplinkDisplayVerification)
    {
        hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
        [hud setMessage:NSLocalizedString(@"deeplink.verification.message", nil)];

    }
    
	CheckPersonalProfileVerificationOperation *operation = [CheckPersonalProfileVerificationOperation operation];
	[self setCheckOperation:operation];
    __weak typeof(self) weakSelf = self;
	[operation setResultHandler:^(IdentificationRequired identificationRequired) {
        [hud hide];
		[weakSelf setCheckOperation:nil];

        [weakSelf setIdentificationRequired:identificationRequired];

        BOOL somethingNeeded = identificationRequired != IdentificationNoneRequired;

		if (somethingNeeded != weakSelf.showIdentificationView)
		{
            [self configureForVerificationNeeded:somethingNeeded];
			[weakSelf setShowIdentificationView:somethingNeeded];
		}
        
        if(self.deeplinkDisplayVerification)
        {
            self.deeplinkDisplayVerification = NO;
            if(somethingNeeded)
            {
                [self pushIdentificationScreen];
            }
            else
            {
                TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"deeplink.no.verification.message", nil) message:nil];
                [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                [alertView show];
                return;
            }
        }
	}];
	[operation execute];
}

- (IBAction)pushIdentificationScreen
{
	MCLog(@"pushIdentificationScreen");
	PersonalProfileIdentificationViewController *controller = [[PersonalProfileIdentificationViewController alloc] init];
    controller.objectModel = self.objectModel;
	[controller setHideSkipOption:YES];
	[controller setIdentificationRequired:self.identificationRequired];
	[controller setProposedFooterButtonTitle:NSLocalizedString(@"transactions.identification.done.button.title", nil)];
    [controller setCompletionMessage:NSLocalizedString(@"transactions.identification.uploading.message", nil)];
    __weak typeof(self) weakSelf = self;
    [controller setCompletionHandler:^(BOOL skipIdentification, NSString *paymentPurpose, NSString *socialSecurityNumber, TRWActionBlock successBlock, TRWErrorBlock errorBlock) {
		if (!skipIdentification) {
            [weakSelf uploadPaymentPurpose:paymentPurpose andSSN:socialSecurityNumber errorHandler:errorBlock completionHandler:^{
                [weakSelf.navigationController popViewControllerAnimated:YES];
				if(successBlock)
				{
					successBlock();
				}
			}];
		}
		else
		{
            if(successBlock)
            {
                successBlock();
            }
			[weakSelf.navigationController popViewControllerAnimated:YES];
		}
    }];
	[self.navigationController pushViewController:controller animated:YES];
}

-(void)configureForVerificationNeeded:(BOOL)verificationNeeded
{
	if(IPAD)
	{
		self.verificationBar.hidden = !verificationNeeded;
	}
	else
	{
		NSString* title = verificationNeeded?NSLocalizedString(@"validation.documents.needed",nil) : NSLocalizedString(@"transactions.controller.title", nil);
		if(verificationNeeded)
		{
			[NavigationBarCustomiser applyVerificationNeededStyle:self.navigationController.navigationBar];
		}
		else
		{
			[NavigationBarCustomiser applyDefault:self.navigationController.navigationBar];
		}
		self.title = title;
		((UIViewController*)self.navigationController.viewControllers[0]).navigationItem.title = self.title;
		UIBarButtonItem* button =verificationNeeded? [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"validation.view",nil) style:UIBarButtonItemStylePlain target:self action:@selector(pushIdentificationScreen)]:nil;
		[button setTitleTextAttributes: self.navigationController.navigationBar.titleTextAttributes forState:UIControlStateNormal];
		((UIViewController*)self.navigationController.viewControllers[0]).navigationItem.rightBarButtonItem = button;
	}
}

- (void)uploadPaymentPurpose:(NSString *)purpose
					  andSSN:(NSString*)ssn
				errorHandler:(TRWErrorBlock)errorBlock
		   completionHandler:(TRWActionBlock)completion
{
    if ((self.identificationRequired & IdentificationPaymentPurposeRequired) != IdentificationPaymentPurposeRequired) {
        [self uploadSocialSecurityNumber:ssn errorHandler:errorBlock completionHandler:completion];
        return;
    }

    PaymentPurposeOperation *operation = [PaymentPurposeOperation operationWithPurpose:purpose forProfile:@"personal"];
    [self setExecutedUploadOperation:operation];
    [operation setObjectModel:self.objectModel];
    __weak typeof(self) weakSelf = self;
    [operation setResultHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
			{
                errorBlock(error);
                return;
            }
            MCLog(@"uploadPaymentPurpose done");
            [weakSelf uploadSocialSecurityNumber:ssn errorHandler:errorBlock completionHandler:completion];
        });
    }];

    [operation execute];
}

- (void)uploadSocialSecurityNumber:(NSString *)ssn
					  errorHandler:(TRWErrorBlock)errorBlock
				 completionHandler:(TRWActionBlock)completion
{

    [self uploadIdImageWithErrorHandler:errorBlock completionHandler:completion];

//    SSN verification in app is disabled for now
//    if ((self.identificationRequired & IdentificationSSNRequired) != IdentificationSSNRequired) {
//        [self uploadIdImageWithErrorHandler:errorBlock completionHandler:completion];
//        return;
//    }
//    
//     __weak typeof(self) weakSelf = self;
//    SetSSNOperation *operation = [SetSSNOperation operationWithSsn:ssn resultHandler:^(NSError *error) {
//        dispatch_async(dispatch_get_main_queue(), ^{
//            if (error)
//            {
//                errorBlock(error);
//                return;
//            }
//            MCLog(@"uploadPaymentPurpose done");
//            [weakSelf uploadIdImageWithErrorHandler:errorBlock completionHandler:completion];
//        });
//    }];
//    [self setExecutedUploadOperation:operation];
//    [operation setObjectModel:self.objectModel];
//    [operation execute];
    
}


- (void)uploadIdImageWithErrorHandler:(TRWErrorBlock)errorBlock
					completionHandler:(TRWActionBlock)completion
{
    MCLog(@"uploadIdImageWithErrorHandler");
    if ((self.identificationRequired & IdentificationIdRequired) != IdentificationIdRequired)
	{
        [self uploadAddressImageWithErrorHandler:errorBlock completionHandler:completion];
        return;
    }
    __weak typeof(self) weakSelf = self;
    [self uploadImageFromPath:[PendingPayment idPhotoPath] withId:@"id" completion:^(NSError *error) {
        if (error)
		{
            errorBlock(error);
        }
		else
		{
            [weakSelf uploadAddressImageWithErrorHandler:errorBlock completionHandler:completion];
        }
    }];
}

- (void)uploadAddressImageWithErrorHandler:(TRWErrorBlock)errorBlock
						 completionHandler:(TRWActionBlock)completion
{
    MCLog(@"uploadAddressImageWithErrorHandler");
    if ((self.identificationRequired & IdentificationAddressRequired) != IdentificationAddressRequired)
	{
        completion();
    }
	else
	{
        [self uploadImageFromPath:[PendingPayment addressPhotoPath] withId:@"address" completion:^(NSError *error) {
            if (error)
			{
                errorBlock(error);
            }
			else
			{
                completion();
            }
        }];
    }
}

- (void)uploadImageFromPath:(NSString *)path withId:(NSString *)verified completion:(FileUploadBlock)completion
{
    UploadVerificationFileOperation *operation = [UploadVerificationFileOperation verifyOperationFor:verified profile:@"personal" filePath:path];
    [self setExecutedUploadOperation:operation];

    [operation setCompletionHandler:completion];

    [operation execute];
}

#pragma mark - TransferPayIPadViewController delegate
- (void)cancelPaymentWithConfirmation:(Payment *)payment
{
	[CancelHelper cancelPayment:payment host:self objectModel:self.objectModel cancelBlock:^(NSError *error) {
        if(!error)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
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
		[[self getPaymentCell:self.cancellingCellIndex] setIsActionButtonVisible:NO animated:YES];
		self.cancellingCellIndex = nil;
	}
}

-(void)actionTappedOnPayment:(Payment *)payment cellIndex:(NSIndexPath *)cellIndex
{
    if(payment.status == PaymentStatusTransferred)
    {
        [self repeatPayment:payment];
    }
    else
    {
        [self confirmPaymentCancel:payment cellIndex:cellIndex];
    }
}

- (void)confirmPaymentCancel:(Payment *)payment cellIndex:(NSIndexPath *)cellIndex
{
	[CancelHelper cancelPayment:payment host:self objectModel:self.objectModel cancelBlock:^(NSError *error) {
        if(!error)
        {
            [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil];
        }
        [self removeCancellingFromCell];
    } dontCancelBlock:^{
        [self removeCancellingFromCell];
    }];
}

#pragma mark - PullToRefresh

-(void)refreshRequested:(PullToRefreshView *)refreshView
{
	self.refreshPaymentDetail = YES;
	[self refreshPaymentsList];
}

#pragma mark - Clear Data
- (void)clearData
{
	self.payments = nil;
	self.lastSelectedPayment = nil;
	[self.tableView reloadData];
}

#pragma mark - Repeat payment

-(void)repeatPayment:(Payment*)payment
{
    self.paymentHelper = [[NewPaymentHelper alloc] init];
    __weak typeof(self) weakSelf = self;
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
    [hud setMessage:NSLocalizedString(@"repeat.transfer.creation", nil)];
    [self.paymentHelper repeatTransfer:payment objectModel:self.objectModel successBlock:^(PendingPayment *payment) {
        [hud hide];
        PaymentFlowViewControllerFactory *controllerFactory = [[PaymentFlowViewControllerFactory alloc] initWithObjectModel:weakSelf.objectModel];
        ValidatorFactory *validatorFactory = [[ValidatorFactory alloc] initWithObjectModel:weakSelf.objectModel];
        
        PaymentFlow *paymentFlow = [[LoggedInPaymentFlow alloc] initWithPresentingController:weakSelf.navigationController
                                                            paymentFlowViewControllerFactory:controllerFactory
                                                                            validatorFactory:validatorFactory];
        
        [weakSelf setPaymentFlow:paymentFlow];
        
        [[GoogleAnalytics sharedInstance] sendAppEvent:GACurrency1Selected withLabel:payment.sourceCurrency.code];
        [[GoogleAnalytics sharedInstance] sendAppEvent:GACurrency2Selected withLabel:payment.targetCurrency.code];
        
        
        [paymentFlow setObjectModel:weakSelf.objectModel];
        [paymentFlow presentNextPaymentScreen];
        
        
        
    } failureBlock:^(NSError *error) {
        [hud hide];
        NewPaymentViewController *controller = [[NewPaymentViewController alloc] init];
        controller.suggestedSourceAmount = payment.payIn;
        controller.suggestedTargetAmount = payment.payOut;
        controller.suggestedSourceCurrency = payment.sourceCurrency;
        controller.suggestedTargetCurrency = payment.targetCurrency;
        controller.suggestedTransactionIsFixedTarget = payment.isFixedAmountValue;
        [controller setObjectModel:weakSelf.objectModel];
        ConnectionAwareViewController *wrapper = [ConnectionAwareViewController createWrappedNavigationControllerWithRoot:controller navBarHidden:YES];
        [weakSelf presentViewController:wrapper animated:YES completion:nil];
    }];
}

#pragma mark - deeplinking
-(void)presentDeeplinkPayment
{
    if(self.deeplinkPaymentID)
    {
        TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
        [hud setMessage:NSLocalizedString(@"deeplink.payment.detail.message", nil)];
        PullPaymentDetailsOperation* operation = [PullPaymentDetailsOperation operationWithPaymentId:self.deeplinkPaymentID];
        operation.objectModel = self.objectModel;
        NSNumber *deeplinkPaymentID = self.deeplinkPaymentID;
        operation.resultHandler = ^(NSError* error){
            [hud hide];
            self.executedOperation = nil;
            if(!error)
            {
                self.payments = [self.objectModel allPayments];
                NSArray* loadedIds = [self.payments valueForKey:@"remoteId"];
                if([loadedIds containsObject:deeplinkPaymentID])
                {
					[self.tableView reloadData];
					
                    NSInteger index = [loadedIds indexOfObject:deeplinkPaymentID];
                    [self selectPaymentAtIndex:index];
                }
            }
            else
            {
                TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"upload.money.transaction.refresh.error.title", nil) message:NSLocalizedString(@"deeplink.payment.detail.error", nil)];
                [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                [alertView show];
                return;
            }
        };
        self.deeplinkPaymentID = nil;
        self.executedOperation = operation;
        [operation execute];
    }
}

-(void)selectPaymentAtIndex:(NSUInteger)index
{
    if(index!= NSNotFound && index < [self.payments count])
    {
        [self showPayment:self.payments[index]];
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:index inSection:0] animated:IPAD scrollPosition:UITableViewScrollPositionTop];
    }
}

@end
