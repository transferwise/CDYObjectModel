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
#import "Constants.h"

@interface IntroViewController () <UIScrollViewDelegate>

@property (nonatomic, strong) IBOutlet UIButton *startButton;
@property (nonatomic, strong) IBOutlet UIScrollView *scrollView;
@property (nonatomic, strong) NSArray *introScreens;
@property (nonatomic, strong) SMPageControl *pageControl;

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
    [(IntroView *) screens[0] setImage:[UIImage imageNamed:@"IntroPageOneImage"]];
    [screens addObject:[IntroView loadInstance]];
    [(IntroView *) screens[1] setImage:[UIImage imageNamed:@"IntroPageTwoImage"]];
    [screens addObject:[IntroView loadInstance]];
    [(IntroView *) screens[2] setImage:[UIImage imageNamed:@"IntroPageThreeImage"]];

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

@end
