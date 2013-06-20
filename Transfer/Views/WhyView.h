//
//  WhyAlertView.h
//  Transfer
//
//  Created by Henri Mägi on 19.04.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CalculationResult;

@interface WhyView : UIView

@property (nonatomic, strong) NSString *title;

- (void)setupWithResult:(CalculationResult*)result;

@end