//
//  PendingPayment+ColoredButton.h
//  Transfer
//
//  Created by Mats Trovik on 11/03/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "PendingPayment.h"

@class ColoredButton;


@interface PendingPayment (ColoredButton)

-(void)addProgressAnimationToButton:(ColoredButton*)button;

@end
