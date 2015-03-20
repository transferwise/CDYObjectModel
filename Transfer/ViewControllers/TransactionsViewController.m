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
#import "Recipient.h"
#import "RecipientType.h"
#import "UploadMoneyViewController.h"
#import "GoogleAnalytics.h"
#import "UIView+Loading.h"
#import "CheckPersonalProfileVerificationOperation.h"
#import "PersonalProfileIdentificationViewController.h"
#import "PendingPayment.h"
#import "PaymentPurposeOperation.h"
#import "MOMStyle.h"

#import "PullToRefreshView.h"
#import "TransferDetailsViewController.h"
#import "TransferWaitingViewController.h"
#import "TRWAlertView.h"
#import "TRWProgressHUD.h"
#import "UIGestureRecognizer+Cancel.h"
#import "CancelHelper.h"
#import "Currency.h"
#import "NavigationBarCustomiser.h"
#import "PaymentMethodSelectorViewController.h"
#import "SetSSNOperation.h"
#import "SendButtonFlashHelper.h"
#import "RecipientTypesOperation.h"
#import "CustomInfoViewController+NoPayInMethods.h"
#import "NewPaymentHelper.h"
#import "NewPaymentViewController.h"
#import "LoggedInPaymentFlow.h"
#import "ConnectionAwareViewController.h"


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


@end

@implementation TransactionsViewController

- (id)init
{
    self = [super initWithNibName:@"TransactionsViewController" bundle:nil];
    if (self)
	{
        [self setTitle:NSLocalizedString(@"transactions.controller.title", nil)];
		
		//Observe notification to remove selected payment for iPad
		[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(moveToPaymentsList) name:TRWMoveToPaymentsListNotification object:nil];
    }
    return self;
}

- (void)dealloc
{
	[[NSNotificationCenter defaultCenter] removeObserver:self];
}

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

    if (!self.payments)
    {
        self.payments = [[NSArray alloc] initWithArray:[self.objectModel allPayments]];
    }
    
    [self.tableView reloadData];
    
    if(self.refreshOnAppear)
    {
        [self.tableView setContentOffset:CGPointMake(0,- self.tableView.contentInset.top)];
        self.isViewAppearing = YES;
        [self refreshPaymentsList];
        self.refreshOnAppear = NO;
    }
    
    [self.tabBarController.navigationItem setRightBarButtonItem:nil];
    [self.navigationController setNavigationBarHidden:IPAD animated:YES];

    [self configureForVerificationNeeded:self.showIdentificationView];
	[self checkPersonalVerificationNeeded];
	[self presentDetail:nil];
    self.noTransfersMessage.hidden = YES;
    
    self.paymentFlow = nil;
    self.paymentHelper = nil;
    
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	[[GoogleAnalytics sharedInstance] sendScreen:@"View transfers"];
}

