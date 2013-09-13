//
//  PaymentMethodSelectionView.h
//  Transfer
//
//  Created by Jaanus Siim on 9/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void (^PaymentMethodChangeBlock)(NSInteger selectedIndex);

@interface PaymentMethodSelectionView : UIView

@property (nonatomic, copy) PaymentMethodChangeBlock segmentChangeHandler;

- (void)setTitles:(NSArray *)titles;

@end
