//
//  IntroViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 9/20/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "IntroViewController.h"
#import "IntroView.h"
#import "UIView+Loading.h"
#import "SMPageControl.h"
#import "ObjectModel.h"
#import "Constants.h"
#import "SignUpViewController.h"
#import "ObjectModel+Settings.h"
#import "GoogleAnalytics.h"
#import "MOMStyle.h"
#import "Credentials.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "ConnectionAwareViewController.h"
#import "LoginViewController.h"
#import "Mixpanel+Customisation.h"
#import "AuthenticationHelper.h"
#import "ReferralsCoordinator.h"

@interface IntroViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *whiteStartButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *introScreens;
@property (nonatomic, strong) NSArray *introData;
@property (nonatomic, strong) IBOutlet SMPageControl *pageControl;
@property (nonatomic, assign) NSInteger reportedPage;
@property (nonatomic, assign) NSInteger lastLoadedIndex;
@property (nonatomic, assign) NSInteger currentPage;
@property (weak, nonatomic) IBOutlet UIButton *loginButton;
@property (weak, nonatomic) IBOutlet UIButton *registerButton;
@property (weak, nonatomic) IBOutlet UIButton *whiteLoginButton;
@property (weak, nonatomic) IBOutlet UIButton *whiteRegisterButton;
@property (weak, nonatomic) IBOutlet UIButton *oAuthButton;
@property (weak, nonatomic) IBOutlet UIButton *whiteOAuthButton;
@property (weak, nonatomic) IBOutlet UIView *upfrontRegistrationcontainer;
@property (weak, nonatomic) IBOutlet UIView *noRegistrationContainer;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *whiteButtons;
@property (strong, nonatomic) IBOutletCollection(UIButton) NSArray *blueButtons;
@property (nonatomic, assign) CGSize lastLaidoutPageSize;

@property (strong, nonatomic) AuthenticationHelper *loginHelper;

- (IBAction)startPressed;

@end

@implementation IntroViewController

-(id)init
{
    self = [super initWithNibName:@"IntroViewController" bundle:nil];
    return self;
}

