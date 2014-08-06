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
#import "Constants.h"
#import "ColoredButton.h"

@interface TabbedHeaderViewController ()<HeaderTabViewDelegate>

@property (nonatomic, strong) NSArray* titles;
@property (nonatomic, strong) NSArray* controllers;

@property (nonatomic, weak) IBOutlet UIView *containerView;

@property (nonatomic,weak) IBOutlet HeaderTabView *tabView;
@property (nonatomic,weak) IBOutlet ColoredButton *actionButton;

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *headerHeight;
@property (strong, nonatomic) IBOutlet NSLayoutConstraint *buttonHeight;

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

- (void)configureWithControllers:(NSArray *)controllers
						  titles:(NSArray *)titles
					 actionTitle:(NSString *)actionTitle
					 actionStyle:(NSString *)actionStyle
				  actionProgress:(CGFloat)actionProgress
{
	MCAssert([controllers count] == [titles count]);
	
	self.controllers = controllers;
	self.titles = titles;
	
	[self.actionButton setTitle:actionTitle forState:UIControlStateNormal];
	[self.actionButton configureWithCompoundStyle:actionStyle];
	self.actionButton.progress = actionProgress;
	[self attachControllers:self.controllers];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    [self setTitle:NSLocalizedString(@"upload.money.title", @"")];
	
    if ([self.controllers count] < 2)
    {
        self.headerHeight.constant = 0;
    }
	else
	{
		[self.tabView setTabTitles:self.titles];
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
}

- (void)headerTabView:(HeaderTabView *)tabView tabTappedAtIndex:(NSUInteger)index
{
	if ([self.controllers count] >= index)
	{
		UIViewController* controller = self.controllers[index];
		
		if(controller)
		{
			[self willSelectViewController:controller atIndex:index];
			[self addToSuperview:controller removeOthers:self.controllers];
		}
		
	}
}

- (void)addToSuperview:(UIViewController *)first removeOthers:(NSArray *)others
{
	[self.containerView addSubview:first.view];
	first.view.frame = self.containerView.bounds;
	first.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
	for (UIViewController *controller in others)
	{
		if(controller != first && controller.view.subviews != nil)
		{
			[controller.view removeFromSuperview];
		}
	}
}

- (void)attachControllers:(NSArray *)controllers
{
	for (UIViewController *controller in controllers)
	{
		[self attachChildController:controller];
	}
}

- (void)attachChildController:(UIViewController *)controller
{
    [self addChildViewController:controller];
    [controller.view setFrame:self.containerView.bounds];
    [self.containerView addSubview:controller.view];
}

- (IBAction)actionTapped:(id)sender
{
	NSUInteger idx = self.tabView.selectedIndex;
	MCAssert(idx <= [self.controllers count]);
	[self actionTappedWithController:self.controllers[idx]
							 atIndex:idx];
}

- (void)willSelectViewController:(UIViewController *)controller
						 atIndex:(NSUInteger)index
{
	//override in an inheriting class to customize
}

- (void)actionTappedWithController:(UIViewController *)controller
						   atIndex:(NSUInteger)index
{
	//override in an inheriting class to customize
}

- (void)resetActionButtonTitle:(NSString *)title
{
	[self.actionButton setTitle:title forState:UIControlStateNormal];
}
@end
