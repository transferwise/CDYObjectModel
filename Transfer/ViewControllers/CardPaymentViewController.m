//
//  CardPaymentViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 9/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CardPaymentViewController.h"
#import "Constants.h"
#import "TransferwiseClient.h"
#import "Payment.h"
#import "ClaimAccountViewController.h"
#import "Credentials.h"
#import "TRWProgressHUD.h"
#import "TRWAlertView.h"
#import "PullPaymentDetailsOperation.h"
#import "TransferDetailsViewController.h" 
#import "FeedbackCoordinator.h"
#import "CustomInfoViewController.h"
#import "GoogleAnalytics.h"
#import "Mixpanel+Customisation.h"
#import "CustomInfoViewController+Notifications.h"


#ifdef DEV_VERSION
#import "TransferDevWebTools.h"
#endif


@interface CardPaymentViewController () <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) PullPaymentDetailsOperation *executedOperation;
@property (nonatomic, assign) NSHTTPCookieAcceptPolicy bufferedPolicy;
@property (weak, nonatomic) IBOutlet UIView *errorView;
@property (weak, nonatomic) IBOutlet UIImageView *errorImage;
@property (weak, nonatomic) IBOutlet UILabel *errorLabel
;
@property (weak, nonatomic) IBOutlet UIButton *errorButton;

@end

@implementation CardPaymentViewController