-(void)dealloc
{
    _scrollView.delegate = nil;
    [[NSNotificationCenter defaultCenter] removeObserver:self name:ReferralsDetailsUpdatedNotification object:nil];
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    [self setReportedPage:NSNotFound];

    [self.startButton setTitle:NSLocalizedString(@"intro.start.button.title", nil) forState:UIControlStateNormal];
    [self.whiteStartButton setTitle:NSLocalizedString(@"intro.start.button.title", nil) forState:UIControlStateNormal];

    [self.registerButton setTitle:NSLocalizedString(@"intro.register.button.title", nil) forState:UIControlStateNormal];
    [self.whiteRegisterButton setTitle:NSLocalizedString(@"intro.register.button.title", nil) forState:UIControlStateNormal];
    
    [self.loginButton setTitle:NSLocalizedString(@"intro.login.button.title", nil) forState:UIControlStateNormal];
    [self.whiteLoginButton setTitle:NSLocalizedString(@"intro.login.button.title", nil) forState:UIControlStateNormal];
	
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	if([defaults boolForKey:TRWGoogleLoginUsedKey])
	{
		[self.oAuthButton setTitle:NSLocalizedString(@"intro.google.button.title", nil) forState:UIControlStateNormal];
		[self.whiteOAuthButton setTitle:NSLocalizedString(@"intro.google.button.title", nil) forState:UIControlStateNormal];
	}
	else
	{
		[self.oAuthButton setTitle:NSLocalizedString(@"intro.facebook.button.title", nil) forState:UIControlStateNormal];
		[self.whiteOAuthButton setTitle:NSLocalizedString(@"intro.facebook.button.title", nil) forState:UIControlStateNormal];
	}

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSMutableArray *screens = [NSMutableArray array];

    NSString *plistFileName = self.plistFilenameOverride;
    if(!plistFileName)
    {
        plistFileName = [defaults stringForKey:TRWIntroABKey];
        if(!plistFileName)
        {
            BOOL useIntroB = (arc4random()%2) == 0;
            plistFileName = useIntroB?@"introB":@"intro";
            [[Mixpanel sharedInstance] track:useIntroB?MPIntroABTest1:MPIntroABTest0];
            [defaults setObject:plistFileName forKey:TRWIntroABKey];
        }
    }
    self.introData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:plistFileName ofType:@"plist"]];
    NSMutableArray* preLoadedStylesArray = [NSMutableArray arrayWithCapacity:[self.introData count]];
    for(NSDictionary* dictionary in self.introData)
    {
        NSMutableDictionary* preLoadedStylesDictionary = [NSMutableDictionary dictionaryWithDictionary:dictionary];
        [self replaceStyleForKey:@"bgStyle" inDictionary:preLoadedStylesDictionary];
        [self replaceStyleForKey:@"titleFontStyle" inDictionary:preLoadedStylesDictionary];
        [self replaceStyleForKey:@"textFontStyle" inDictionary:preLoadedStylesDictionary];
        [preLoadedStylesArray addObject:preLoadedStylesDictionary];
    }
    self.introData = preLoadedStylesArray;

    for(int i=0; i<[self.introData count] && i<3; i++)
    {
        IntroView* page = [IntroView loadInstance];
        [page setUpWithDictionary:self.introData[i]];
        [screens addObject:page];
    }
    
    [self setIntroScreens:[NSArray arrayWithArray:screens]];

    [self.pageControl setNumberOfPages:[self.introData count]];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorFromStyle:@"TWElectricBlue"];
    self.pageControl.indicatorDiameter = 10.0f;
    self.pageControl.indicatorMargin = 5.0f;
    self.pageControl.userInteractionEnabled = NO;
    [self.pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];
    
    //Initialise with a invalid value to ensure layout first time around.
    self.lastLoadedIndex = -1;
    self.upfrontRegistrationcontainer.hidden = !self.requireRegistration;
    self.noRegistrationContainer.hidden = self.requireRegistration;
    
    self.loginHelper = [[AuthenticationHelper alloc] init];
    
    
    if(self.requireRegistration)
    {
        NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
        BOOL isRegistered = [defaults boolForKey:TRWIsRegisteredSettingsKey];
        NSString *isRegisteredString = isRegistered?@"true":@"false";
        NSString* referrer = [ReferralsCoordinator referralUser];
        if(referrer)
        {
            [[GoogleAnalytics sharedInstance] sendScreen:GAIntroScreen withAdditionalParameters:@{@"utm_source":@"invite"}];
             [[Mixpanel sharedInstance] sendPageView:MPIntro withProperties:@{TRWIsRegisteredSettingsKey:isRegisteredString,@"utm_source":@"invite"}];
        }
        else
        {
            [[GoogleAnalytics sharedInstance] sendScreen:GAIntroScreen];
            [[Mixpanel sharedInstance] sendPageView:MPIntro withProperties:@{TRWIsRegisteredSettingsKey:isRegisteredString}];
        }
    }
    else
    {
        [[Mixpanel sharedInstance] sendPageView:MPWhatsNew];
        [[GoogleAnalytics sharedInstance] sendScreen:GAWhatsNewScreen];
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(referralUpdateNotification:) name:ReferralsDetailsUpdatedNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.lastLoadedIndex = -1; //Force re-layout
    [self.scrollView setNeedsLayout];
    [self layoutScrollView];
    [self.navigationController setNavigationBarHidden:YES animated:YES];
}

-(void)viewDidLayoutSubviews
{
    if(!CGSizeEqualToSize(self.lastLaidoutPageSize,self.scrollView.bounds.size))
    {
        self.lastLoadedIndex = -1;
         self.scrollView.contentOffset = CGPointMake(self.currentPage*self.scrollView.bounds.size.width, 0);
    }
    [self.scrollView setNeedsLayout];
    [self layoutScrollView];
    [self.view layoutSubviews];
    [super viewDidLayoutSubviews];
}

-(void)layoutScrollView
{
    [self.scrollView layoutIfNeeded];
    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.bounds) * [self.introData count], CGRectGetHeight(self.scrollView.bounds))];
    [self updatePages];
    [self.pageControl updatePageNumberForScrollView:self.scrollView];

}

-(void)updatePages
{
    [self updatePages:NO];
}

