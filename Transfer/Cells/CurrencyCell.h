//
//  CurrencyCell.h
//  Transfer
//
//  Created by Mats Trovik on 23/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Currency;

@interface CurrencyCell : UICollectionViewCell

-(void)configureWithCurrency:(Currency*)currency;

@end
