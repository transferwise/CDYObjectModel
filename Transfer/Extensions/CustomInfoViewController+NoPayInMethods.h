//
//  CustomInfoViewController+NoPayInMethods.h
//  Transfer
//
//  Created by Mats Trovik on 09/01/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "CustomInfoViewController.h"

@class Currency;

@interface CustomInfoViewController (NoPayInMethods)

+(instancetype)failScreenNoPayInMethodsForCurrency:(Currency*)currency;

@end
