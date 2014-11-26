//
//  DataEntryViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/26/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "DataEntryViewController.h"
#import "TextEntryCell.h"
#import "UIView+Container.h"
#import "Constants.h"
#import "DataEntryDefaultHeader.h"
#import "UIResponder+FirstResponder.h"
#import "MOMStyle.h"
#import "MultipleEntryCell.h"

@interface DataEntryViewController()
@end

@implementation DataEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    if(!self.tableView.bgStyle)
    {
        self.tableView.bgStyle = @"white";
    }
    if(!self.tableView.tableFooterView)
    {
        self.tableView.tableFooterView = [[UIView alloc] init];
    }
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setPresentedSectionCells:(NSArray *)presentedSectionCells {
    _presentedSectionCells = presentedSectionCells;
    
    for (NSArray *sectionCells in presentedSectionCells) {
        for (id cell in sectionCells) {
            
            if (![self isEntryCell:cell]) {
                continue;
            }
            
            TextEntryCell *entryCell = cell;
            [entryCell.entryField setDelegate:self];
            [entryCell.entryField setReturnKeyType:UIReturnKeyNext];
        }
    }
    
    UITableViewCell *lastCell = [[presentedSectionCells lastObject] lastObject];
    if ([self isEntryCell:lastCell]) {
        TextEntryCell *entryCell = (TextEntryCell *) lastCell;
        [entryCell.entryField setReturnKeyType:UIReturnKeyDone];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = self.presentedSectionCells[indexPath.section][indexPath.row];
    return CGRectGetHeight(cell.frame);
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    NSString* title = [self tableView:tableView titleForHeaderInSection:section];
    if(title)
    {
        return IPAD?75.0f:60.0f;
    }
    
    return UITableViewAutomaticDimension;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return UITableViewAutomaticDimension;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    return nil;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section
{
    NSString* title = [self tableView:tableView titleForHeaderInSection:section];
    if(title)
    {
        DataEntryDefaultHeader* header = [DataEntryDefaultHeader instance];
        header.titleLabel.text = title;
        return header;
    }
    return nil;
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return nil;
}


#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.presentedSectionCells count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *sectionCells = self.presentedSectionCells[(NSUInteger) section];
    return [sectionCells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [self cellForIndexPath:indexPath];
    return cell;
}

- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath
{
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger row = (NSUInteger) indexPath.row;
    UITableViewCell *cell = self.presentedSectionCells[section][row];
	
	if([cell isKindOfClass:[MultipleEntryCell class]])
	{
		((MultipleEntryCell *)cell).multipleEntryDelegate = self;
	}
	
	return cell;
}

#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cell = [self cellForIndexPath:indexPath];
    if ([self isEntryCell:cell]) {
        TextEntryCell *entryCell = cell;
        [entryCell.entryField becomeFirstResponder];
    } else {
        [self tappedCellAtIndexPath:indexPath];
    }
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath {
    MCLog(@"tappedCellAtIndexPath:%@", indexPath);
}

#pragma mark - Text field delegate
- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    UITableViewCell *containingCell = [textField findContainerOfType:[UITableViewCell class]];
    
    BOOL moved = [self moveFocusOnNextEntryAfterCell:containingCell];
    
    if (!moved && [containingCell isKindOfClass:[TextEntryCell class]]) {
        TextEntryCell *entryCell = (TextEntryCell *) containingCell;
        [entryCell.entryField resignFirstResponder];
    }
    
    [self textFieldEntryFinished];
    
    return YES;
}

- (void)navigateAwayFrom:(UITableViewCell *)cell
{
	[self textFieldEntryFinished];
	[self moveFocusOnNextEntryAfterCell:cell];
}

- (void)textFieldDidEndEditing:(UITextField *)textField
{
    [self textFieldEntryFinished];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    TextEntryCell *cell = [textField findContainerOfType:[TextEntryCell class]];
    return [cell textField:textField shouldChangeCharactersInRange:range replacementString:string];
}

#pragma mark - Moving Between Cells

- (BOOL)moveFocusOnNextEntryAfterCell:(UITableViewCell *)cell
{
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    
    if (indexPath == nil) {
        return NO;
    }
    
    if ([cell isKindOfClass:[TextEntryCell class]])
	{
        [(TextEntryCell *)cell markTouched];
    }
	
	if ([cell isKindOfClass:[MultipleEntryCell class]] && ![(MultipleEntryCell *)cell shouldNavigateAway])
	{
		return NO;
	}
    
    NSIndexPath *moveToIndexPath = indexPath;
    while ((moveToIndexPath = [self nextEditableIndexPathAfter:moveToIndexPath]) != nil)
	{
        UITableViewCell *viewCell = [self cellForIndexPath:moveToIndexPath];
        if ([self isEntryCell:viewCell])
		{
            TextEntryCell *entryCell = (TextEntryCell *) viewCell;
			
			if([entryCell isKindOfClass:[MultipleEntryCell class]])
			{
				[(MultipleEntryCell *)entryCell activate];
			}
			else
			{
				[entryCell.entryField becomeFirstResponder];
			}
			
            if([self.tableView indexPathForCell:entryCell])
            {
                [self.tableView scrollToRowAtIndexPath:moveToIndexPath atScrollPosition:UITableViewScrollPositionTop animated:YES];
            }
            return YES;
        }
    }
    
    return NO;
}

- (NSIndexPath *)nextEditableIndexPathAfter:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger row = (NSUInteger) indexPath.row;
    
    for (; section < [self.presentedSectionCells count]; section++) {
        NSArray *sectionCells = self.presentedSectionCells[section];
        for (; row < [sectionCells count]; row++) {
            id cell = sectionCells[row];
            if (![self isEntryCell:cell]) {
                continue;
            }
            
            NSIndexPath *path = [NSIndexPath indexPathForRow:row inSection:section];
            if ([path isEqual:indexPath]) {
                continue;
            }
            
            TextEntryCell *entryCell = cell;
			
            if (!entryCell.editable)
			{
                continue;
            }
            
            return path;
        }
        
        row = 0;
    }
    
    return nil;
}

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell {
    for (NSUInteger section = 0; section < [self.presentedSectionCells count]; section++) {
        NSArray *sectionCells = self.presentedSectionCells[section];
        NSUInteger row = [sectionCells indexOfObject:cell];
        if (row != NSNotFound) {
            return [NSIndexPath indexPathForRow:row inSection:section];
        }
    }
    
    return nil;
}

