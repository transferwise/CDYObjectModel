//
//  PersonalProfileSource.m
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileSource.h"
#import "SelectionCell.h"
#import "DateEntryCell.h"
#import "NSString+Validation.h"
#import "PersonalProfileValidation.h"
#import "User.h"
#import "ObjectModel+Users.h"
#import "PersonalProfile.h"
#import "QuickProfileValidationOperation.h"
#import "Credentials.h"
#import "GoogleAnalytics.h"
#import "UIView+Loading.h"
#import "DoublePasswordEntryCell.h"
#import "DoubleEntryCell.h"
#import "Country.h"
#import "SwitchCell.h"
#import "StateSuggestionProvider.h"

#define MIN_PASSWORD_LENGTH	5

NSUInteger const kUserButtonSection = 0;
NSUInteger const kUserPersonalSection = 1;

@interface PersonalProfileSource ()

@property (nonatomic, strong) DoubleEntryCell *firstLastNameCell;
@property (nonatomic, strong) TextEntryCell *emailCell;
@property (nonatomic, strong) TextEntryCell *phoneNumberCell;
@property (nonatomic, strong) DateEntryCell *dateOfBirthCell;
@property (nonatomic, strong) TextEntryCell *addressCell;
@property (nonatomic, strong) DoublePasswordEntryCell *passwordCell;
@property (nonatomic, strong) NSArray *loginCells;
@property (nonatomic, strong) SwitchCell *sendAsBusinessCell;
@property (nonatomic, strong) TextEntryCell *occupationCell;
@property (nonatomic) BOOL allowProfileSwitch;

@end

@implementation PersonalProfileSource

