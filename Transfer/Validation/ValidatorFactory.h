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
	ValidatePersonalProfile = 3,
	ValidateRecipientProfile = 4
};

@interface ValidatorFactory : NSObject

- (id)init __attribute__((unavailable("init unavailable, use initWithObjectModel:")));
- (instancetype)initWithObjectModel:(ObjectModel *)objectModel;

- (id)getValidatorWithType:(ValidatorType)type;

@end
