//
//  MoneyEntryCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "MoneyEntryCell.h"
#import "PlainCurrency.h"
#import "UIColor+Theme.h"
#import "RoundedCellBackgroundView.h"
#import "Constants.h"

NSString *const TWMoneyEntryCellIdentifier = @"TWMoneyEntryCell";

@interface MoneyEntryCell () <UITextFieldDelegate, UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITextField *moneyField;
@property (nonatomic, strong) IBOutlet UITextField *currencyField;
@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) PlainCurrency *selectedCurrency;
@property (nonatomic, copy) NSString *forcedCurrencyCode;
@property (nonatomic, strong) IBOutlet RoundedCellBackgroundView *roundedBackground;

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

    __block __weak MoneyEntryCell *weakSelf = self;
    [self addDoneButtonToField:self.moneyField withAction:^{
        [weakSelf.moneyField resignFirstResponder];
        [weakSelf.currencyField resignFirstResponder];
    }];

    [self.currencyField setInputAccessoryView:self.moneyField.inputAccessoryView];

    [self.moneyField setDelegate:self];

    UIPickerView *picker = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [self setPicker:picker];
    [picker setShowsSelectionIndicator:YES];
    [self.currencyField setInputView:picker];
    [picker setDataSource:self];
    [picker setDelegate:self];
}

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

- (void)setAmount:(NSString *)amount currency:(PlainCurrency *)currency {
    [self.moneyField setText:amount];
    [self.currencyField setText:currency.code];
}

- (void)setPresentedCurrencies:(NSArray *)presentedCurrencies {
    _presentedCurrencies = presentedCurrencies;

    PlainCurrency *selected = presentedCurrencies[0];

    if (self.forcedCurrencyCode) {
        selected = [self findCurrencyWithCode:self.forcedCurrencyCode];
        [self.currencyField setUserInteractionEnabled:NO];
        [self.currencyField setTextColor:[UIColor disabledEntryTextColor]];
    }

    [self setSelectedCurrency:selected];
    [self.currencyField setText:selected.code];
    [self.picker reloadAllComponents];
    [self.picker selectRow:0 inComponent:0 animated:NO];
}

- (PlainCurrency *)findCurrencyWithCode:(NSString *)code {
    for (PlainCurrency *currency in self.presentedCurrencies) {
        if ([currency.code isEqualToString:code]) {
            return currency;
        }
    }
    return nil;
}

- (NSString *)amount {
    return [self.moneyField text];
}

- (PlainCurrency *)currency {
    return self.selectedCurrency;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![string isEqualToString:@","] && ![string isEqualToString:@"."]) {
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
    PlainCurrency *currency = self.presentedCurrencies[(NSUInteger) row];
    return [currency code];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    PlainCurrency *selected = self.presentedCurrencies[(NSUInteger) row];
    [self setSelectedCurrency:selected];
    [self.currencyField setText:selected.code];
    self.currencyChangedHandler(selected);

    delayedExecution(0.3, ^{
        [self.currencyField resignFirstResponder];
    });
}

- (void)setOnlyPresentedCurrency:(NSString *)currencyCode {
    self.forcedCurrencyCode = currencyCode;
}

- (void)setRoundedCorner:(UIRectCorner)corner {
    [self.roundedBackground setRoundedCorner:corner];
    [self.roundedBackground setNeedsDisplay];
}

@end