-(void)updatePages:(BOOL)force
{
    [self.scrollView layoutIfNeeded];
    
    //Calculate leftmost index
    NSInteger page = MAX(0,MIN(self.introData.count - 3 ,floor(self.scrollView.contentOffset.x/self.scrollView.bounds.size.width) - 1));
    
    if(page != self.lastLoadedIndex || force)
    {
        NSUInteger index = page;
        self.lastLoadedIndex = page;
        
        for (IntroView *intro in self.introScreens) {
            CGRect introFrame = intro.frame;
            introFrame.size = self.scrollView.bounds.size;
            introFrame.origin.x = index * self.scrollView.bounds.size.width;
            [intro setFrame:introFrame];
            [intro setUpWithDictionary:self.introData[index]];
            if(index ==0 && self.requireRegistration)
            {
                NSString* referrer = [ReferralsCoordinator referralUser];
                if(referrer)
                {
                    intro.taglineLabel.text = [NSString stringWithFormat:NSLocalizedString(@"intro.referral.title.format", nil), [referrer uppercaseString]];
                }
            }
            [self.scrollView addSubview:intro];
            index++;
        }
        self.lastLaidoutPageSize = self.scrollView.bounds.size;
    }
    
    [self updateViewOffsets];
    [self updateButtonAppearance];
}

-(void)updateButtonAppearance
{
    [self.scrollView layoutIfNeeded];
    CGFloat relativeOffset = self.scrollView.contentOffset.x/self.scrollView.bounds.size.width;
    NSInteger index = floor(relativeOffset);
    if(index < 0)
    {
        index = 0;
        relativeOffset = 0;
    }
    else if (index >= [self.introData count] - 1)
    {
        index = [self.introData count] - 1;
        relativeOffset = index;
    }
    
    if(relativeOffset - index < 0.05)
    {
        //On one specific page
        BOOL useWhiteButton = [self.introData[index][@"useWhiteButton"] boolValue];
        [self modifyViews:self.whiteButtons withBlock:^(UIView *view) {
            view.hidden = !useWhiteButton;
            view.alpha = 1.0f;
        }];
        [self modifyViews:self.blueButtons withBlock:^(UIView *view) {
            view.hidden = useWhiteButton;
            view.alpha = 1.0f;
        }];
    }
    else
    {
        //in-between pages
        BOOL leftPageUseWhiteButton =  [self.introData[index][@"useWhiteButton"] boolValue];
        BOOL rightPageUseWhiteButton =  [self.introData[index+1][@"useWhiteButton"] boolValue];
        if(leftPageUseWhiteButton != rightPageUseWhiteButton)
        {
            CGFloat whiteAlpha = relativeOffset - index;
            [self modifyViews:self.whiteButtons withBlock:^(UIView *view) {
                view.hidden = NO;
                view.alpha = whiteAlpha;
            }];
            [self modifyViews:self.blueButtons withBlock:^(UIView *view) {
                view.hidden = NO;
                view.alpha = 1.0f - whiteAlpha;
            }];
        }
        else if( leftPageUseWhiteButton && rightPageUseWhiteButton)
        {
            [self modifyViews:self.whiteButtons withBlock:^(UIView *view) {
                view.hidden = NO;
                view.alpha = 1.0f;
            }];
            [self modifyViews:self.blueButtons withBlock:^(UIView *view) {
                view.hidden = YES;
                view.alpha = 1.0f;
            }];
        }
        else if (!leftPageUseWhiteButton && !rightPageUseWhiteButton)
        {
            [self modifyViews:self.whiteButtons withBlock:^(UIView *view) {
                view.hidden = YES;
                view.alpha = 1.0f;
            }];
            [self modifyViews:self.blueButtons withBlock:^(UIView *view) {
                view.hidden = NO;
                view.alpha = 1.0f;
            }];

        }
    }
    
}

-(void)updateViewOffsets
{
     CGFloat relativeOffset = self.scrollView.contentOffset.x/self.scrollView.bounds.size.width;
    for (IntroView *intro in self.introScreens)
    {
        if(!CGRectIsEmpty(self.scrollView.bounds))
        {
            CGFloat viewOffset = intro.frame.origin.x/self.scrollView.bounds.size.width;
            CGFloat difference = relativeOffset - viewOffset;
            [intro shiftCenter:difference];
        }
    }
}

- (void)pageChanged
{
    MCLog(@"Page changed");
    [self.pageControl setScrollViewContentOffsetForCurrentPage:self.scrollView animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.pageControl updatePageNumberForScrollView:self.scrollView];
    self.currentPage = [self.pageControl currentPage];
    [self updatePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self googleReportPage];
    [self updatePages];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self googleReportPage];
    [self updatePages];
}

