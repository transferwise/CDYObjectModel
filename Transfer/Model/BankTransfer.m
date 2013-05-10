//
//  BankTransfer.m
//  Transfer
//
//  Created by Henri Mägi on 10.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BankTransfer.h"

@interface BankTransfer ()

@property (nonatomic, strong) NSNumber* isIban;

@end

@implementation BankTransfer

+(BankTransfer *)initWithData:(NSDictionary *)data
{
    BankTransfer *transfer = [[BankTransfer alloc]init];
    
    return transfer;
}

-(BOOL)isIbanValue
{
    return [self.isIban boolValue];
}

@end
