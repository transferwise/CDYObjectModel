//
//  ProfileEditViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SuggestionDataEntryViewController.h"
#import "Constants.h"

@class ProfileSource;
@class ObjectModel;
@class QuickProfileValidationOperation;

@protocol ProfileEditViewControllerDelegate <NSObject>

- (void)changeActionButtonTitle:(NSString *)title andAction:(TRWActionBlock)action;

@end

@interface ProfileEditViewController : SuggestionDataEntryViewController

@property (nonatomic, weak) id<ProfileEditViewControllerDelegate> delegate;
@property (nonatomic, strong) id profileValidation;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic) BOOL allowProfileSwitch;
@property (nonatomic) BOOL isExisting;
@property (nonatomic) BOOL doNotShowSuccessMessageForExisting;
@property (nonatomic) BOOL showFooterViewForIpad;

- (id)initWithSource:(ProfileSource *)source
	 quickValidation:(QuickProfileValidationOperation *)quickValidation;
- (id)initWithSource:(ProfileSource *)source
	 quickValidation:(QuickProfileValidationOperation *)quickValidation
		 buttonTitle:(NSString *)buttonTitle;

- (void)validateProfile;

@end
