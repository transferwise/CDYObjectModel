//
//  CurrencySelectionCell.m
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TextEntryCell.h"
#import "CurrencySelectionCell.h"
#import "Currency.h"

NSString *const TWCurrencySelectionCellIdentifier = @"TWCurrencySelectionCellIdentifier";

@interface CurrencySelectionCell () <UIPickerViewDataSource, UIPickerViewDelegate, NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) IBOutlet UITextField *currencyField;
@property (nonatomic, strong) NSFetchedResultsController *currencies;
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

- (void)dealloc {
    [self.currencies setDelegate:nil];
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [self setPicker:pickerView];
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];

    [self.currencyField setInputView:pickerView];

    [self addDoneButton];
}

- (void)setAllCurrencies:(NSFetchedResultsController *)currencies {
    _currencies = currencies;
    [_currencies setDelegate:self];

    Currency *shown = [currencies objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self didSelectCurrency:shown];
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
    return [self.currencies.fetchedObjects count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    Currency *currency = [self.currencies objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    return [currency formattedCodeAndName];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    Currency *currency = [self.currencies objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [self didSelectCurrency:currency];
}

- (void)controllerDidChangeContent:(NSFetchedResultsController *)controller {
    [self.picker reloadAllComponents];
}

@end
