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

    NSMutableURLRequest *request = [[TransferwiseClient sharedClient] requestWithMethod:@"POST" path:@"/api/v1/account/registerWithOpenID" parameters:@{@"provider" : self.provider, @"email" : self.email}];
    [self.webView loadRequest:request];

    self.navigationItem.title = self.providerName;
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    MCLog(@"shouldStartLoading:%@", [request.URL host]);
    NSString *host = [[[TransferwiseClient sharedClient] baseURL] host];
    if ([host isEqualToString:[request.URL host]]) {
        MCLog(@">>>> %@", [request.URL path]);

        NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
        NSArray *cookies = [storage cookies];
        for (NSHTTPCookie *cookie in cookies) {
            if ([cookie.domain rangeOfString:@"transferwise"].location == NSNotFound) {
                continue;
            }

            MCLog(@"Domain:%@", cookie.domain);
            MCLog(@"Path:%@", cookie.path);
            MCLog(@"Name:%@", cookie.name);
            MCLog(@"Properties:%@", cookie.properties);
        }

        MCLog(@"\n\n\n\n\n");
    }
    return YES;
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
