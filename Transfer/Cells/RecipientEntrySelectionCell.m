//
//  RecipientEntrySelectionCell.m
//  Transfer
//
//  Created by Jaanus Siim on 5/10/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientEntrySelectionCell.h"
#import "Recipient.h"

NSString *const TRWRecipientEntrySelectionCellIdentifier = @"TRWRecipientEntrySelectionCellIdentifier";

@interface RecipientEntrySelectionCell () <UIPickerViewDelegate, UIPickerViewDataSource, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) IBOutlet UITextField *autoCompleteField;
@property (nonatomic, strong) IBOutlet UIImageView *downView;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, assign) CGFloat originalEntryWidth;

@end

@implementation RecipientEntrySelectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)dealloc {
    [_autoCompleteRecipients setDelegate:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setOriginalEntryWidth:CGRectGetWidth(self.entryField.frame)];

    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [self setPicker:pickerView];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [pickerView setShowsSelectionIndicator:YES];

    [self.autoCompleteField setInputView:pickerView];

    __block __weak RecipientEntrySelectionCell *weakSelf = self;
    [self addDoneButtonToField:self.autoCompleteField withAction:^{
        [weakSelf.autoCompleteField resignFirstResponder];
    }];
}

- (void)setAutoCompleteRecipients:(NSFetchedResultsController *)autoCompleteRecipients {
    _autoCompleteRecipients = autoCompleteRecipients;
    [autoCompleteRecipients setDelegate:self];

    [self reloadInputPresentation];
}

- (void)reloadInputPresentation {
    BOOL haveAutoComplete = [self.autoCompleteRecipients.fetchedObjects count] > 0;
    [self.picker reloadAllComponents];

    [self.autoCompleteField setHidden:!haveAutoComplete];
    [self.downView setHidden:!haveAutoComplete];

    CGRect entryFrame = self.entryField.frame;
    if (haveAutoComplete) {
        entryFrame.size.width = self.originalEntryWidth;
    } else {
        entryFrame.size.width = CGRectGetMaxX(self.autoCompleteField.frame) - CGRectGetMinX(entryFrame);
    }
    [self.entryField setFrame:entryFrame];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return @"";
    }

    Recipient *recipient = [self.autoCompleteRecipients objectAtIndexPath:[NSIndexPath indexPathForRow:row - 1 inSection:0]];
    return recipient.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        self.selectionHandler(nil);
        return;
    }

    Recipient *recipient = [self.autoCompleteRecipients objectAtIndexPath:[NSIndexPath indexPathForRow:row - 1 inSection:0]];
    self.selectionHandler(recipient);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.autoCompleteRecipients.fetchedObjects count] + 1;
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self reloadInputPresentation];
}

@end
