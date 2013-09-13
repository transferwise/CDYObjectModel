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

@interface CardPaymentViewController () <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end

@implementation CardPaymentViewController

- (id)init {
    self = [super initWithNibName:@"CardPaymentViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

    NSString *absoluteString = [request.URL absoluteString];
    NSLog(@"absoluteString:%@", absoluteString);
    if ([absoluteString rangeOfString:@"/card/paidIn"].location != NSNotFound) {
        self.resultHandler(YES);
        return NO;
    } else if ([absoluteString rangeOfString:@"/card/notPaidIn"].location != NSNotFound) {
        self.resultHandler(NO);
        return NO;
    }

    return YES;
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    MCLog(@"webViewDidStartLoad:%@", webView.request.URL);
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    MCLog(@"webViewDidFinishLoad:%@", webView.request.URL);
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
    NSString *path = [[TransferwiseClient sharedClient] addTokenToPath:@"/card/pay"];
    NSMutableURLRequest *request = [[TransferwiseClient sharedClient] requestWithMethod:@"GET" path:path parameters:@{@"paymentId" : self.payment.remoteId}];
    [TransferwiseOperation provideAuthenticationHeaders:request];
    [self.webView loadRequest:request];
}

@end
