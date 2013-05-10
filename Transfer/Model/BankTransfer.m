//
//  BankTransfer.m
//  Transfer
//
//  Created by Henri Mägi on 10.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BankTransfer.h"

@implementation BankTransfer

+(BankTransfer *)initWithData:(NSDictionary *)data
{
    BankTransfer *transfer = [[BankTransfer alloc]init];
    
    return transfer;
}

@end
