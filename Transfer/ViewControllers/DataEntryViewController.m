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

@interface DataEntryViewController () <UITextFieldDelegate>

@end

@implementation DataEntryViewController

- (void)viewDidLoad {
    [super viewDidLoad];

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

- (UITableViewCell *)cellForIndexPath:(NSIndexPath *)indexPath {
    NSUInteger section = (NSUInteger) indexPath.section;
    NSUInteger row = (NSUInteger) indexPath.row;
    return self.presentedSectionCells[section][row];
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

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    TextEntryCell *cell = [textField findContainerOfType:[TextEntryCell class]];
    return [cell shouldChangeCharactersInRange:range replacementString:string];
}

- (BOOL)moveFocusOnNextEntryAfterCell:(UITableViewCell *)cell {
    NSIndexPath *indexPath = [self indexPathForCell:cell];

    if (indexPath == nil) {
        return NO;
    }

    NSIndexPath *moveToIndexPath = indexPath;
    while ((moveToIndexPath = [self nextEditableIndexPathAfter:moveToIndexPath]) != nil) {
        UITableViewCell *viewCell = [self cellForIndexPath:moveToIndexPath];
        if ([self isEntryCell:viewCell]) {
            TextEntryCell *entryCell = (TextEntryCell *) viewCell;
            [entryCell.entryField becomeFirstResponder];
            [self.tableView scrollToRowAtIndexPath:moveToIndexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
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
            if (![entryCell.entryField isEnabled]) {
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

- (void)textFieldEntryFinished {

}

@end
