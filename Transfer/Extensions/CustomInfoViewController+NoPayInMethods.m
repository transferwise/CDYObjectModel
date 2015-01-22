//
//  CustomInfoViewController+NoPayInMethods.m
//  Transfer
//
//  Created by Mats Trovik on 09/01/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "CustomInfoViewController+NoPayInMethods.h"
#import "NSString+Presentation.h"
#import "Currency.h"

@implementation CustomInfoViewController (NoPayInMethods)

+(instancetype)failScreenNoPayInMethodsForCurrency:(Currency*)currency
{
    NSString* message = [NSString stringWithFormat:NSLocalizedString(@"no.payin.methods.template", nil),[currency.code uppercaseString]];
    return [self failScreenWithMessage:message];
}


@end
