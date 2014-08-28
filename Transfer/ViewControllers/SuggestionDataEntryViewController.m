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

@property (nonatomic, weak) TextFieldSuggestionTable* currentSuggestionTable;

@end

@implementation SuggestionDataEntryViewController

- (void)viewDidLoad
{
	[super viewDidLoad];
    self.containerScrollView.delegate = self;
}

- (void)configureWithDataSource:(id<SuggestionTableCellProvider>)dataSource
					  entryCell:(TextEntryCell *)entryCell
						 height:(CGFloat)height
{
    TextFieldSuggestionTable *suggestionTable = [[NSBundle mainBundle] loadNibNamed:@"TextFieldSuggestionTable" owner:self options:nil][0];
    
    suggestionTable.hidden = YES;
    suggestionTable.suggestionTableDelegate = self;
    [self.view addSubview:suggestionTable];
	suggestionTable.textField = entryCell.entryField;
    suggestionTable.associatedView = entryCell;
	suggestionTable.dataSource = dataSource;
    suggestionTable.rowHeight = height;
    [self.view addSubview:suggestionTable];
    if(!self.suggestionTables)
    {
        self.suggestionTables = [NSMutableArray array];
    }
    [self.suggestionTables addObject:suggestionTable];
}

-(void)willRotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation duration:(NSTimeInterval)duration
{
    [super willRotateToInterfaceOrientation:toInterfaceOrientation duration:duration];
    for(TextFieldSuggestionTable* table in self.suggestionTables)
    {
        table.alpha = 0.0f;
    }
    
}

-(void)didRotateFromInterfaceOrientation:(UIInterfaceOrientation)fromInterfaceOrientation
{
    [super didRotateFromInterfaceOrientation:fromInterfaceOrientation];
    for(TextFieldSuggestionTable* table in self.suggestionTables)
    {
        table.alpha = 1.0f;
    }
    [self updateSuggestionTablePositions];
}

-(void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    if(!decelerate)
    {
        [self updateSuggestionTablePositions];
    }
}

-(void)scrollViewDidEndScrollingAnimation:(UIScrollView *)scrollView
{
    [self updateSuggestionTablePositions];
}

-(void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView
{
    [self updateSuggestionTablePositions];
}

-(void)suggestionTableDidStartEditing:(TextFieldSuggestionTable *)table
{
    self.currentSuggestionTable = table;
    [self.suggestionTables makeObjectsPerformSelector:@selector(removeFromSuperview)];
   [self updateSuggestionTablePositions];
}

-(void)updateSuggestionTablePositions
{
    UIImage* backgroundImage;

    TextFieldSuggestionTable* table = self.currentSuggestionTable;
    [table removeFromSuperview];
    UIView* viewToAlignTo = table.associatedView;
    
    if(!IPAD)
    {
        if(!backgroundImage)
            {
                backgroundImage = [self.view renderBlurWithTintColor:nil];
            }
        UIImageView* background = [[UIImageView alloc] initWithImage:backgroundImage];
        background.contentMode = UIViewContentModeBottom;
        table.backgroundView = background;
        
        UIView *colorOverlay = [[UIView alloc] initWithFrame:background.bounds];
        colorOverlay.bgStyle = @"DarkFont.alpha4";
        colorOverlay.autoresizingMask = UIViewAutoresizingFlexibleWidth|UIViewAutoresizingFlexibleHeight;
        [background addSubview:colorOverlay];
    }
    else
    {
        viewToAlignTo = ((TextEntryCell*)table.associatedView).separatorLine;
    }
    
    if([viewToAlignTo superview])
    {
        CGRect newFrame = table.frame;
        newFrame.origin = [self.view convertPoint:viewToAlignTo.frame.origin fromView:viewToAlignTo.superview];
        newFrame.origin.y += viewToAlignTo.frame.size.height;
        newFrame.size.height = self.view.frame.size.height - newFrame.origin.y;
        newFrame.size.width = viewToAlignTo.frame.size.width;
        table.frame = newFrame;
        [self.view addSubview:table];
    }
}

-(void)suggestionTable:(TextFieldSuggestionTable *)table selectedObject:(id)object
{
    [((TextEntryCell*)table.associatedView).entryField resignFirstResponder];
	[self moveFocusOnNextEntryAfterCell:((TextEntryCell*)table.associatedView)];
}

-(void)keyboardWillShow:(NSNotification*)note
{
    [super keyboardWillShow:note];
    [self updateSuggestionTablePositions];
    CGRect newframe = [self.view convertRect:[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] fromView:self.view.window];
    for (TextFieldSuggestionTable* table in self.suggestionTables)
    {
        table.contentInset = UIEdgeInsetsMake(0, 0, newframe.size.height, 0);
    }
    
}




@end
