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
#import "CurrencySelectorViewController.h"
#import "MOMStyle.h"

NSString *const TWCurrencySelectionCellIdentifier = @"TWCurrencySelectionCellIdentifier";

@interface CurrencySelectionCell ()
@property (nonatomic,assign) BOOL shouldRestoreNavBar;
@end

@interface CurrencySelectionCell () <NSFetchedResultsControllerDelegate, CurrencySelectorDelegate>

@property (nonatomic, strong) NSFetchedResultsController *currencies;
@property (nonatomic, strong) Currency *selectedCurrency;
@property (weak, nonatomic) IBOutlet UIButton *selectCurrencyButton;
@property (nonatomic) BOOL isSelecting;

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

}

- (void)setAllCurrencies:(NSFetchedResultsController *)currencies {
    _currencies = currencies;
    [_currencies setDelegate:self];

    Currency *shown = [currencies objectAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0]];
    [self didSelectCurrency:shown];
}

- (void)didSelectCurrency:(Currency *)currency
{
    [self setSelectedCurrency:currency];
    [self.selectCurrencyButton setTitle:currency.code forState:UIControlStateNormal];
    UIImage* flag = [UIImage imageNamed:currency.code];
    if(!flag)
    {
        flag = [UIImage imageNamed:@"flag_default"];
    }
    [self.selectCurrencyButton setImage:flag forState:UIControlStateNormal];
    self.selectionHandler(currency);
}

- (IBAction)selectCurrencyTapped:(id)sender
{
	if (self.isSelecting)
	{
		return;
	}
	
	self.isSelecting = YES;
    //dismiss keyboard
    [self endEditing:YES];
    self.shouldRestoreNavBar = ! self.hostForCurrencySelector.navigationController.navigationBarHidden;
    if(self.shouldRestoreNavBar)
    {
        [self.hostForCurrencySelector.navigationController setNavigationBarHidden:YES animated:YES];
    }
    CurrencySelectorViewController* selector = [[CurrencySelectorViewController alloc] init];
    selector.currencySelectorDelegate= self;
    selector.currencyArray = self.currencies.fetchedObjects;
    [selector setSelectedCurrency:self.selectedCurrency];
    selector.view.backgroundColor = [UIColor colorFromStyle:@"TWBlueHighlighted.alpha2"];
    [selector presentOnViewController:self.hostForCurrencySelector];
}


-(void)currencySelector:(CurrencySelectorViewController *)controller didSelectCurrencyAtIndex:(NSUInteger)selectedCurrencyIndex
{
    Currency *selected = [self.currencies objectAtIndexPath:[NSIndexPath indexPathForRow:selectedCurrencyIndex inSection:0]];
    [self didSelectCurrency:selected];
    self.selectionHandler(selected);
}

-(void)currencySelectorwillHide:(CurrencySelectorViewController *)controller
{
	self.isSelecting = NO;
	
    if(self.shouldRestoreNavBar)
    {
        [self.hostForCurrencySelector.navigationController setNavigationBarHidden:NO animated:YES];
        self.shouldRestoreNavBar = NO;
    }
}


@end
