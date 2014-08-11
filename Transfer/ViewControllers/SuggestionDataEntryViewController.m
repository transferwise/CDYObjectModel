//
//  SuggestionDataEntryViewController.m
//  Transfer
//
//  Created by Juhan Hion on 29.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SuggestionDataEntryViewController.h"
#import "UIView+MOMStyle.h"
#import "UIView+RenderBlur.h"

@interface SuggestionDataEntryViewController ()

@property (nonatomic, weak) TextEntryCell *entryCell;

@end

@implementation SuggestionDataEntryViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
	self.suggestionTable = [[NSBundle mainBundle] loadNibNamed:@"TextFieldSuggestionTable" owner:self options:nil][0];
    
    self.suggestionTable.hidden = YES;
    self.suggestionTable.suggestionTableDelegate = self;
    [self.view addSubview:self.suggestionTable];
    self.containerScrollView.delegate = self;
}

- (void)configureWithDataSource:(id<SuggestionTableCellProvider>)dataSource
					  entryCell:(TextEntryCell *)entryCell
						 height:(CGFloat)height
{
	self.entryCell = entryCell;
	self.suggestionTable.textField = self.entryCell.entryField;
	self.suggestionTable.dataSource = dataSource;
	self.suggestionTable.rowHeight = height;
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    self.suggestionTable.alpha = 0.0f;
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
	[self suggestionTableDidStartEditing:self.suggestionTable];
    self.suggestionTable.alpha = 1.0f;
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        [self updateSuggestionTablePosition:self.suggestionTable];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateSuggestionTablePosition:self.suggestionTable];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateSuggestionTablePosition:self.suggestionTable];
}

-(void)suggestionTableDidStartEditing:(TextFieldSuggestionTable *)table
{
    [self updateSuggestionTablePosition:table];
}

-(void)updateSuggestionTablePosition:(TextFieldSuggestionTable *)table
{
    [table removeFromSuperview];
    UIView* viewToAlignTo = self.entryCell;
	
    if(!IPAD)
    {
        UIImageView* background = [[UIImageView alloc] initWithImage:[self.view renderBlurWithTintColor:nil]];
        background.contentMode = UIViewContentModeBottom;
        table.backgroundView = background;
        
        UIView *colorOverlay = [[UIView alloc] initWithFrame:background.bounds];
        colorOverlay.bgStyle = @"DarkFont.alpha4";
        colorOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [background addSubview:colorOverlay];
    }
    else
    {
        viewToAlignTo = self.entryCell.separatorLine;
    }
    
    CGRect newFrame = table.frame;
    newFrame.origin = [self.view convertPoint:viewToAlignTo.frame.origin fromView:viewToAlignTo.superview];
    newFrame.origin.y += viewToAlignTo.frame.size.height;
    newFrame.size.height = self.view.frame.size.height - newFrame.origin.y;
    newFrame.size.width = viewToAlignTo.frame.size.width;
    table.frame = newFrame;
    [self.view addSubview:table];
}

-(void)suggestionTable:(TextFieldSuggestionTable *)table selectedObject:(id)object
{
    [self.entryCell.entryField resignFirstResponder];
}

-(void)keyboardWillShow:(NSNotification*)note
{
    if(self.parentViewController)
    {
        [super keyboardWillShow:note];
        [self updateSuggestionTablePosition:self.suggestionTable];
        CGRect newframe = [self.view convertRect:[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window];
        self.suggestionTable.contentInset = UIEdgeInsetsMake(0, 0, newframe.size.height, 0);
    }
}

-(void)keyboardWillHide:(NSNotification*)note
{
    if(self.parentViewController)
    {
        [super keyboardWillHide:note];
        self.suggestionTable.contentInset = UIEdgeInsetsZero;
    }
}


@end
