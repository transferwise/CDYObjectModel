//
//  AchDetailsViewController.m
//  Transfer
//
//  Created by Juhan Hion on 18.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "AchDetailsViewController.h"
#import "NSString+DeviceSpecificLocalisation.h"
#import "GoogleAnalytics.h"
#import "SupportCoordinator.h"
#import "Payment.h"
#import "FloatingLabelTextField.h"
#import "NavigationBarCustomiser.h"
#import "NSString+Validation.h"
#import "NSMutableString+Issues.h"
#import "TRWAlertView.h"
#import "TRWProgressHUD.h"
#import "ACHCheckView.h"
#import "TransferBackButtonItem.h"

#define TOP_OFFSET	IPAD ? 200 : 130

IB_DESIGNABLE

@interface AchDetailsViewController ()

@property (nonatomic, strong) Payment *payment;
@property (nonatomic, copy) GetLoginFormBlock loginFormBlock;

@property (strong, nonatomic) IBOutlet FloatingLabelTextField *routingNumberTextField;
@property (strong, nonatomic) IBOutlet FloatingLabelTextField *accountNumberTextField;
@property (strong, nonatomic) IBOutlet UIButton *supportButton;
@property (strong, nonatomic) IBOutlet UIButton *connectButton;

@property (nonatomic, weak) IBOutlet UIView* checkViewContainer;
@property (nonatomic, weak) ACHCheckView* checkView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textEntryTopSpace;
@property (nonatomic, assign) CGFloat originalTopSpace;
@property (nonatomic, assign) BOOL keyboardIsShowing;
@property (nonatomic, assign) BOOL willDismiss;

@end

@implementation AchDetailsViewController

- (instancetype)initWithPayment:(Payment *)payment
				 loginFormBlock:(GetLoginFormBlock)loginFormBlock
{
	self = [super init];
	
	if (self)
	{
		self.payment = payment;
		self.loginFormBlock = loginFormBlock;
	}
	
	return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    ACHCheckView* checkView =  [[NSBundle mainBundle] loadNibNamed:@"ACHCheckView" owner:self options:nil][0];
    self.checkView = checkView;
    self.checkView.frame = self.checkViewContainer.bounds;
    [self.checkViewContainer addSubview:checkView];
    checkView.inactiveHostView = self.checkViewContainer;
    checkView.activeHostView = self.navigationController.parentViewController.view;
    
	[self setTitle:NSLocalizedString(@"ach.controller.title", nil)];
	[self.supportButton setTitle:NSLocalizedString([@"ach.controller.button.support" deviceSpecificLocalization], nil) forState:UIControlStateNormal];
	[self.connectButton setTitle:NSLocalizedString(@"ach.controller.button.connect", nil) forState:UIControlStateNormal];
	
	[self.routingNumberTextField setTitle:NSLocalizedString(@"ach.controller.routing.label", nil)];
	self.routingNumberTextField.delegate = self;
	[self.routingNumberTextField setReturnKeyType:UIReturnKeyNext];
	
	[self.accountNumberTextField setTitle:NSLocalizedString(@"ach.controller.account.label", nil)];
	self.accountNumberTextField.delegate = self;
	[self.accountNumberTextField setReturnKeyType:UIReturnKeyDone];
    
    self.originalTopSpace = self.textEntryTopSpace.constant;
}

-(void)viewWillAppear:(BOOL)animated
{
	//showing view so we are deffinetly not dismissing
	self.willDismiss = NO;
    [super viewWillAppear:animated];
    [self.checkView setState:CheckStatePlain animated:NO];
}

