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

@interface IntroViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *introScreens;
@property (nonatomic, strong) IBOutlet SMPageControl *pageControl;
@property (nonatomic, assign) NSInteger reportedPage;

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

    self.automaticallyAdjustsScrollViewInsets = NO;
    
    NSMutableArray *screens = [NSMutableArray array];

    NSArray* introData = [NSArray arrayWithContentsOfFile:[[NSBundle mainBundle] pathForResource:@"intro" ofType:@"plist"]];

    for(NSDictionary *pageData in introData)
    {
        IntroView* page = [IntroView loadInstance];
        [page setUpWithDictionary:pageData];
        [screens addObject:page];
    }
    
    [self setIntroScreens:screens];

    [self.pageControl setNumberOfPages:[screens count]];
    self.pageControl.pageIndicatorTintColor = [UIColor whiteColor];
    self.pageControl.currentPageIndicatorTintColor = [UIColor colorFromStyle:@"TWElectricBlue"];
    self.pageControl.indicatorDiameter = 10.0f;
    self.pageControl.indicatorMargin = 5.0f;
    [self.pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];

    [self.scrollView setContentSize:CGSizeMake(CGRectGetWidth(self.scrollView.frame) * [self.introScreens count], CGRectGetHeight(self.scrollView.frame))];

    CGFloat xOffset = 0;
    for (IntroView *intro in self.introScreens) {
        CGRect introFrame = intro.frame;
        introFrame.size = self.scrollView.frame.size;
        introFrame.origin.x = xOffset;
        [intro setFrame:introFrame];
        [self.scrollView addSubview:intro];
        xOffset += CGRectGetWidth(introFrame);
    }

    [self.pageControl updatePageNumberForScrollView:self.scrollView];
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    [[GoogleAnalytics sharedInstance] sendScreen:[NSString stringWithFormat:@"Intro screen"]];

    [self.objectModel markIntroShown];
}


- (void)pageChanged {
    MCLog(@"Page changed");
    [self.pageControl setScrollViewContentOffsetForCurrentPage:self.scrollView animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pageControl updatePageNumberForScrollView:self.scrollView];
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView {
    [self googleReportPage];
}

- (void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView {
    [self googleReportPage];
}

- (void)googleReportPage {
    NSInteger currentPage = [self.pageControl currentPage];
    if (self.reportedPage == currentPage) {
        return;
    }

    [self setReportedPage:currentPage];
    MCLog(@"Report page:%d", currentPage);

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

- (IBAction)startPressed {
    UIViewController *presented;
    if ([self.objectModel shouldShowDirectUserSignup]) {
        SignUpViewController *controller = [[SignUpViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        presented = controller;
    } else {
        NewPaymentViewController *controller = [[NewPaymentViewController alloc] init];
        [controller setObjectModel:self.objectModel];
        presented = controller;
    }

    [self.navigationController pushViewController:presented animated:YES];
}

@end
