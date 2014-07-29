//
//  CurrencySelectorViewController.h
//  Transfer
//
//  Created by Mats Trovik on 23/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TransparentModalViewController.h"

@class CurrencySelectorViewController;
@class Currency;

@protocol CurrencySelectorDelegate <NSObject>

@optional
-(void)currencySelectorwillShow:(CurrencySelectorViewController*)controller;
-(void)currencySelector:(CurrencySelectorViewController*)controller didSelectCurrencyAtIndex:(NSUInteger)selectedCurrencyIndex;
-(void)currencySelectorwillHide:(CurrencySelectorViewController*)controller;

@end

@interface CurrencySelectorViewController : TransparentModalViewController

@property (nonatomic,strong)NSArray* currencyArray;
@property (nonatomic,weak) id<CurrencySelectorDelegate> delegate;

-(void)setSelectedCurrency:(Currency*)selectedCurrency;

@end