- (void)navigateAway:(AchDetailsViewController *)weakSelf
		  completion:(void (^)(void))completion
{
	if(!weakSelf.willDismiss)
	{
		weakSelf.view.userInteractionEnabled = NO;
		weakSelf.willDismiss = YES;
		
		float secondsToDelay = weakSelf.checkView.state == CheckStatePlain?0.0f:0.4f;
		dispatch_time_t timeToDismiss = dispatch_time(DISPATCH_TIME_NOW, secondsToDelay*NSEC_PER_SEC);
		dispatch_after(timeToDismiss, dispatch_get_main_queue(), ^{
			completion();
		});
		
		[self.view endEditing:YES];
		[self.checkView setState:CheckStatePlain animated:YES];
		weakSelf.view.userInteractionEnabled = YES;
	}
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    UINavigationController* navigationController = self.navigationController;
    if([[navigationController viewControllers] count]>1)
    {
        __weak typeof(self) weakSelf = self;
        TransferBackButtonItem *item = [TransferBackButtonItem backButtonWithTapHandler:^{
            if(!IPAD && weakSelf)
            {
				[self navigateAway:weakSelf
						completion:^{
							[navigationController popViewControllerAnimated:YES];
						}];
            }
            else
            {
                [navigationController popViewControllerAnimated:YES];
            }
        }];
        [self.navigationController.topViewController.navigationItem setLeftBarButtonItem:item];
    }
}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

#pragma mark - TextField delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField
{
	if (textField == self.routingNumberTextField)
	{
		[self.accountNumberTextField becomeFirstResponder];
	}
	else
	{
		[textField resignFirstResponder];
	}
	
	return YES;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string
{
	NSInteger maxLength = kMaxAchRoutingLength;
	
	if (textField == self.accountNumberTextField)
	{
		maxLength = kMaxAchAccountlength;
	}
	
	NSString *modified = [textField.text stringByReplacingCharactersInRange:range withString:string];
	
	return modified.length <= maxLength;
}

#pragma mark - Button Actions

- (IBAction)connectPressed:(id)sender
{
    [self.view endEditing:YES];
	NSString* errors = [self isValid];
	
	if (errors == nil)
	{
		//set this to no so navigation back-forward will work
		self.willDismiss = NO;
		__weak typeof(self) weakSelf = self;
		[self navigateAway:weakSelf
				completion:^{
					weakSelf.loginFormBlock(weakSelf.accountNumberTextField.text, weakSelf.routingNumberTextField.text, weakSelf.navigationController);
				}];
	}
	else
	{
		TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"ach.controller.error.title", nil) message:errors];
		[alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
		[alertView show];
	}
}

- (IBAction)textFieldBegunEditing:(id)sender
{
    if(sender == self.accountNumberTextField)
    {
        [self.checkView setState:CheckStateAccountHighlighted animated:YES];
    }
    else
    {
        [self.checkView setState:CheckStateRoutingHighlighted animated:YES];
    }
}

#pragma mark - Validation
- (NSString *)isValid
{
	NSMutableString *errors = [[NSMutableString alloc] init];
	
	if (![self.routingNumberTextField.text hasValue]
		|| ![self.routingNumberTextField.text isValidAchRoutingNumber])
	{
		[errors appendIssue:NSLocalizedString(@"ach.controller.validation.routing.invalid", nil)];
	}
	
	if (![self.accountNumberTextField.text hasValue]
		|| ![self.accountNumberTextField.text isValidAchAccountNumber])
	{
		[errors appendIssue:NSLocalizedString(@"ach.controller.validation.account.invalid", nil)];
	}
	
	if (errors.length > 0)
	{
		return errors;
	}
	
	return nil;
}

#pragma mark - keyboard overlap

-(void)keyboardWillShow:(NSNotification*)note
{
    self.keyboardIsShowing = YES;
    
    NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
   
    CGPoint topOffset = [self.view convertPoint:CGPointMake(0,TOP_OFFSET) fromView:self.navigationController.view];
    self.textEntryTopSpace.constant = MAX(10.0f, topOffset.y);
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];

    if([self.accountNumberTextField isFirstResponder])
    {
        [self.checkView setState:CheckStateAccountHighlighted animated:YES];
    }
    
    if([self.routingNumberTextField isFirstResponder])
    {
        [self.checkView setState:CheckStateRoutingHighlighted animated:YES];
    }

}

-(void)keyboardWillHide:(NSNotification*)note
{
    self.keyboardIsShowing = NO;
    NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
    UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
    
    
    [UIView beginAnimations:nil context:NULL];
    [UIView setAnimationDuration:duration];
    [UIView setAnimationCurve:curve];
    [UIView setAnimationBeginsFromCurrentState:YES];
    
    self.textEntryTopSpace.constant = self.originalTopSpace;
    [self.view layoutIfNeeded];
    
    [UIView commitAnimations];
    
    [self.checkView setState:CheckStatePlain animated:YES];
}

@end


