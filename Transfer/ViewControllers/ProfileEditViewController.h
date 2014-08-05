//
//  ProfileEditViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SuggestionDataEntryViewController.h"

@class ProfileSource;
@class ObjectModel;
@class QuickProfileValidationOperation;

@interface ProfileEditViewController : SuggestionDataEntryViewController

@property (nonatomic, strong) id profileValidation;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic) BOOL allowProfileSwitch;

- (id)initWithSource:(ProfileSource *)source quickValidation:(QuickProfileValidationOperation *)quickValidation;

- (void)validateProfile;

@end
