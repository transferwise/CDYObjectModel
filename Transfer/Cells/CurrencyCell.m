//
//  CurrencyCell.m
//  Transfer
//
//  Created by Mats Trovik on 23/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "CurrencyCell.h"
#import "Currency.h"

@interface CurrencyCell ()
@property (weak, nonatomic) IBOutlet UIImageView *flagImage;
@property (weak, nonatomic) IBOutlet UILabel *currencyLabel;
@property (weak, nonatomic) IBOutlet UILabel *whiteCurrencyLabel;
@end

@implementation CurrencyCell


-(void)configureWithCurrency:(Currency *)currency
{
    UIImage *flag = [UIImage imageNamed:currency.code];
    if(!flag)
    {
        flag = [UIImage imageNamed:@"flag_default"];
    }
    self.flagImage.image = flag;
    self.currencyLabel.text = currency.code;
    self.whiteCurrencyLabel.text = currency.code;
}

@end
