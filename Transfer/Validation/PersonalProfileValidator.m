//
//  PersonalProfileValidator.m
//  Transfer
//
//  Created by Juhan Hion on 15.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileValidator.h"
#import "PersonalProfileOperation.h"
#import "Credentials.h"
#import "NetworkErrorCodes.h"
#import "GoogleAnalytics.h"
#import "User.h"
#import "ObjectModel+Users.h"

@interface PersonalProfileValidator ()

@property (strong, nonatomic) id<EmailValidation> emailValidator;

@end

@implementation PersonalProfileValidator

- (instancetype)initWithEmailValidation:(id<EmailValidation>)emailValidation
{
	self = [super init];
	if (self)
	{
		self.emailValidator = emailValidation;
	}
	return self;
}

- (void)validatePersonalProfile:(NSManagedObjectID *)profile
					withHandler:(PersonalProfileValidationBlock)handler
{
	MCLog(@"validateProfile");
	PersonalProfileOperation *operation = [PersonalProfileOperation validateOperationWithProfile:profile];
	[self setExecutedOperation:operation];
	[operation setObjectModel:self.objectModel];
	
	__weak typeof(self) weakSelf = self;
	[operation setSaveResultHandler:^(NSError *error) {
		dispatch_async(dispatch_get_main_queue(), ^{
			if (error)
			{
				handler(error);
				return;
			}
			
			if ([Credentials userLoggedIn])
			{
				handler(nil);
				
				weakSelf.successBlock();
				return;
			}
			
			[weakSelf verifyEmail:self.objectModel.currentUser.email withHandler:handler];
		});
	}];
	
	[operation execute];
}

- (void)verifyEmail:(NSString *)email
		withHandler:(PersonalProfileValidationBlock)handler
{
	__weak typeof(self) weakSelf = self;
	[self.emailValidator verifyEmail:email withResultBlock:^(BOOL available, NSError *error) {
		if (error)
		{
			handler(error);
		}
		else if (!available)
		{
			[[GoogleAnalytics sharedInstance] sendAlertEvent:@"EmailTakenDuringPaymentAlert" withLabel:@""];
			//TODO: Replace with login screen showing
			NSError *emailError = [[NSError alloc] initWithDomain:TRWErrorDomain
															 code:ResponseLocalError
														 userInfo:@{NSLocalizedDescriptionKey: NSLocalizedString(@"personal.profile.email.taken.message", nil)}];
			handler(emailError);
		}
		else
		{
			handler(nil);
			weakSelf.successBlock();
		}
	}];
}

@end
