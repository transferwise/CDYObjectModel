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

@interface CardPaymentViewController () <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) TransferwiseOperation *executedOperation;
@property (nonatomic, strong) NSURLRequest *initialRequest;

@end

@implementation CardPaymentViewController

- (id)init {
    self = [super initWithNibName:@"CardPaymentViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)dealloc
{
    self.webView.delegate = nil;
    [self.webView stopLoading];
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
        
        if(webView.request == self.initialRequest)
        {
            
        }
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
            weakSelf.initialRequest = request;
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
        
        TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:self.navigationController.view];
        [hud setMessage:NSLocalizedString(@"upload.money.refreshing.payment.message", nil)];
        PullPaymentDetailsOperation *operation = [PullPaymentDetailsOperation operationWithPaymentId:[self.payment remoteId]];
        [self setExecutedOperation:operation];
        [operation setObjectModel:self.objectModel];
        __weak typeof(self) weakSelf = self;
        [operation setResultHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                [hud hide];
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
                
                [self.navigationController pushViewController:details animated:YES];
                [[FeedbackCoordinator sharedInstance] startFeedbackTimerWithCheck:^BOOL {
                    return YES;
                }];
            });
        }];
        
        [operation execute];
    });
}

- (IBAction)refreshTapped:(id)sender {
    [self loadCardView];
}

@end