-(void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
    self.isViewAppearing = NO;
    if(!IPAD)
    {
        [NavigationBarCustomiser applyDefault:self.navigationController.navigationBar];
    }
    [SendButtonFlashHelper setSendFlash:NO];
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [self.refreshView refreshComplete];
}

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
	
    [cell configureWithPayment:payment willShowActionButtonBlock:^{
        //this will be called each time a touch starts
        //including the touch that hides the button
        //so not cancelling if the same cell is receiving touches
        if(self.cancellingCellIndex && self.cancellingCellIndex.row != indexPath.row)
        {
            [self removeCancellingFromCell];
        }
    } didShowActionButtonBlock:^{
        self.cancellingCellIndex = indexPath;
    } didHideActionButtonBlock:^{
        self.cancellingCellIndex = nil;
    } actionTappedBlock:^{
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

	[[GoogleAnalytics sharedInstance] sendScreen:@"View payment"];
	[self removeCancellingFromCell];

	[self showPayment:payment];
}

- (void)moveToPaymentsList
{
	//if we are redisplaying transfers list on IPAD reload the selected transfer because it might have changed
	if (IPAD)
	{
		[self presentDetail:nil];
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
    [SendButtonFlashHelper setSendFlash:NO];
    
    PaymentsOperation *operation = [PaymentsOperation operationWithOffset:offset];
    [self setExecutedOperation:operation];
    [operation setObjectModel:self.objectModel];

    [operation setCompletion:^(NSInteger totalCount, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            [hud hide];
			NSInteger currentCount = self.payments.count;
			self.payments = [self.objectModel allPayments];
			NSInteger delta = self.payments.count - currentCount;

            [self setExecutedOperation:nil];
			
			[self.tableView reloadData];
            
            if(!error && totalCount == 0)
            {
                self.noTransfersMessage.hidden = NO;
                self.noTransfersMessage.alpha = 0.0f;
                [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
                    self.noTransfersMessage.alpha = 1.0f;
                } completion:nil];
                if(self.isViewLoaded && self.view.window)
                {
                    [SendButtonFlashHelper setSendFlash:YES];
                }
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
			
			if(self.isViewAppearing)
			{
				self.isViewAppearing = NO;
				
				if (IPAD && self.payments.count > 0)
				{
					NSIndexPath *firstRow = [NSIndexPath indexPathForRow:0
															   inSection:0];
					[self tableView:self.tableView didSelectRowAtIndexPath:firstRow];
					[self.tableView selectRowAtIndexPath:firstRow
												animated:NO
										  scrollPosition:UITableViewScrollPositionMiddle];
				}
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
            NSUInteger numberOfPayInMethods = [[payment enabledPayInMethods] count];
            if(numberOfPayInMethods < 1)
            {
                CustomInfoViewController* errorScreen = [CustomInfoViewController failScreenNoPayInMethodsForCurrency:payment.sourceCurrency];
                [errorScreen presentOnViewController:self.navigationController.parentViewController];
                return;
            }
			else if(numberOfPayInMethods > 2 || ([@"usd" caseInsensitiveCompare:[payment.sourceCurrency.code lowercaseString]] == NSOrderedSame && numberOfPayInMethods > 1))
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

- (void)checkPersonalVerificationNeeded
{
	MCLog(@"checkPersonalVerificationNeeded", nil);
	if (self.checkOperation)
	{
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

		if (somethingNeeded != weakSelf.showIdentificationView)
		{
            [self configureForVerificationNeeded:somethingNeeded];
			[weakSelf setShowIdentificationView:somethingNeeded];
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

- (void)uploadPaymentPurpose:(NSString *)purpose
					  andSSN:(NSString*)ssn
				errorHandler:(TRWErrorBlock)errorBlock
		   completionHandler:(TRWActionBlock)completion
{
    if ((self.identificationRequired & IdentificationPaymentPurposeRequired) != IdentificationPaymentPurposeRequired) {
        [[GoogleAnalytics sharedInstance] sendAppEvent:@"Verification" withLabel:@"sent"];
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

            [[GoogleAnalytics sharedInstance] sendAppEvent:@"Verification" withLabel:@"sent"];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRWMoveToPaymentsListNotification" object:nil];
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
            [[NSNotificationCenter defaultCenter] postNotificationName:@"TRWMoveToPaymentsListNotification" object:nil];
        }
        [self removeCancellingFromCell];
    } dontCancelBlock:^{
        [self removeCancellingFromCell];
    }];
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

#pragma mark - PullToRefresh

-(void)refreshRequested:(PullToRefreshView *)refreshView
{
    [self refreshPaymentsList];
}

#pragma mark - Clear Data
- (void)clearData
{
	self.payments = nil;
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
        
        [[GoogleAnalytics sharedInstance] sendAppEvent:@"Currency1Selected" withLabel:payment.sourceCurrency.code];
        [[GoogleAnalytics sharedInstance] sendAppEvent:@"Currency2Selected" withLabel:payment.targetCurrency.code];
        
        
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

@end
