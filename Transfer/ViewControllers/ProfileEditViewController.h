//
//  ProfileEditViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SuggestionDataEntryViewController.h"

@class ProfileSource;
@class PhoneBookProfileSelector;
@class ObjectModel;
@class CountriesOperation;
@class QuickProfileValidationOperation;

@interface ProfileEditViewController : SuggestionDataEntryViewController

@property (nonatomic, strong) id profileValidation;
@property (nonatomic, strong) ObjectModel *objectModel;

- (id)initWithSource:(ProfileSource *)source quickValidation:(QuickProfileValidationOperation *)quickValidation;

- (void)validateProfile;

@end
