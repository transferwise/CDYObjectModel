//
//  AchBankHelper.h
//  Transfer
//
//  Created by Juhan Hion on 11.02.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

@class AchBank;

#import <Foundation/Foundation.h>

@interface AchResponseParser : NSObject

- (id)init __attribute__((unavailable("init unavailable, use initWithResponse:")));
- (instancetype)initWithResponse:(NSDictionary *)response;

@property (readonly, nonatomic) BOOL hasStatus;
@property (readonly, nonatomic) BOOL isSuccessful;
@property (readonly, nonatomic) BOOL isLogin;
@property (readonly, nonatomic) BOOL isMfa;

@property (readonly, nonatomic) NSString* BankName;
@property (readonly, nonatomic) NSString* FieldType;
@property (readonly, nonatomic) NSDictionary* FieldGroups;
@property (readonly, nonatomic) NSString* VerifiableAccountId;
@property (readonly, nonatomic) NSString* ItemId;

+ (NSMutableDictionary *)initFormValues:(AchBank *)bank;

@end
