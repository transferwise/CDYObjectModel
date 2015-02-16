//
//  PersonalProfileSource.h
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ProfileSource.h"

@class State;

@interface PersonalProfileSource : ProfileSource

- (BOOL)isPasswordLengthValid;
- (BOOL)arePasswordsMatching;
- (BOOL)isValidDateOfBirth;
- (BOOL)isValidPhoneNumber;
- (TextEntryCell *)stateSelectionCell:(TextEntryCell *)cell
								state:(State *)state
					   withCompletion:(SelectionCompletion)completion;

@end
