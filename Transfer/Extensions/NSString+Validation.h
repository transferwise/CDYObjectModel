//
//  NSString+Validation.h
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

static NSInteger const kMaxAchRoutingLength = 9;
static NSInteger const kMinAchAccountLength = 4;
static NSInteger const kMaxAchAccountLength = 17;
static NSInteger const kMinPhoneNumberLength = 4;
static NSInteger const kMaxPhoneNumberLength = 255;

@interface NSString (Validation)

- (BOOL)hasValue;
- (BOOL)isValidEmail;
- (BOOL)isValidAchRoutingNumber;
- (BOOL)isValidAchAccountNumber;
- (BOOL)isValidPhoneNumber;

@end
