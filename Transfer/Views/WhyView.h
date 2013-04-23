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
@property (strong, nonatomic) IBOutlet UILabel *transferwiseRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *transferwiseTransferFeeLabel;
@property (strong, nonatomic) IBOutlet UILabel *transferwisePayOutLabel;
@property (strong, nonatomic) IBOutlet UILabel *bankRateLabel;
@property (strong, nonatomic) IBOutlet UILabel *bankTransferFeeLabel;
@property (strong, nonatomic) IBOutlet UILabel *bankPayOutLabel;

@property (nonatomic, strong) NSString *title;

- (void)setupWithResult:(CalculationResult*)result;

@end