- (BOOL)isEntryCell:(UITableViewCell *)cell {
    return [cell isKindOfClass:[TextEntryCell class]];
}

- (void)textFieldEntryFinished
{
    
}

#pragma mark - keyboard overlap
-(void)keyboardWillShow:(NSNotification*)note
{
    if(!IPAD)
    {
        CGRect newframe = [self.view.window convertRect:[note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue] toView:self.view];
        NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        CGFloat overlap = self.tableView.frame.origin.y + self.tableView.frame.size.height - newframe.origin.y;
        
        if(overlap >0)
        {            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:duration];
            [UIView setAnimationCurve:curve];
            [UIView setAnimationBeginsFromCurrentState:YES];
            
            if(UIEdgeInsetsEqualToEdgeInsets(self.cachedInsets, UIEdgeInsetsZero))
            {
                self.cachedInsets = self.tableView.contentInset;
            }
            
            UIEdgeInsets newInsets = self.cachedInsets;
            newInsets.bottom += overlap;
            self.tableView.contentInset = newInsets;
            
            [UIView commitAnimations];
            
            UIView *firstResponder = [UIResponder currentFirstResponder];
            if(firstResponder)
            {
                UIView* superview = firstResponder.superview;
                UITableViewCell *cell;
                while (superview && ![superview isKindOfClass:[UITableViewCell class]])
                {
                    superview = superview.superview;
                }
                if ([superview isKindOfClass:[UITableViewCell class]])
                {
                    cell = (UITableViewCell*)superview;
                }
                if(cell)
                {
                    NSIndexPath *path = [self.tableView indexPathForRowAtPoint:cell.center];
                    if(path)
                    {
                        //Scroll cell after the keyboard has animated
                        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, duration * NSEC_PER_SEC), dispatch_get_main_queue(), ^{
                            [self.tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
                        });
                        
                    }
                }
            }
        }
    }
}

-(void)keyboardWillHide:(NSNotification*)note
{
    if(!IPAD)
    {
        NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        self.tableView.contentInset = self.cachedInsets;
        
        [UIView commitAnimations];
        
        self.cachedInsets = UIEdgeInsetsZero;
    }
}

-(void)reloadSeparators
{
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
}

@end
