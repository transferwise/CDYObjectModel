//
//  PersonalProfileValidator.h
//  Transfer
//
//  Created by Juhan Hion on 15.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ProfileValidatorBase.h"
#import "PersonalProfileValidation.h"
#import "EmailValidation.h"

@interface PersonalProfileValidator : ProfileValidatorBase<PersonalProfileValidation>

- (id)init __attribute__((unavailable("init unavailable, use initWithEmailValidation")));
- (instancetype)initWithEmailValidation:(id<EmailValidation>)emailValidation;

@end
