//
//  MoneyEntryCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "MoneyEntryCell.h"
#import "Currency.h"

NSString *const TWMoneyEntryCellIdentifier = @"TWMoneyEntryCell";

@interface MoneyEntryCell () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITextField *moneyField;
@property (nonatomic, strong) IBOutlet UITextField *currencyField;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) Currency *selectedCurrency;

@end

@implementation MoneyEntryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];

    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    [toolbar setItems:@[flexible, done]];
    [self.moneyField setInputAccessoryView:toolbar];

    //TODO jaanus: maybe can find a way how to change keyboard locale
    [self.moneyField setDelegate:self];

    [self.currencyField setInputAccessoryView:toolbar];
    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [self setPicker:picker];
    [picker setShowsSelectionIndicator:YES];
    [self.currencyField setInputView:picker];
    [picker setDataSource:self];
    [picker setDelegate:self];
}

- (void)donePressed {
    [self.moneyField resignFirstResponder];
    [self.currencyField resignFirstResponder];
}

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

- (void)setAmount:(NSString *)amount currency:(Currency *)currency {
    [self.moneyField setText:amount];
    [self.currencyField setText:currency.code];
}

- (void)setPresentedCurrencies:(NSArray *)presentedCurrencies {
    _presentedCurrencies = presentedCurrencies;

    Currency *selected = presentedCurrencies[0];
    [self setSelectedCurrency:selected];
    [self.currencyField setText:selected.code];
    [self.picker reloadAllComponents];
    [self.picker selectRow:0 inComponent:0 animated:NO];
}

- (NSString *)amount {
    return [self.moneyField text];
}

- (Currency *)currency {
    return self.selectedCurrency;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![string isEqualToString:@","]) {
        return YES;
    }

    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        [textField setText:[textField.text stringByAppendingString:@"."]];
    }

    return NO;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.presentedCurrencies count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Currency *currency = self.presentedCurrencies[(NSUInteger) row];
    return [currency code];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    Currency *selected = self.presentedCurrencies[(NSUInteger) row];
    [self setSelectedCurrency:selected];
    [self.currencyField setText:selected.code];
    self.currencyChangedHandler(selected);
}

@end
