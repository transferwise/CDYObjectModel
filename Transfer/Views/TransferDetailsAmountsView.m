//
//  TransferDetailsAmountsView.m
//  Transfer
//
//  Created by Juhan Hion on 12.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferDetailsAmountsView.h"

@interface TransferDetailsAmountsView ()

@property (strong, nonatomic) IBOutlet UILabel* amountFromLabel;
@property (strong, nonatomic) IBOutlet UILabel* statusLabel;
@property (strong, nonatomic) IBOutlet UILabel* amountToLabel;
@property (strong, nonatomic) IBOutlet UILabel* shouldArriveLabel;
@property (strong, nonatomic) IBOutlet UILabel* etaLabel;

@end

@implementation TransferDetailsAmountsView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFromAmount:(NSString *)fromAmount
{
	[self.amountFromLabel setText:fromAmount];
}

- (void)setToAmount:(NSString *)toAmount
{
	[self.amountToLabel setText:toAmount];
}

- (void)setStatus:(NSString *)status
{
	[self.statusLabel setText:status];
}

- (void)setEta:(NSString *)eta
{
	[self.etaLabel setText:eta];
}

- (void)setShouldArrive:(NSString *)shouldArrive
{
	[self.shouldArriveLabel setText:shouldArrive];
}

@end