- (NSArray *)presentedCells:(BOOL)allowProfileSwitch
				 isExisting:(BOOL)isExisting
{
	self.allowProfileSwitch = allowProfileSwitch;
	
    if (self.cells)
	{
		//this might have been changed to single
		self.passwordCell.showDouble = YES;
        return self.cells;
    }

    for (UITableView* tableView in self.tableViews)
    {
        [self setUpTableView:tableView];
    }

    NSMutableArray *personalDetailsCells = [NSMutableArray array];
	NSMutableArray *loginCells = [NSMutableArray array];
	
	TextEntryCell *emailCell = [TextEntryCell loadInstance];
	[self setEmailCell:emailCell];
	[emailCell configureWithTitle:NSLocalizedString(@"personal.profile.email.label", nil) value:@""];
	[emailCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
	[emailCell.entryField setKeyboardType:UIKeyboardTypeEmailAddress];
	[emailCell setCellTag:@"EmailCell"];
	
	if (!isExisting)
	{
		//we only need to show the email cell for new profiles
		[personalDetailsCells addObject:emailCell];
		[loginCells addObject:emailCell];
		
		DoublePasswordEntryCell *passwordCell = [DoublePasswordEntryCell loadInstance];
		passwordCell.showDouble = YES;
		passwordCell.useDummyPassword = NO;
		[passwordCell configureWithTitle:NSLocalizedString(@"personal.profile.password.label", nil) value:@""];
		[self setPasswordCell:passwordCell];
		[personalDetailsCells addObject:passwordCell];
		[passwordCell setCellTag:@"DoublePasswordCell"];
		[loginCells addObject:passwordCell];
	}
	
	DoubleEntryCell *firstLastNameCell = [DoubleEntryCell loadInstance];
	[self setFirstLastNameCell:firstLastNameCell];
	[personalDetailsCells addObject:firstLastNameCell];
	[firstLastNameCell configureWithTitle:NSLocalizedString(@"personal.profile.first.name.label", nil)
									value:@""
							  secondTitle:NSLocalizedString(@"personal.profile.last.name.label", nil)
							  secondValue:@""];
	[firstLastNameCell setCellTag:@"firstLastNameCell"];
	[firstLastNameCell setAutoCapitalization:UITextAutocapitalizationTypeWords];
	
	NSMutableArray *addressCells = [NSMutableArray array];
	
	SelectionCell *countryCell = [SelectionCell loadInstance];
    [self setCountryCell:countryCell];
    [addressCells addObject:countryCell];
    [countryCell configureWithTitle:NSLocalizedString(@"personal.profile.country.label", nil) value:@""];
    [countryCell setCellTag:@"countryCode"];
    
    SelectionCell *stateCell = [SelectionCell loadInstance];
    [self setStateCell:stateCell];
    [stateCell configureWithTitle:NSLocalizedString(@"personal.profile.state.label", nil) value:@""];
    [stateCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [stateCell setCellTag:@"state"];
	
	TextEntryCell *addressCell = [TextEntryCell loadInstance];
    [self setAddressCell:addressCell];
    [addressCells addObject:addressCell];
    [addressCell configureWithTitle:NSLocalizedString(@"personal.profile.address.label", nil) value:@""];
    [addressCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [addressCell setCellTag:@"addressFirstLine"];

	DoubleEntryCell *zipCityCell = [DoubleEntryCell loadInstance];
	[self setZipCityCell:zipCityCell];
    [addressCells addObject:zipCityCell];
    [zipCityCell configureWithTitle:NSLocalizedString(@"profile.post.code.label", nil)
							  value:@""
						secondTitle:NSLocalizedString(@"personal.profile.city.label", nil)
						secondValue:@""];
    [zipCityCell setCellTag:@"zipCity"];
	
	NSMutableArray *phoneDobCells = [NSMutableArray array];
    
	TextEntryCell *phoneCell = [TextEntryCell loadInstance];
    [self setPhoneNumberCell:phoneCell];
    [phoneDobCells addObject:phoneCell];
    [phoneCell.entryField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [phoneCell configureWithTitle:NSLocalizedString(@"personal.profile.phone.label", nil) value:@""];
    [phoneCell setCellTag:@"phoneNumber"];
	
    DateEntryCell *dateOfBirthCell = [DateEntryCell loadInstance];
    [self setDateOfBirthCell:dateOfBirthCell];
    [phoneDobCells addObject:dateOfBirthCell];
    [dateOfBirthCell configureWithTitle:NSLocalizedString(@"personal.profile.date.of.birth.label", nil) value:@""];
    [dateOfBirthCell setCellTag:@"dateOfBirth"];
	
	TextEntryCell *occupationCell = [TextEntryCell loadInstance];
	[self setOccupationCell:occupationCell];
	[occupationCell configureWithTitle:NSLocalizedString(@"personal.profile.occupation.label", nil) value:@""];
	[occupationCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
	[occupationCell setCellTag:@"occupation"];

	if (allowProfileSwitch)
	{
		SwitchCell *sendAsBusinessCell = [SwitchCell loadInstance];
		[self setSendAsBusinessCell:sendAsBusinessCell];
		if (self.tableViews.count > 1)
		{
			[addressCells addObject:sendAsBusinessCell];
		}
		else
		{
			[phoneDobCells addObject:sendAsBusinessCell];
		}
		[loginCells addObject:sendAsBusinessCell];
		[sendAsBusinessCell.titleLabel setText:NSLocalizedString(@"profile.selection.text.business.profile", nil)];
	}

	if (self.tableViews.count > 1)
	{
		[self setCells:@[
						 @[personalDetailsCells, phoneDobCells],
						 @[addressCells]
						 ]];
	}
	else
	{
		[self setCells:@[
						 @[personalDetailsCells, addressCells, phoneDobCells]
						 ]];
	}
	
	[self setLoginCells:@[
						  @[loginCells]
						  ]];
    return self.cells;
}

- (NSArray *)presentedLoginCells
{
	self.passwordCell.showDouble = NO;
	return self.loginCells;
}

- (void)loadDetailsToCells
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"loadDetailsToCells");
        User *user = [self.objectModel currentUser];
        PersonalProfile *profile = user.personalProfile;
        [self.firstLastNameCell setValue:profile.firstName];
        [self.firstLastNameCell setSecondValue:profile.lastName];
		[self.emailCell setValue:user.email];
		[self.passwordCell setUseDummyPassword:user && profile];
        [self.phoneNumberCell setValue:profile.phoneNumber];
        [self.dateOfBirthCell setValue:profile.dateOfBirth];
        [self.addressCell setValue:profile.addressFirstLine];
        [self.zipCityCell setValue:profile.postCode];
        [self.zipCityCell setSecondValue:profile.city];
        [self.countryCell setValue:profile.countryCode];
        [self.stateCell setValue:profile.state];
		[self.occupationCell setValue:profile.occupation];

        [self.firstLastNameCell setEditable:![profile isFieldReadonly:@"firstName"]];
        [self.firstLastNameCell setSecondEditable:![profile isFieldReadonly:@"lastName"]];
        [self.dateOfBirthCell setEditable:![profile isFieldReadonly:@"dateOfBirth"]];
        [self.phoneNumberCell setEditable:![profile isFieldReadonly:@"phoneNumber"]];
        [self.emailCell setEditable:![Credentials userLoggedIn]];

        [self.addressCell setEditable:![profile isFieldReadonly:@"addressFirstLine"]];
        [self.zipCityCell setEditable:![profile isFieldReadonly:@"postCode"]];
		[self.zipCityCell setSecondEditable:![profile isFieldReadonly:@"postCode"]];
        [self.countryCell setEditable:![profile isFieldReadonly:@"countryCode"]];
        [self.stateCell setEditable:![profile isFieldReadonly:@"state"]];
		
		[self includeStateCell:[ProfileSource showStateCell:profile.countryCode]
				withCompletion:nil];
		[self includeOccupationCell:[PersonalProfileSource showOccupationCell:profile.state]
					 withCompletion:nil];
    });
}


- (BOOL)inputValid
{
    return [[self.firstLastNameCell value] hasValue] && [[self.firstLastNameCell secondValue] hasValue]
			&& [[self.emailCell value] hasValue] && [[self.phoneNumberCell value] hasValue]
			&& [[self.dateOfBirthCell value] hasValue] && [[self.addressCell value] hasValue]
			&& [[self.zipCityCell value] hasValue] && [[self.zipCityCell secondValue] hasValue]
            && [[self.countryCell value] hasValue] && (![ProfileSource showStateCell:self.countryCell.value] || [[self.stateCell value] hasValue])
			&& (![PersonalProfileSource showOccupationCell:self.stateCell.value] || [[self.occupationCell value] hasValue]);
}

//this should be removed when API supports atomic account creation operation
- (BOOL)isPasswordLengthValid
{
	return self.passwordCell.useDummyPassword
		|| ([self.passwordCell.value hasValue]
		&& [self.passwordCell.value length] >= MIN_PASSWORD_LENGTH);
}

- (BOOL)arePasswordsMatching
{
	return self.passwordCell.useDummyPassword
	|| ([self.passwordCell.value hasValue]
		&& self.passwordCell.areMatching);
}

- (id)enteredProfile
{
    User *user = [self.objectModel currentUser];
    PersonalProfile *profile = [user personalProfileObject];

    [profile setFirstName:self.firstLastNameCell.value];
    [profile setLastName:self.firstLastNameCell.secondValue];
    [user setEmail:self.emailCell.value];
	[user setPassword:self.passwordCell.value];
    [profile setPhoneNumber:self.phoneNumberCell.value];
    [profile setAddressFirstLine:self.addressCell.value];
    [profile setPostCode:self.zipCityCell.value];
    [profile setCity:self.zipCityCell.secondValue];
    [profile setCountryCode:self.countryCell.value];
    [profile setDateOfBirth:[self.dateOfBirthCell value]];
    [profile setState:self.stateCell.value];
	[profile setOccupation:[self.occupationCell value]];

	
	if (self.allowProfileSwitch)
	{
		[profile setSendAsBusinessValue:[self.sendAsBusinessCell value]];
	}

    [self.objectModel saveContext];

    return profile.objectID;
}

- (void)validateProfile:(id)profile withValidation:(id)validation completion:(ProfileActionBlock)completion
{
    [validation validatePersonalProfile:profile withHandler:^(NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error)
			{
                completion(error);
                return;
            }

            [self loadDetailsToCells];

            completion(nil);
        });
    }];
}

