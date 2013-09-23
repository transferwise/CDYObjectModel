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
#import "IntroductionViewController.h"

@interface IntroViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *introScreens;
@property (nonatomic, strong) SMPageControl *pageControl;

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

    [self.startButton setTitle:NSLocalizedString(@"intro.start.buttont.title", nil) forState:UIControlStateNormal];

    NSMutableArray *screens = [NSMutableArray array];
    [screens addObject:[IntroView loadInstance]];
    [(IntroView *) screens[0] setImage:[UIImage imageNamed:@"IntroPageOneImage"] tagline:NSLocalizedString(@"intro.tagline.one", nil) message:[self attributedMessage:NSLocalizedString(@"intro.message.one", nil) bold:@[]]];
    [screens addObject:[IntroView loadInstance]];
    [(IntroView *) screens[1] setImage:[UIImage imageNamed:@"IntroPageTwoImage"] tagline:NSLocalizedString(@"intro.tagline.two", nil) message:[self attributedMessage:NSLocalizedString(@"intro.message.two", nil) bold:@[]]];
    [screens addObject:[IntroView loadInstance]];
    [(IntroView *) screens[2] setImage:[UIImage imageNamed:@"IntroPageThreeImage"] tagline:NSLocalizedString(@"intro.tagline.three", nil) message:[self attributedMessage:NSLocalizedString(@"intro.message.three", nil) bold:@[@"Skype", @"PayPal"]]];

    [self setIntroScreens:screens];

    SMPageControl *pageControl = [[SMPageControl alloc] init];
    [self setPageControl:pageControl];
    [pageControl setCurrentPageIndicatorImage:[UIImage imageNamed:@"PageActive"]];
    [pageControl setPageIndicatorImage:[UIImage imageNamed:@"IntroPageOff"]];
    [pageControl setNumberOfPages:3];
    [pageControl sizeToFit];
    [pageControl setAutoresizingMask:UIViewAutoresizingFlexibleTopMargin];
    [pageControl addTarget:self action:@selector(pageChanged) forControlEvents:UIControlEventValueChanged];

    CGRect pageFrame = pageControl.frame;
    pageFrame.origin.x = (CGRectGetWidth(self.view.frame) - CGRectGetWidth(pageFrame)) / 2;
    pageFrame.origin.y = self.startButton.center.y - CGRectGetHeight(self.startButton.frame) - 20;
    [pageControl setFrame:pageFrame];
    [self.view addSubview:pageControl];
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

- (void)pageChanged {
    MCLog(@"Page changed");
    [self.pageControl setScrollViewContentOffsetForCurrentPage:self.scrollView animated:YES];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    [self.pageControl updatePageNumberForScrollView:self.scrollView];
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
    IntroductionViewController *controller = [[IntroductionViewController alloc] init];
    [controller setObjectModel:self.objectModel];
    [self.navigationController pushViewController:controller animated:YES];
}

@end
