//
//  MoneyEntryCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "MoneyEntryCell.h"
#import "UIColor+Theme.h"
#import "RoundedCellBackgroundView.h"
#import "Currency.h"
#import "PairSourceCurrency.h"
#import "MoneyFormatter.h"
#import "NSString+Validation.h"
#import "NSString+Presentation.h"
#import "CurrencySelectorViewController.h"

NSString *const TWMoneyEntryCellIdentifier = @"TWMoneyEntryCell";

@interface MoneyEntryCell () <UITextFieldDelegate, NSFetchedResultsControllerDelegate, CurrencySelectorDelegate>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITextField *moneyField;
@property (nonatomic, strong) Currency *selectedCurrency;
@property (nonatomic, strong) Currency *forced;
@property (nonatomic, strong) IBOutlet RoundedCellBackgroundView *roundedBackground;
@property (nonatomic, strong) PairSourceCurrency *source;
@property (weak, nonatomic) IBOutlet UIButton *currencyButton;

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
    }];

    [self.moneyField setDelegate:self];

}

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

- (void)setAmount:(NSString *)amount currency:(Currency *)currency {
    [self.moneyField setText:amount];
}

- (NSString *)amount {
    return [[self.moneyField text] stringByReplacingOccurrencesOfString:@" " withString:@""];
}

- (Currency *)currency {
    return self.selectedCurrency;
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *modified = [textField.text stringByReplacingCharactersInRange:range withString:string];
    if (![string isEqualToString:@","] && ![string isEqualToString:@"."] && [self entryBelowMaxAmount:modified]) {
        [textField setText:[modified moneyFormatting]];
        [textField sendActionsForControlEvents:UIControlEventEditingChanged];
        return NO;
    }

    if (![self entryBelowMaxAmount:modified]) {
        return NO;
    }

    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        [textField setText:[textField.text stringByAppendingString:@"."]];
    }

    return NO;
}

- (BOOL)entryBelowMaxAmount:(NSString *)amountString {
    //TODO: quick hack, needs something more solid and fuctional
    if (![amountString hasValue] || ![self.source isKindOfClass:[PairSourceCurrency class]]) {
        return YES;
    }

    amountString = [amountString stringByReplacingOccurrencesOfString:@" " withString:@""];

    NSNumber *amount = [[MoneyFormatter sharedInstance] numberFromString:amountString];

    if (!amount) {
        return YES;
    }

    NSComparisonResult result = [self.source.maxInvoiceAmount compare:amount];
    return result == NSOrderedDescending || result == NSOrderedSame;
}

- (IBAction)selectCurrencyTapped:(id)sender
{
    CurrencySelectorViewController* selector = [[CurrencySelectorViewController alloc] init];
    selector.delegate = self;
    selector.currencyArray = [self.currencies.fetchedObjects valueForKey:@"currency"];
    [selector setSelectedCurrency:self.selectedCurrency];
    [selector presentOnViewController:self.hostForCurrencySelector];
    
}


-(void)currencySelector:(CurrencySelectorViewController *)controller didSelectCurrencyAtIndex:(NSUInteger)selectedCurrencyIndex
{
    id source = [self.currencies objectAtIndexPath:[NSIndexPath indexPathForRow:selectedCurrencyIndex inSection:0]];
    [self setSource:source];
    Currency *selected = [source currency];
    [self setSelectedCurrency:selected];
    [self.currencyButton setTitle:selected.code forState:UIControlStateNormal];
    self.currencyChangedHandler(selected);

}

- (void)setForcedCurrency:(Currency *)currency {
    
    self.forced = currency;
}

- (void)setRoundedCorner:(UIRectCorner)corner {
    [self.roundedBackground setRoundedCorner:corner];
    [self.roundedBackground setNeedsDisplay];
    [self.roundedBackground setFillGradient:YES];
}

- (void)setCurrencies:(NSFetchedResultsController *)currencies {
    
    [_currencies setDelegate:nil];
    _currencies = currencies;
    [_currencies setDelegate:self];

    id source = currencies.fetchedObjects[0];
    [self setSource:source];
    Currency *selected = [source currency];

    if(self.forced)
    {
        selected = self.forced;
        self.currencyButton.enabled = NO;
    }
    
    [self setSelectedCurrency:selected];
    [self.currencyButton setTitle:selected.code forState:UIControlStateNormal];
    self.currencyChangedHandler(selected);
}


- (void)setMoneyValue:(NSString *)moneyString {
    [self.moneyField setText:moneyString];

    CGRect moneyFrame = self.moneyField.frame;
    CGFloat perfectWidth = [self.moneyField sizeThatFits:CGSizeMake(CGFLOAT_MAX, CGRectGetHeight(moneyFrame))].width;
    CGFloat moneyWidthChange = perfectWidth - CGRectGetWidth(moneyFrame);

    moneyFrame.size.width += moneyWidthChange;
    moneyFrame.origin.x -= moneyWidthChange;
    [self.moneyField setFrame:moneyFrame];

    CGRect titleFrame = self.titleLabel.frame;
    titleFrame.size.width -= moneyWidthChange;
    [self.titleLabel setFrame:titleFrame];
}

@end
