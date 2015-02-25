//
//  OAuthViewController.m
//  Transfer
//
//  Created by Juhan Hion on 25.02.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "OAuthViewController.h"
#import "NavigationBarCustomiser.h"
#import "GoogleAnalytics.h"
#import "TransferBackButtonItem.h"

@interface OAuthViewController () <UIWebViewDelegate>

@property (nonatomic, strong) IBOutlet UIWebView *webView;
@property (nonatomic, strong) NSURL *requestUrl;
@property (nonatomic, strong) NSString *provider;
@property (nonatomic, strong) ObjectModel *objectModel;

@end

@implementation OAuthViewController

#pragma mark - Init
- (instancetype)initWithProvider:(NSString *)provider
							 url:(NSURL *)requestUrl
					 objectModel:(ObjectModel *)objectModel
{
	self = [super init];
	if (self)
	{
		self.provider = provider;
		self.requestUrl = requestUrl;
		self.objectModel = objectModel;
	}
	return self;
}

- (void)dealloc
{
	self.webView.delegate = nil;
	[self.webView stopLoading];
}

- (void)viewWillAppear:(BOOL)animated
{
	[super viewWillAppear:animated];
	
	[self.navigationController setNavigationBarHidden:NO animated:YES];
	
	NSString *loadingPagePath = [[NSBundle mainBundle] pathForResource:@"spinner" ofType:@"html"];
	NSString *loadingPageContent = [[NSString alloc] initWithContentsOfFile:loadingPagePath encoding:NSUTF8StringEncoding error:nil];
	[self.webView loadHTMLString:loadingPageContent baseURL:[[NSBundle mainBundle] bundleURL]];
	
	self.navigationItem.title = self.provider;
	
	[self.navigationItem setLeftBarButtonItem:[TransferBackButtonItem backButtonForPoppedNavigationController:self.navigationController]];
	
	if (!self.registerUser)
	{
		[[GoogleAnalytics sharedInstance] sendScreen:[NSString stringWithFormat:@"Login %@", self.provider]];
	}
	[NavigationBarCustomiser setWhite];
}

#pragma mark -
- (void)webViewDidFinishLoad:(UIWebView *)webView
{
	MCLog(@"webViewDidFinishLoad");
	MCLog(@"webViewDidFinishLoad:%@", webView.request.URL);
	
	//initally a file URL for spinner will be loaded
	//if an actual url is loaded we don't want to start from the top again
	if (![webView.request.URL isFileURL])
	{
		return;
	}
	
	[self.webView loadRequest:[NSURLRequest requestWithURL:self.requestUrl]];
}

@end
