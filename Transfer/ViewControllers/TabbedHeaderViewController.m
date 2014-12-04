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

@property (strong, nonatomic) IBOutlet NSLayoutConstraint *contentWidth;

@end

@implementation TabbedHeaderViewController

- (id)init
{
    self = [super initWithNibName:@"TabbedHeaderViewController" bundle:nil];
    if (self)
	{
        // Custom initialization
    }
    return self;
}

- (void)configureWithControllers:(NSArray *)controllers titles:(NSArray *)titles
{
	[self configureWithControllers:controllers
							titles:titles
					   actionTitle:nil
					   actionStyle:nil
					  actionShadow:nil
					actionProgress:CGFLOAT_MIN];
}

- (void)configureWithControllers:(NSArray *)controllers
						  titles:(NSArray *)titles
					 actionTitle:(NSString *)actionTitle
					 actionStyle:(NSString *)actionStyle
					actionShadow:(NSString *)actionShadow
				  actionProgress:(CGFloat)actionProgress
{
	MCAssert([controllers count] == [titles count]);
	
	self.controllers = controllers;
	self.titles = titles;
	
	if(actionTitle)
	{
		[self.actionButton setTitle:actionTitle forState:UIControlStateNormal];
		
		if (actionStyle)
		{
			if(actionShadow && IPAD)
			{
				[self.actionButton configureWithCompoundStyle:actionStyle
												  shadowColor:actionShadow];
			}
			else
			{
				[self.actionButton configureWithCompoundStyle:actionStyle];
			}
		}
		
		if (actionProgress > CGFLOAT_MIN)
		{
			self.actionButton.progress = actionProgress;
		}
		
		if (IPAD)
		{
			self.actionButton.addShadow = YES;
		}
	}
	else
	{
		self.showButtonForIphone = NO;
	}
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	
    if ([self.controllers count] < 2)
    {
        self.headerHeight.constant = 0;
    }
	else
	{
		[self.tabView setTabTitles:self.titles];
		[self.tabView setSelectedIndex:0];
	}
	
	//UI configuration
	if (IPAD && self.showFullWidth)
	{
		//arbitrary large value, other constraints will catch it
		self.contentWidth.constant = 2000;
	}
	
	if (!IPAD && !self.showButtonForIphone)
	{
		self.buttonHeight.constant = 0;
		[self.actionButton setHidden:YES];
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
    UIViewController *currentController = [self.childViewControllers firstObject];
    if(currentController)
    {
        [self willSelectViewController:currentController atIndex:[self.controllers indexOfObject:currentController]];
    }
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
    [self addChildViewController:first];
    [first didMoveToParentViewController:self];
	[self.containerView addSubview:first.view];
	first.view.frame = self.containerView.bounds;
	first.view.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
	
	for (UIViewController *controller in others)
	{
		if(controller != first && controller.view.subviews != nil)
		{
            [controller removeFromParentViewController];
			[controller.view removeFromSuperview];
		}
	}
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
