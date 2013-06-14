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

@interface ProfileEditViewController : DataEntryViewController

@property (nonatomic, strong) NSString *footerButtonTitle;
@property (nonatomic, strong) id profileValidation;

- (id)initWithSource:(ProfileSource *)source;
- (void)setPresentProfileSource:(ProfileSource *)source reloadView:(BOOL)reload;

@end
