//
//  ProfileEditViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "DataEntryViewController.h"

@class ProfileSource;
@class PhoneBookProfileSelector;
@class ObjectModel;
@class CountriesOperation;
@class QuickProfileValidationOperation;

@interface ProfileEditViewController : DataEntryViewController

@property (nonatomic, strong) NSString *footerButtonTitle;
@property (nonatomic, strong) id profileValidation;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, assign) BOOL analyticsReport;

- (id)initWithSource:(ProfileSource *)source quickValidation:(QuickProfileValidationOperation *)quickValidation;

@end