- (id)init {
    self = [super initWithNibName:@"CardPaymentViewController" bundle:nil];
    if (self) {
        _bufferedPolicy = [NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy;
        [NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy = NSHTTPCookieAcceptPolicyAlways;
#ifdef DEV_VERSION
        [NSURLProtocol registerClass:[DebugURLProtocol class]];
#endif
    }
    return self;
}

-(void)dealloc
{
    self.webView.delegate = nil;
    [self.webView stopLoading];
#ifdef DEV_VERSION
    [NSURLProtocol unregisterClass:[DebugURLProtocol class]];
#endif
    [NSHTTPCookieStorage sharedHTTPCookieStorage].cookieAcceptPolicy = _bufferedPolicy;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    self.webView.scrollView.contentInset = UIEdgeInsetsMake(IPAD?30:10,0,0,0);

    // Do any additional setup after loading the view from its nib.
}


- (void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    [self loadCardView];
    [[GoogleAnalytics sharedInstance] sendScreen:GADebitCardPayment];
    [[Mixpanel sharedInstance] sendPageView:MPDebitCardPayment];

}

-(void)viewDidDisappear:(BOOL)animated
{
    [super viewDidDisappear:animated];
    self.errorView.hidden = YES;
}


- (void)presentLoadingView {
    NSString *loadingPagePath = [[NSBundle mainBundle] pathForResource:@"spinner" ofType:@"html"];
    NSString *loadingPageContent = [[NSString alloc] initWithContentsOfFile:loadingPagePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:loadingPageContent baseURL:[[NSBundle mainBundle] bundleURL]];
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    MCLog(@"shouldStartLoadWithRequest:%@", request.URL);
    NSString *host = [[[TransferwiseClient sharedClient] baseURL] host];

    if (![host isEqualToString:[request.URL host]]) {
        return YES;
    }

    URLAction action = self.loadURLBlock(request.URL);
    switch (action) {
        case URLActionContinueLoad:
            return YES;
            break;
        case URLActionAbortAndReportFailure:
            self.resultHandler(NO);
            [self showError];
            return NO;
            break;
        case URLActionAbortAndReportSuccess:
            self.resultHandler(YES);
            [self pushNextScreen];
            return NO;
            break;
        case URLActionAbortLoad:
        default:
            return NO;
            break;
    }
}

- (void)webViewDidStartLoad:(UIWebView *)webView {

}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    if (![webView.request.URL isFileURL]) {
        return;
    }

    [self loadPaymentPage];
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    MCLog(@"didFailLoadWithError:%@ : %@", webView.request.URL, error);
}

- (void)loadCardView {
    [self presentLoadingView];
}

- (void)loadPaymentPage {
    __weak typeof(self) weakSelf = self;
    self.initialRequestProvider(^(NSURLRequest* request){
        if(request)
        {
            [weakSelf.webView loadRequest:request];
        }
        else
        {
            [weakSelf.webView loadHTMLString:@"" baseURL:nil];
        }
    });
}

- (void)pushNextScreen {
    dispatch_async(dispatch_get_main_queue(), ^{
        //TODO jaanus: copy/paste from BankTransferScreen
        if ([Credentials temporaryAccount]) {
            ClaimAccountViewController *controller = [[ClaimAccountViewController alloc] init];
            [controller setObjectModel:self.objectModel];
            [self.navigationController pushViewController:controller animated:YES];
        } else {
            [self pushUpdatedTransactionScreen];
        }
    });
}

- (void)pushUpdatedTransactionScreen {
    dispatch_async(dispatch_get_main_queue(), ^{
        if (self.executedOperation) {
            return;
        }
        
        CustomInfoViewController * customInfo = [CustomInfoViewController successScreenWithMessage:@"upload.money.card.payment.success.message"];
        __weak typeof(self) weakSelf = self;
        __weak typeof(customInfo) weakCustomInfo = customInfo;
        __block BOOL shouldAutoDismiss = YES;
        ActionButtonBlock action = ^{
            if(weakSelf.executedOperation)
            {
                TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:weakCustomInfo.view];
                [hud setMessage:NSLocalizedString(@"upload.money.refreshing.payment.message", nil)];
                
                [weakSelf.executedOperation setResultHandler:^(NSError *error) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [hud hide];
                        [weakSelf setExecutedOperation:nil];
                        
                        if (error) {
                            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"upload.money.transaction.refresh.error.title", nil) message:NSLocalizedString(@"upload.money.transaction.refresh.error.message", nil)];
                            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                            [alertView show];
                            [weakCustomInfo dismiss];
                            return;
                        }
                        
                        TransferDetailsViewController *details = [[TransferDetailsViewController alloc] init];
                        details.payment = weakSelf.payment;
                        details.objectModel = self.objectModel;
                        details.showClose = YES;
                        details.promptForNotifications = [CustomInfoViewController shouldPresentNotificationsPrompt];
                        
                        [self.navigationController pushViewController:details animated:NO];
                        [[FeedbackCoordinator sharedInstance] startFeedbackTimerWithCheck:^BOOL {
                            return YES;
                        }];
                        [weakCustomInfo dismiss];
                    });
                }];
            }
            else
            {
                shouldAutoDismiss = NO;
                [weakCustomInfo dismiss];
            }
            
        };
        customInfo.actionButtonBlocks = @[action];
        
        [customInfo presentOnViewController:self.navigationController.parentViewController withPresentationStyle:TransparentPresentationFade];
        
        PullPaymentDetailsOperation *operation = [PullPaymentDetailsOperation operationWithPaymentId:[self.payment remoteId]];
        [self setExecutedOperation:operation];
        [operation setObjectModel:self.objectModel];
        [operation setResultHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [weakSelf setExecutedOperation:nil];
                
                if (error) {
                    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"upload.money.transaction.refresh.error.title", nil) message:NSLocalizedString(@"upload.money.transaction.refresh.error.message", nil)];
                    [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
                    [alertView show];
                    return;
                }
                
                TransferDetailsViewController *details = [[TransferDetailsViewController alloc] init];
                details.payment = weakSelf.payment;
                details.showClose = YES;
                details.objectModel = self.objectModel;
                details.showClose = YES;
                details.promptForNotifications = [CustomInfoViewController shouldPresentNotificationsPrompt];
                
                [self.navigationController pushViewController:details animated:NO];
                [[FeedbackCoordinator sharedInstance] startFeedbackTimerWithCheck:^BOOL {
                    return YES;
                }];
                if(shouldAutoDismiss)
                {
                    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                        if(shouldAutoDismiss)
                        {
                            [weakCustomInfo dismiss];
                        }
                    });
                }
            });
        }];
        [operation execute];
    });
}

-(void)showError
{
    self.errorLabel.text = NSLocalizedString(@"upload.money.card.no.payment.message", nil);
    [self.errorButton setTitle:NSLocalizedString(@"upload.money.card.retry", nil) forState:UIControlStateNormal];
    self.errorImage.image = [UIImage imageNamed:@"RedCross"];
    self.errorView.hidden = NO;
    self.errorView.alpha = 0.0f;
    [UIView animateWithDuration:0.2f delay:0.0f options:UIViewAnimationOptionCurveEaseOut animations:^{
        self.errorView.alpha = 1.0f;
    } completion:nil];
}

- (IBAction)refreshTapped:(id)sender {
    self.errorView.hidden = YES;
    [self loadCardView];
}

@end
