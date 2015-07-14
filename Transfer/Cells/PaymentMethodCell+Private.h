//
//  PaymentMethodCell+Private.h
//  Transfer
//
//  Created by Juhan Hion on 14.07.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "PaymentMethodCell.h"

@interface PaymentMethodCell (Private)

@property (nonatomic, weak) NSString* method;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;

@end
