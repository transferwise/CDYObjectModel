//
//  BankTransfer.h
//  Transfer
//
//  Created by Henri Mägi on 10.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BankTransfer : NSObject

@property (strong, nonatomic) NSString* amount;
@property (strong, nonatomic) NSString* iban;
@property (strong, nonatomic) NSString* accountNr;
@property (strong, nonatomic) NSString* bic;
@property (strong, nonatomic) NSString* bankName;
@property (strong, nonatomic) NSString* reference;
@property (strong, nonatomic) NSString* ukSort;

+(BankTransfer *)initWithData:(NSDictionary *)data;

-(BOOL)isIbanValue;

@end
