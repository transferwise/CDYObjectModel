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
#import "NSAttributedString+Attributes.h"
#import "NewPaymentViewController.h"
#import "SignUpViewController.h"
#import "ObjectModel+Settings.h"
#import "GoogleAnalytics.h"
#import "MOMStyle.h"
#import "Credentials.h"
#import "MainViewController.h"
#import "AppDelegate.h"
#import "ConnectionAwareViewController.h"

@interface IntroViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (weak, nonatomic) IBOutlet UIButton *whiteStartButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *introScreens;
@property (nonatomic, strong) NSArray *introData;
@property (nonatomic, strong) IBOutlet SMPageControl *pageControl;
@property (nonatomic, assign) NSInteger reportedPage;
@property (nonatomic, assign) NSInteger lastLoadedIndex;
@property (nonatomic, assign) NSInteger pageBeforeRotation;

- (IBAction)startPressed;

@end

@implementation IntroViewController

- (id)init {
    self = [super initWithNibName:@"IntroViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];

    [self setReportedPage:NSNotFound];

    [self.startButton setTitle:NSLocalizedString(@"intro.start.buttont.title", nil) forState:UIControlStateNormal];
    [self.whiteStartButton setTitle:NSLocalizedString(@"intro.start.buttont.title", nil) forState:UIControlStateNormal];


    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSMutableArray *screens = [NSMutableArray array];

    self.introData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:self.plistFilenameOverride?:@"intro" ofType:@"plist"]];

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

}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.pageBeforeRotation = self.pageControl.currentPage;
}

-(void)willAnimateRotationToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willAnimateRotationToInterfaceOrientation:toInterfaceOrientation duration:duration];
    self.lastLoadedIndex = -1; //Force re-layout
    [self layoutScrollView];
    self.scrollView.contentOffset = CGPointMake(self.pageBeforeRotation*self.scrollView.bounds.size.width, 0);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidLayoutSubviews
{
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
    [self.scrollView layoutIfNeeded];
    
    //Calculate leftmost index
    NSInteger index = MAX(0,MIN(self.introData.count - 3 ,round(self.scrollView.contentOffset.x/self.scrollView.bounds.size.width) - 1));
    
    if(index != self.lastLoadedIndex)
    {
        self.lastLoadedIndex = index;
        for (IntroView *intro in self.introScreens) {
            CGRect introFrame = intro.frame;
            introFrame.size = self.scrollView.bounds.size;
            introFrame.origin.x = index * self.scrollView.bounds.size.width;
            [intro setFrame:introFrame];
            [intro setUpWithDictionary:self.introData[index]];
            [self.scrollView addSubview:intro];
            index++;
        }
    }
    
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
        self.whiteStartButton.hidden = !useWhiteButton;
        self.whiteStartButton.alpha = 1.0f;
        self.startButton.hidden = useWhiteButton;
        self.startButton.alpha = 1.0f;
    }
    else
    {
        //in-between pages
        BOOL leftPageUseWhiteButton =  [self.introData[index][@"useWhiteButton"] boolValue];
        BOOL rightPageUseWhiteButton =  [self.introData[index+1][@"useWhiteButton"] boolValue];
        if(leftPageUseWhiteButton != rightPageUseWhiteButton)
        {
            self.whiteStartButton.hidden = NO;
            self.whiteStartButton.alpha = relativeOffset - index;
            self.startButton.hidden = NO;
            self.startButton.alpha = 1.0f - self.whiteStartButton.alpha;
        }
        else if( leftPageUseWhiteButton && rightPageUseWhiteButton)
        {
            self.whiteStartButton.hidden = NO;
            self.whiteStartButton.alpha = 1.0f;
            self.startButton.hidden = YES;
            self.startButton.alpha = 1.0f;
        }
        else if (!leftPageUseWhiteButton && !rightPageUseWhiteButton)
        {
            self.whiteStartButton.hidden = YES;
            self.whiteStartButton.alpha = 1.0f;
            self.startButton.hidden = NO;
            self.startButton.alpha = 1.0f;

        }
    }
    
}

- (void)pageChanged {
    MCLog(@"Page changed");
    [self.pageControl setScrollViewContentOffsetForCurrentPage:self.scrollView animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pageControl updatePageNumberForScrollView:self.scrollView];
    [self updatePages];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self googleReportPage];
    [self updatePages];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self googleReportPage];
    [self updatePages];
}

- (void)googleReportPage {
    NSInteger currentPage = [self.pageControl currentPage];
    if (self.reportedPage == currentPage) {
        return;
    }

    [self setReportedPage:currentPage];
    MCLog(@"Report page:%ld", (long)currentPage);

    [[GoogleAnalytics sharedInstance] sendAppEvent:@"IntroScreensSlided" withLabel:[NSString stringWithFormat:@"%d", currentPage + 1]];
}

- (NSAttributedString *)attributedMessage:(NSString *)message bold:(NSArray *)boldTexts {
    NSMutableAttributedString *result = [NSMutableAttributedString attributedStringWithString:message];
    OHParagraphStyle *paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
    paragraphStyle.textAlignment = kCTTextAlignmentCenter;
    paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
    [result setParagraphStyle:paragraphStyle];
    [result setFont:[UIFont systemFontOfSize:18]];
    [result setTextColor:[UIColor whiteColor]];
    for (NSString *toBold in boldTexts) {
        NSRange range = [message rangeOfString:toBold];
        [result setFont:[UIFont boldSystemFontOfSize:18] range:range];
    }

    return [[NSAttributedString alloc] initWithAttributedString:result];
}

- (IBAction)startPressed
{
    [self.objectModel markIntroShown];
    [self.objectModel markExistingUserIntroShown];
	
	MainViewController *mainController = [[MainViewController alloc] init];
	[mainController setObjectModel:self.objectModel];
	ConnectionAwareViewController* root = [[ConnectionAwareViewController alloc] initWithWrappedViewController:mainController];
	
	((AppDelegate *)[[UIApplication sharedApplication] delegate]).window.rootViewController = root;
}

@end
