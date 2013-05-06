//
//  CurrencySelectionCell.m
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "CurrencySelectionCell.h"
#import "Currency.h"

NSString *const TWCurrencySelectionCellIdentifier = @"TWCurrencySelectionCellIdentifier";

@interface CurrencySelectionCell () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) IBOutlet UITextField *currencyField;
@property (nonatomic, strong) NSArray *currencies;
@property (nonatomic, strong) Currency *selectedCurrency;
@property (nonatomic, strong) UIPickerView *picker;

@end

@implementation CurrencySelectionCell

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
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];

    [self.currencyField setInputView:pickerView];

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    [toolbar setItems:@[spacer, doneButton]];

    [self.currencyField setInputAccessoryView:toolbar];
}

- (void)donePressed {
    [self.currencyField resignFirstResponder];
}

- (void)setAllCurrencies:(NSArray *)currencies {
    _currencies = currencies;

    [self didSelectCurrency:currencies[0]];
}

- (void)didSelectCurrency:(Currency *)currency {
    [self setSelectedCurrency:currency];
    [self.currencyField setText:[currency formattedCodeAndName]];

    self.selectionHandler(currency);
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.currencies count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Currency *currency = self.currencies[(NSUInteger) row];
    return [currency formattedCodeAndName];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    Currency *currency = self.currencies[(NSUInteger) row];
    [self didSelectCurrency:currency];
}

@end
