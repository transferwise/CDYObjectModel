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

@interface RecipientEntrySelectionCell () <UIPickerViewDelegate, UIPickerViewDataSource>

@property (nonatomic, strong) IBOutlet UITextField *autoCompleteField;
@property (nonatomic, strong) IBOutlet UIImageView *downView;
@property (nonatomic, strong) UIPickerView *picker;

@end

@implementation RecipientEntrySelectionCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [self setPicker:pickerView];
    [pickerView setDelegate:self];
    [pickerView setDataSource:self];
    [pickerView setShowsSelectionIndicator:YES];

    [self.autoCompleteField setInputView:pickerView];

    //TODO jaanus: copy/paste from money cell
    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];

    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    [toolbar setItems:@[flexible, done]];
    [self.autoCompleteField setInputAccessoryView:toolbar];
}

- (void)donePressed {
    [self.autoCompleteField resignFirstResponder];
}


- (void)setAutoCompleteRecipients:(NSArray *)autoCompleteRecipients {
    _autoCompleteRecipients = autoCompleteRecipients;

    BOOL haveAutoComplete = [autoCompleteRecipients count] > 0;
    if (haveAutoComplete) {
        return;
    }

    [self.picker reloadAllComponents];

    [self.autoCompleteField setHidden:YES];
    [self.downView setHidden:YES];

    CGRect entryFrame = self.entryField.frame;
    entryFrame.size.width = CGRectGetMaxX(self.autoCompleteField.frame) - CGRectGetMinX(entryFrame);
    [self.entryField setFrame:entryFrame];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    if (row == 0) {
        return @"";
    }

    Recipient *recipient = self.autoCompleteRecipients[row - 1];
    return recipient.name;
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    if (row == 0) {
        self.selectionHandler(nil);
        return;
    }

    Recipient *recipient = self.autoCompleteRecipients[row - 1];
    self.selectionHandler(recipient);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.autoCompleteRecipients count] + 1;
}

@end
