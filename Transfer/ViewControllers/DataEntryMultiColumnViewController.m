//
//  DataEntryMultiColumnViewController.m
//  Transfer
//
//  Created by Jaanus Siim on 4/26/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "DataEntryMultiColumnViewController.h"
#import "TextEntryCell.h"
#import "UIView+Container.h"
#import "Constants.h"
#import "DataEntryDefaultHeader.h"
#import "UIResponder+FirstResponder.h"
#import "MOMStyle.h"

@interface DataEntryMultiColumnViewController() <UITextFieldDelegate>
@end

@implementation DataEntryMultiColumnViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardWillHide:) name:UIKeyboardWillHideNotification object:nil];
    
    for(UITableView* tableView in self.tableViews)
    {
        tableView.bgStyle = @"white";
        tableView.tableFooterView = [[UIView alloc] init];
    }
    
}

-(void)dealloc
{
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:UIKeyboardWillHideNotification object:nil];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setSectionCellsByTableView:(NSArray *)sectionCellsByTableView
{
    _sectionCellsByTableView = sectionCellsByTableView;
    
    for(NSArray* tableViewSections in sectionCellsByTableView)
    {
        for (NSArray *sectionCells in tableViewSections) {
            for (id cell in sectionCells) {
                
                if (![self isEntryCell:cell]) {
                    continue;
                }
                
                TextEntryCell *entryCell = cell;
                [entryCell.entryField setDelegate:self];
                [entryCell.entryField setReturnKeyType:UIReturnKeyNext];
            }
        }
    }
    
    UITableViewCell *lastCell = [[[sectionCellsByTableView lastObject] lastObject] lastObject];
    if ([self isEntryCell:lastCell]) {
        TextEntryCell *entryCell = (TextEntryCell *) lastCell;
        [entryCell.entryField setReturnKeyType:UIReturnKeyDone];
    }
}


- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = [self.tableViews indexOfObject:tableView];
    UITableViewCell *cell = self.sectionCellsByTableView[index][indexPath.section][indexPath.row];
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
    NSUInteger index = [self.tableViews indexOfObject:tableView];
    return [self.sectionCellsByTableView[index] count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSUInteger index = [self.tableViews indexOfObject:tableView];
    NSArray *sectionCells = self.sectionCellsByTableView[index][(NSUInteger) section];
    return [sectionCells count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSUInteger index = [self.tableViews indexOfObject:tableView];
    UITableViewCell *cell = self.sectionCellsByTableView[index][indexPath.section][indexPath.row];
    return cell;
}


#pragma mark - Table view delegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    id cell = [tableView cellForRowAtIndexPath:indexPath];
    if ([self isEntryCell:cell]) {
        TextEntryCell *entryCell = cell;
        [entryCell.entryField becomeFirstResponder];
    } else {
        [self tappedCellAtIndexPath:indexPath inTableView:tableView];
    }
}

- (void)tappedCellAtIndexPath:(NSIndexPath *)indexPath inTableView:(UITableView*)tableView {
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

- (void)textFieldDidEndEditing:(UITextField *)textField {
    [self textFieldEntryFinished];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    TextEntryCell *cell = [textField findContainerOfType:[TextEntryCell class]];
    return [cell shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)moveFocusOnNextEntryAfterCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self indexPathForCell:cell];
    
    if (indexPath == nil) {
        return NO;
    }
    
    if ([cell isKindOfClass:[TextEntryCell class]]) {
        [(TextEntryCell *)cell markTouched];
    }
    
    NSUInteger tableViewIndex = [self indexOfTableViewContainingCell:cell];

     NSIndexPath *moveToIndexPath = indexPath;
    
    while (tableViewIndex != NSNotFound)
    {
        UITableView* tableView = self.tableViews[tableViewIndex];
        while ((moveToIndexPath = [self nextEditableIndexPathAfter:moveToIndexPath inTableViewWithIndex:tableViewIndex]) != nil) {
            UITableViewCell *viewCell = [self tableView:tableView cellForRowAtIndexPath:moveToIndexPath];
            if ([self isEntryCell:viewCell]) {
                TextEntryCell *entryCell = (TextEntryCell *) viewCell;
                [entryCell.entryField becomeFirstResponder];
                [self scrollToCell:entryCell inTableView:tableView];
                return YES;
            }
        }
        moveToIndexPath = [NSIndexPath indexPathForRow:-1 inSection:0];
        tableViewIndex++;
        if(tableViewIndex >= [self.tableViews count])
        {
            tableViewIndex = NSNotFound;
        }

            
    }
    
    return NO;
    
}

