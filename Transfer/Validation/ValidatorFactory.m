//
//  ValidatorFactory.m
//  Transfer
//
//  Created by Juhan Hion on 15.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ValidatorFactory.h"
#import "BusinessProfileValidator.h"
#import "EmailValidator.h"
#import "PaymentValidator.h"
#import "PersonalProfileValidator.h"
#import "RecipientProfileValidator.h"

@interface ValidatorFactory ()

@property (strong, nonatomic) ObjectModel *objetModel;

@end

@implementation ValidatorFactory

- (instancetype)initWithObjectModel:(ObjectModel *)objectModel
{
	self = [super init];
	if (self)
	{
		self.objetModel = objectModel;
	}
	return self;
}

- (id)getValidatorWithType:(ValidatorType)type
{
	switch (type)
	{
		case ValidateBusinessProfile:
			return [self getBusinessProfileValidator];
			break;
		case ValidateEmail:
			return [[EmailValidator alloc] init];
			break;
		case ValidatePayment:
			return [self getPaymentValidator];
			break;
		case ValidatePersonalProfile:
			return [self getPersonalProfileValidator];
			break;
		case ValidateRecipientProfile:
			return [self getRecipientProfileValidator];
			break;
		default:
			return nil;
			break;
	}
}

- (BusinessProfileValidator *)getBusinessProfileValidator
{
	BusinessProfileValidator *validator = [[BusinessProfileValidator alloc] init];
	validator.objectModel = self.objetModel;
	return validator;
}

- (PaymentValidator *)getPaymentValidator
{
	PaymentValidator *validator = [[PaymentValidator alloc] init];
	validator.objectModel = self.objetModel;
	return validator;
}

- (PersonalProfileValidator *)getPersonalProfileValidator
{
	PersonalProfileValidator *validator = [[PersonalProfileValidator alloc] initWithEmailValidation:[self getValidatorWithType:ValidateEmail]];
	validator.objectModel = self.objetModel;
	return validator;
}

- (RecipientProfileValidator *)getRecipientProfileValidator
{
	RecipientProfileValidator *validator = [[RecipientProfileValidator alloc] init];
	validator.objectModel = self.objetModel;
	return validator;
}

@end
