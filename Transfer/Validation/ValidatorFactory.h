//
//  ValidatorFactory.h
//  Transfer
//
//  Created by Juhan Hion on 15.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectModel;

typedef NS_ENUM(short, ValidatorType)
{
	ValidateBusinessProfile = 1,
	ValidateEmail = 2,
	ValidatePayment = 3,
	ValidatePersonalProfile = 4,
	ValidateRecipientProfile = 5,
};

@interface ValidatorFactory : NSObject

- (id)init __attribute__((unavailable("init unavailable, use initWithObjectModel:")));
- (instancetype)initWithObjectModel:(ObjectModel *)objectModel;

- (id)getValidatorWithType:(ValidatorType)type;

@end