- (void)fillQuickValidation:(QuickProfileValidationOperation *)operation
{
    [operation setFirstName:[self.firstLastNameCell value]];
    [operation setLastName:[self.firstLastNameCell secondValue]];
    [operation setPhoneNumber:[self.phoneNumberCell value]];
    [operation setAddressFirstLine:[self.addressCell value]];
    [operation setPostCode:[self.zipCityCell value]];
    [operation setCity:[self.zipCityCell secondValue]];
    [operation setCountryCode:[self.countryCell value]];
    [operation setDateOfBirth:[self.dateOfBirthCell value]];
    [operation setState:self.stateCell.value];
	[operation setOccupation:[self.occupationCell value]];
}

- (TextEntryCell *)includeOccupationCell:(BOOL)shouldInclude
						  withCompletion:(SelectionCompletion)completion
{
	return [self includeCell:self.occupationCell
				   afterCell:self.dateOfBirthCell
			   shouldInclude:shouldInclude
			  withCompletion:completion];
}

- (TextEntryCell *)stateSelectionCell:(TextEntryCell *)cell
								state:(State *)state
					   withCompletion:(SelectionCompletion)completion
{
	return [self includeOccupationCell:[PersonalProfileSource showOccupationCell:state.code]
						withCompletion:completion];
}

+ (BOOL)showOccupationCell:(NSString *)state
{
	return [PersonalProfileSource isMatchingSource:@"az"
										withTarget:state];
}

- (void)clearData
{
	[self.firstLastNameCell setValue:@""];
	[self.firstLastNameCell setSecondValue:@""];
	[self.emailCell setValue:@""];
	[self.passwordCell setUseDummyPassword:@""];
	[self.phoneNumberCell setValue:@""];
	[self.dateOfBirthCell setValue:@""];
	[self.addressCell setValue:@""];
	[self.zipCityCell setValue:@""];
	[self.zipCityCell setSecondValue:@""];
	[self.countryCell setValue:@""];
	[self.stateCell setValue:@""];
	[self.occupationCell setValue:@""];
}

@end
