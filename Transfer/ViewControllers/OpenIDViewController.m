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

@interface OpenIDViewController () <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;

@end

@implementation OpenIDViewController

- (id)init {
    self = [super initWithNibName:@"OpenIDViewController" bundle:nil];
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

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    NSString *loadingPagePath = [[NSBundle mainBundle] pathForResource:@"spinner" ofType:@"html"];
    NSString *loadingPageContent = [[NSString alloc] initWithContentsOfFile:loadingPagePath encoding:NSUTF8StringEncoding error:nil];
    [self.webView loadHTMLString:loadingPageContent baseURL:[[NSBundle mainBundle] bundleURL]];

    self.navigationItem.title = self.providerName;
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    NSMutableDictionary *data = [NSMutableDictionary dictionary];
    data[@"provider"] = self.provider;
    if ([self.email hasValue]) {
        data[@"email"] = self.email;
    }
    MCLog(@"Params:%@", data);
    NSMutableURLRequest *request = [[TransferwiseClient sharedClient] requestWithMethod:@"POST" path:@"/api/v1/account/registerWithOpenID" parameters:data];
    [self.webView loadRequest:request];
}


- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    MCLog(@"shouldStartLoading:%@", [request.URL host]);
    NSString *host = [[[TransferwiseClient sharedClient] baseURL] host];
    
    if (![host isEqualToString:[request.URL host]]) {
        return YES;
    }

    NSString *absoluteString = [request.URL absoluteString];
    NSLog(@"absoluteString:%@", absoluteString);

    if (![self isLoginPath:absoluteString]) {
        return YES;
    }

    NSString *token = [self valueForCookie:@"userApiToken"];
    NSString *email = [self valueForCookie:@"userEmail"];

    MCLog(@"Token:%@ email:%@", token, email);

    [Credentials setUserToken:token];
    if ([email hasValue]) {
        [Credentials setUserEmail:email];
    }

    if ([Credentials userLoggedIn]) {
        [[TransferwiseClient sharedClient] updateUserDetailsWithCompletionHandler:nil];
        [self dismissViewControllerAnimated:YES completion:nil];
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
    return [absoluteString rangeOfString:@"/account/loginWithOpenID"].location != NSNotFound
            || [absoluteString rangeOfString:@"/openId/mobileLoggedIn"].location != NSNotFound;
}

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    MCLog(@"webViewDidFinishLoad");
}

- (void)webViewDidStartLoad:(UIWebView *)webView {
    MCLog(@"webViewDidStartLoad");
}

- (void)webView:(UIWebView *)webView didFailLoadWithError:(NSError *)error {
    MCLog(@"didFailLoadWithError:%@", error);
}

@end
