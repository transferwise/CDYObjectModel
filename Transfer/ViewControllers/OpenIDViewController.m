//
//  OpenIDViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 5/31/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "OpenIDViewController.h"
#import "TransferwiseClient.h"
#import "Constants.h"
#import "Credentials.h"
#import "TRWAlertView.h"
#import "NSString+Validation.h"
#import "ObjectModel.h"
#import "ObjectModel+RecipientTypes.h"
#import "TransferBackButtonItem.h"
#import "AppsFlyerTracker.h"
#import "ObjectModel+Users.h"
#import "User.h"
#import "GoogleAnalytics.h"
#import "Mixpanel+Customisation.h"
#import "AuthenticationHelper.h"
#import "PaymentsOperation.h"
#import "NavigationBarCustomiser.h"

@interface OpenIDViewController () <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) PaymentsOperation* paymentsOperation;

@end

@implementation OpenIDViewController

- (id)init {
    self = [super initWithNibName:@"OpenIDViewController" bundle:nil];
    if (self) {
    }
    return self;
}

-(void)dealloc
{
    self.webView.delegate = nil;
    [self.webView stopLoading];
}

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.webView.accessibilityLabel = @"webView";
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.navigationController setNavigationBarHidden:NO animated:YES];

    NSString *loadingPagePath = [[NSBundle mainBundle] pathForResource:@"spinner" ofType:@"html"];
    NSString *loadingPageContent = [[NSString alloc] initWithContentsOfFile:loadingPagePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:loadingPageContent baseURL:[[NSBundle mainBundle] bundleURL]];

    self.navigationItem.title = self.providerName;

    [self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];

    if (!self.registerUser) {
        [[GoogleAnalytics sharedInstance] sendScreen:[NSString stringWithFormat:GALoginFormat, self.provider]];
    }
    [NavigationBarCustomiser setWhite];
}

- (void)viewWillDisappear:(BOOL)animated {
    [super viewWillDisappear:animated];
    [NavigationBarCustomiser setDefault];
    [TransferwiseClient clearCookies];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    MCLog(@"shouldStartLoading:%@", [request.URL host]);
    NSString *host = [[[TransferwiseClient sharedClient] baseURL] host];
    
    if (![host isEqualToString:[request.URL host]]) {
        return YES;
    }

    NSString *absoluteString = [request.URL absoluteString];
    MCLog(@"absoluteString:%@", absoluteString);

    if (![self isLoginPath:absoluteString]) {
        return YES;
    }

    NSString *token = [self valueForCookie:@"userApiToken"];
    NSString *email = [[self valueForCookie:@"userEmail"] stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"\""]];

    MCLog(@"Token:%@ email:%@", token, email);

    [Credentials setUserToken:token];
    if ([email hasValue]) {
        [Credentials setUserEmail:email];
    }

    [[GoogleAnalytics sharedInstance] markLoggedIn];

    if ([Credentials userLoggedIn]) {
        [[Mixpanel sharedInstance] track:MPUserLogged];
        __weak typeof(self) weakSelf = self;
        [self.objectModel removeOtherUsers];
        [self.objectModel saveContext:^{
            dispatch_async(dispatch_get_main_queue(), ^{
                self.webView.delegate = nil;
                [self.webView stopLoading];
                [self.webView removeFromSuperview];
                self.webView = nil;
                [[TransferwiseClient sharedClient] updateUserDetailsWithCompletionHandler:^(NSError *error) {
#if USE_APPSFLYER_EVENTS
                    [AppsFlyerTracker sharedTracker].customerUserID = weakSelf.objectModel.currentUser.pReference;
                    [[AppsFlyerTracker sharedTracker] trackEvent:@"sign-in" withValue:@""];
#endif
                }];

                NSString *event = [absoluteString rangeOfString:@"/openId/registered"].location != NSNotFound ? GAUserregistered : GAUserlogged;
                [[GoogleAnalytics sharedInstance] sendAppEvent:event withLabel:self.provider];

                PaymentsOperation *operation = [PaymentsOperation operationWithOffset:0];
                weakSelf.paymentsOperation = operation;
                [operation setObjectModel:weakSelf.objectModel];
                [operation setCompletion:^(NSInteger totalCount, NSError *error)
                 {
                     [AuthenticationHelper proceedFromSuccessfulLoginFromViewController:weakSelf objectModel:weakSelf.objectModel];
                     weakSelf.paymentsOperation = nil;
                 }];
                [operation execute];
                
                
            });
        }];
    } else {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"openid.login.error.title", nil) message:NSLocalizedString(@"openid.login.generic.error.message", nil)];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
    }

    return NO;
}

- (NSString *)valueForCookie:(NSString *)name {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [storage cookies];
    for (NSHTTPCookie *cookie in cookies) {
        if ([cookie.domain rangeOfString:@"transferwise"].location == NSNotFound) {
            continue;
        }

        if (![cookie.name isEqualToString:name]) {
            continue;
        }

        return cookie.value;
    }

    return nil;
}

- (BOOL)isLoginPath:(NSString *)absoluteString {
    return /*[absoluteString rangeOfString:@"/account/loginWithOpenID"].location != NSNotFound
            || */[absoluteString rangeOfString:@"/openId/mobileLoggedIn"].location != NSNotFound
            || [absoluteString rangeOfString:@"/openId/mobileNotLoggedIn"].location != NSNotFound
            || [absoluteString rangeOfString:@"/openId/loggedIn"].location != NSNotFound
            || [absoluteString rangeOfString:@"/openId/registered"].location != NSNotFound
            || [absoluteString rangeOfString:@"/openId/notLoggedIn"].location != NSNotFound;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    MCLog(@"webViewDidFinishLoad");

    MCLog(@"webViewDidFinishLoad:%@", webView.request.URL);
    if (![webView.request.URL isFileURL]) {
        return;
    }

    [self loadServicePage];
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    MCLog(@"webViewDidStartLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    MCLog(@"didFailLoadWithError:%@", error);
}

- (void)loadServicePage {
    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"provider"] = self.provider;
    if ([self.email hasValue]) {
        data[@"email"] = self.email;
    }
    MCLog(@"Params:%@", data);
    NSString *path = [[TransferwiseClient sharedClient] addTokenToPath:(self.registerUser ? @"/v1/account/registerWithOpenID" : @"/v1/account/loginWithOpenID")];
    NSMutableURLRequest *request = [[TransferwiseClient sharedClient] requestWithMethod:@"POST" path:path parameters:data];
    [TransferwiseOperation provideAuthenticationHeaders:request];
    [self.webView loadRequest:request];
}

@end
