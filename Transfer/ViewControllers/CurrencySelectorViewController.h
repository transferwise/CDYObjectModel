//
//  CurrencySelectorViewController.h
//  Transfer
//
//  Created by Mats Trovik on 23/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CurrencySelectorViewController;
@class Currency;

@protocol CurrencySelectorDelegate <NSObject>

-(void)currencySelector:(CurrencySelectorViewController*)controller didSelectCurrencyAtIndex:(NSUInteger)selectedCurrencyIndex;

@end

@interface CurrencySelectorViewController : UIViewController

@property (nonatomic,strong)NSArray* currencyArray;
@property (nonatomic,weak) id<CurrencySelectorDelegate> delegate;

-(void)setSelectedCurrency:(Currency*)selectedCurrency;
-(void)presentOnViewController:(UIViewController*)hostViewcontroller;

@end