- (NSIndexPath *)nextEditableIndexPathAfter:(NSIndexPath *)indexPath inTableViewWithIndex:(NSUInteger)tableViewIndex {
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger row = (NSUInteger) MAX(0,indexPath.row);
    
    NSUInteger count = [self.sectionCellsByTableView[tableViewIndex] count];
    
    for (; section < count ; section++) {
        NSArray *sectionCells = self.sectionCellsByTableView[tableViewIndex][section];
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
            if (![entryCell.entryField isEnabled]) {
                continue;
            }
            
            return path;
        }
        
        row = 0;
    }
    
    return nil;
}

-(NSUInteger)indexOfTableViewContainingCell:(UITableViewCell *)cell
{
    for (NSArray *tableViewSectionIndex in self.sectionCellsByTableView)
    {
        for (NSUInteger section = 0; section < [tableViewSectionIndex count]; section++) {
            NSArray *sectionCells = tableViewSectionIndex[section];
            NSUInteger row = [sectionCells indexOfObject:cell];
            if (row != NSNotFound) {
                return [self.sectionCellsByTableView indexOfObject:tableViewSectionIndex];
            }
        }
    }
    
    return NSNotFound;
}

- (NSIndexPath *)indexPathForCell:(UITableViewCell *)cell {
    
    for (NSArray *tableViewSectionIndex in self.sectionCellsByTableView)
    {
        for (NSUInteger section = 0; section < [tableViewSectionIndex count]; section++) {
            NSArray *sectionCells = tableViewSectionIndex[section];
            NSUInteger row = [sectionCells indexOfObject:cell];
            if (row != NSNotFound) {
                return [NSIndexPath indexPathForRow:row inSection:section];
            }
        }
    }
    
    return nil;
}

- (BOOL)isEntryCell:(UITableViewCell *)cell {
    return [cell isKindOfClass:[TextEntryCell class]];
}

- (void)textFieldEntryFinished {
    
}

#pragma mark - keyboard overlap
-(void)keyboardWillShow:(NSNotification*)note
{
    if([self.tableViews count] == 1)
    {
        UITableView* tableView = self.tableViews[0];
        CGRect newframe = [note.userInfo[UIKeyboardFrameEndUserInfoKey] CGRectValue];
        NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        CGFloat overlap = tableView.frame.origin.y + tableView.frame.size.height - newframe.origin.y;
        
        if(overlap >0)
        {
            
            [UIView beginAnimations:nil context:NULL];
            [UIView setAnimationDuration:duration];
            [UIView setAnimationCurve:curve];
            [UIView setAnimationBeginsFromCurrentState:YES];
            
            if(UIEdgeInsetsEqualToEdgeInsets(self.cachedInsets, UIEdgeInsetsZero))
            {
                self.cachedInsets = tableView.contentInset;
            }
            
            UIEdgeInsets newInsets = self.cachedInsets;
            newInsets.bottom += overlap;
            tableView.contentInset = newInsets;
            
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
                    NSIndexPath *path = [tableView indexPathForCell:cell];
                    if(path)
                    {
                        [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionNone animated:YES];
                    }
                }
            }
        }
    }
}

-(void)keyboardWillHide:(NSNotification*)note
{
    if([self.tableViews count] == 1)
    {
        UITableView* tableView = self.tableViews[0];
        NSTimeInterval duration = [note.userInfo[UIKeyboardAnimationDurationUserInfoKey] doubleValue];
        UIViewAnimationCurve curve = [note.userInfo[UIKeyboardAnimationCurveUserInfoKey] integerValue];
        
        
        [UIView beginAnimations:nil context:NULL];
        [UIView setAnimationDuration:duration];
        [UIView setAnimationCurve:curve];
        [UIView setAnimationBeginsFromCurrentState:YES];
        
        tableView.contentInset = self.cachedInsets;
        
        [UIView commitAnimations];
        
        self.cachedInsets = UIEdgeInsetsZero;
    }
}

-(void)scrollToCell:(UITableViewCell*)cell inTableView:(UITableView*)tableView
{
    NSIndexPath *path = [tableView indexPathForCell:cell];
    if(path)
    {
        [tableView scrollToRowAtIndexPath:path atScrollPosition:UITableViewScrollPositionTop animated:YES];
    }
}

-(void)reloadSeparators
{
    for(UITableView* tableView in self.tableViews)
    {
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    }
}

-(BOOL)hasMoreThanOneTableView
{
    return [self.tableViews count] > 1;
}

@end