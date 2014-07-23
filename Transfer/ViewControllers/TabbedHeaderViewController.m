//
//  TabbedHeaderViewController.m
//  Transfer
//
//  Created by Juhan Hion on 23.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TabbedHeaderViewController.h"
#import "HeaderTabView.h"
#import "UINavigationController+StackManipulations.h"

@interface TabbedHeaderViewController ()<HeaderTabViewDelegate>

@property (nonatomic, strong) NSString* firstTitle;
@property (nonatomic, strong) NSString* secondTitle;

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic,weak) IBOutlet HeaderTabView *tabView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tabViewHeightConstraint;
@property (nonatomic,weak) IBOutlet UIButton *actionButton;

@end

@implementation TabbedHeaderViewController

- (id)init
{
    self = [super initWithNibName:@"TabbedHeaderViewController" bundle:nil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)configureWithFirstController:(UIViewController *)first
						  firstTitle:(NSString *)firstTitle
					secondController:(UIViewController *)second
						 secondTitle:(NSString *)secondTitle
						 actionTitle:(NSString *)actionTitle
{
	self.firstViewController = first;
	self.secondViewController = second;
	self.firstTitle = firstTitle;
	self.secondTitle = secondTitle;
	
	[self.actionButton setTitle:actionTitle forState:UIControlStateNormal];
}

- (void)setFirstViewController:(UIViewController *)firstViewController
{
	_firstViewController = firstViewController;
	[self attachChildController:self.firstViewController];
}

- (void)setSecondViewController:(UIViewController *)secondViewController
{
	_secondViewController = secondViewController;
	[self attachChildController:self.secondViewController];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setTitle:NSLocalizedString(@"upload.money.title", @"")];
	
    if (!self.secondViewController)
    {
        self.tabViewHeightConstraint.constant = 0;
    }
	else
	{
		[self.tabView setTabTitles:@[self.firstTitle, self.secondTitle]];
		[self.tabView setSelectedIndex:0];
	}
	
    self.containerView.translatesAutoresizingMaskIntoConstraints = NO;
    
    [self headerTabView:nil tabTappedAtIndex:0];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    [self.navigationController setNavigationBarHidden:NO animated:YES];
    [self.containerView setNeedsLayout];
    [self.containerView layoutIfNeeded];
}

- (void)viewDidAppear:(BOOL)animated
{
	[super viewDidAppear:animated];
	
	[self.navigationController flattenStack];
}

- (void)headerTabView:(HeaderTabView *)tabView tabTappedAtIndex:(NSUInteger)index
{
    if (index == 1 && self.secondViewController)
	{
		[self willSelectSecondViewController];
        [self addFirst:self.secondViewController removeSecond:self.firstViewController];
    }
	else
	{
		[self willSelectFirstViewController];
		[self addFirst:self.firstViewController removeSecond:self.secondViewController];
    }
    
}

- (void)addFirst:(UIViewController *)first removeSecond:(UIViewController *)second
{
	[self.containerView addSubview:first.view];
	first.view.frame = self.containerView.bounds;
	first.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	[second.view removeFromSuperview];
}

- (void)attachChildController:(UIViewController *)controller
{
    [self addChildViewController:controller];
    [controller.view setFrame:self.containerView.bounds];
    [self.containerView addSubview:controller.view];
}

- (IBAction)actionTapped:(id)sender
{
	[self actionTapped];
}

- (void)willSelectFirstViewController
{
	//override in an inheriting class to customize
}

- (void)willSelectSecondViewController
{
	//override in an inheriting class to customize
}

- (void)actionTapped
{
	//override in an inheriting class to customize
}
@end