- (void)googleReportPage
{
    NSInteger currentPage = [self.pageControl currentPage];
    if (self.reportedPage == currentPage)
	{
        return;
    }

    [self setReportedPage:currentPage];
    MCLog(@"Report page:%ld", (long)currentPage);

    [[GoogleAnalytics sharedInstance] sendAppEvent:GAIntroscreensslided withLabel:[NSString stringWithFormat:@"%ld", (long) currentPage + 1]];
}

-(void)modifyViews:(NSArray*)viewArray withBlock:(void(^)(UIView* view))modificationBlock
{
    if(modificationBlock)
    {
        for(UIView* view in viewArray)
        {
            modificationBlock(view);
        }
    }
}

- (IBAction)startPressed
{
    [self.objectModel markIntroShown];
    [self.objectModel markExistingUserIntroShown];
	
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleDefault];
	MainViewController *mainController = [[MainViewController alloc] init];
	[mainController setObjectModel:self.objectModel];
	ConnectionAwareViewController* root = [[ConnectionAwareViewController alloc] initWithWrappedViewController:mainController];
	
    AppDelegate *appDelegate = (AppDelegate *)[[UIApplication sharedApplication] delegate];
	appDelegate.window.rootViewController = root;
}

- (IBAction)logInTapped:(id)sender
{
    LoginViewController* login = [[LoginViewController alloc] init];
    login.objectModel = self.objectModel;
    [self fadeInDismissableViewController:login];
}


- (IBAction)registerTapped:(id)sender
{
    SignUpViewController *signup = [[SignUpViewController alloc] init];
    signup.objectModel = self.objectModel;
    [self fadeInDismissableViewController:signup];
}
- (IBAction)oAuthTapped:(id)sender
{
    __weak typeof(self) weakSelf = self;
	void (^successHandler)() = ^void()
	{
		[AuthenticationHelper proceedFromSuccessfulLoginFromViewController:weakSelf
															   objectModel:weakSelf.objectModel];
	};
	
	NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
	if([defaults boolForKey:TRWGoogleLoginUsedKey])
	{
		[self.loginHelper performOAuthLoginWithProvider:GoogleOAuthServiceName
								   navigationController:self.navigationController
											objectModel:self.objectModel
										 successHandler:^{
											 successHandler();
										 }];
	}
	else
	{
		[self.loginHelper performFacebookLoginWithNavigationController:self.navigationController
														   objectModel:self.objectModel
														successHandler:^{
															successHandler();
														}];
	}
}

-(void)fadeInDismissableViewController:(UIViewController*)viewController
{
    UIButton *closeButton = [[UIButton alloc] initWithFrame:CGRectMake(0,0,40,40)];
    [closeButton setImage:[UIImage imageNamed:@"CloseButton"] forState:UIControlStateNormal];
    [closeButton addTarget:self action:@selector(dismissFade) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *dismissButton = [[UIBarButtonItem alloc] initWithCustomView:closeButton];
    viewController.navigationItem.leftBarButtonItem = dismissButton;
    
    [UIView transitionWithView:self.view.window duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
        [self.navigationController pushViewController:viewController animated:NO];
    } completion:nil];
}

-(void)dismissFade
{
    [UIView transitionWithView:self.navigationController.view.window duration:0.3f options:UIViewAnimationOptionTransitionCrossDissolve animations:nil completion:nil];
    [self.navigationController popViewControllerAnimated:NO];
}

-(void)replaceStyleForKey:(NSString*)key inDictionary:(NSMutableDictionary*)dictionary
{
    MOMBasicStyle* style = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:dictionary[key]];
    if(style)
    {
        UIColor *color = [style color];
        if(color)
        {
            dictionary[[key stringByAppendingString:@"Color"]] = color;
        }
        UIFont *font = [style font];
        if(font)
        {
            dictionary[[key stringByAppendingString:@"Font"]] = font;
        }
        
    }
    [dictionary removeObjectForKey:key];
}

-(void)referralUpdateNotification:(NSNotification*)notification
{
    NSString* referrer = [ReferralsCoordinator referralUser];
    if(referrer)
    {
        [self updatePages:YES];
    }
}

@end
