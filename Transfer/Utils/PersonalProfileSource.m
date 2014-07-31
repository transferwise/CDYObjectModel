//
//  PersonalProfileSource.m
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PersonalProfileSource.h"
#import "CountrySelectionCell.h"
#import "DateEntryCell.h"
#import "PhoneBookProfile.h"
#import "PhoneBookAddress.h"
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

NSUInteger const kUserButtonSection = 0;
NSUInteger const kUserPersonalSection = 1;

@interface PersonalProfileSource ()

@property (nonatomic, strong) DoubleEntryCell *firstLastNameCell;
@property (nonatomic, strong) TextEntryCell *emailCell;
@property (nonatomic, strong) TextEntryCell *phoneNumberCell;
@property (nonatomic, strong) DateEntryCell *dateOfBirthCell;
@property (nonatomic, strong) TextEntryCell *addressCell;
@property (nonatomic, strong) DoubleEntryCell *zipCityCell;
@property (nonatomic, strong) CountrySelectionCell *countryCell;
@property (nonatomic, strong) DoublePasswordEntryCell *passwordCell;

@end

@implementation PersonalProfileSource

- (NSArray *)presentedCells
{
    if (self.cells)
	{
        return self.cells;
    }

    for (UITableView* tableView in self.tableViews)
    {
        [self setUpTableView:tableView];
    }

    NSMutableArray *personalCells = [NSMutableArray array];
	
	TextEntryCell *emailCell = [TextEntryCell loadInstance];
    [self setEmailCell:emailCell];
    [personalCells addObject:emailCell];
    [emailCell configureWithTitle:NSLocalizedString(@"personal.profile.email.label", nil) value:@""];
    [emailCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeNone];
    [emailCell.entryField setKeyboardType:UIKeyboardTypeEmailAddress];
	[emailCell setCellTag:@"EmailCell"];
	
	DoublePasswordEntryCell *passwordCell = [DoublePasswordEntryCell loadInstance];
	passwordCell.showDouble = YES;
	[passwordCell configureWithTitle:NSLocalizedString(@"personal.profile.password.label", nil) value:@""];
    [self setPasswordCell:passwordCell];
    [personalCells addObject:passwordCell];
	[passwordCell setCellTag:@"DoublePasswordCell"];
	
	DoubleEntryCell *firstLastNameCell = [DoubleEntryCell loadInstance];
	[self setFirstLastNameCell:firstLastNameCell];
	[personalCells addObject:firstLastNameCell];
	[firstLastNameCell configureWithTitle:NSLocalizedString(@"personal.profile.first.name.label", nil)
									value:@""
							  secondTitle:NSLocalizedString(@"personal.profile.last.name.label", nil)
							  secondValue:@""];
	[firstLastNameCell setCellTag:@"firstLastNameCell"];
	[firstLastNameCell setAutoCapitalization:UITextAutocapitalizationTypeWords];

    TextEntryCell *phoneCell = [TextEntryCell loadInstance];
    [self setPhoneNumberCell:phoneCell];
    [personalCells addObject:phoneCell];
    [phoneCell.entryField setKeyboardType:UIKeyboardTypeNumbersAndPunctuation];
    [phoneCell configureWithTitle:NSLocalizedString(@"personal.profile.phone.label", nil) value:@""];
    [phoneCell setCellTag:@"phoneNumber"];

    DateEntryCell *dateOfBirthCell = [DateEntryCell loadInstance];
    [self setDateOfBirthCell:dateOfBirthCell];
    [personalCells addObject:dateOfBirthCell];
    [dateOfBirthCell configureWithTitle:NSLocalizedString(@"personal.profile.date.of.birth.label", nil) value:@""];
    [dateOfBirthCell setCellTag:@"dateOfBirth"];
	
	NSMutableArray *addressCells = [NSMutableArray array];
	
	CountrySelectionCell *countryCell = [CountrySelectionCell loadInstance];
    [self setCountryCell:countryCell];
    [addressCells addObject:countryCell];
    [countryCell configureWithTitle:NSLocalizedString(@"personal.profile.country.label", nil) value:@""];
    [countryCell setCellTag:@"countryCode"];

    TextEntryCell *addressCell = [TextEntryCell loadInstance];
    [self setAddressCell:addressCell];
    [addressCells addObject:addressCell];
    [addressCell configureWithTitle:NSLocalizedString(@"personal.profile.address.label", nil) value:@""];
    [addressCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [addressCell setCellTag:@"addressFirstLine"];

	DoubleEntryCell *zipCityCell = [DoubleEntryCell loadInstance];
	[self setZipCityCell:zipCityCell];
    [addressCells addObject:zipCityCell];
    [zipCityCell configureWithTitle:NSLocalizedString(@"personal.profile.post.code.label", nil)
							  value:@""
						secondTitle:NSLocalizedString(@"personal.profile.city.label", nil)
						secondValue:@""];
    [zipCityCell setCellTag:@"zipCity"];

    [self setCells:@[@[personalCells, addressCells]]];

    return self.cells;
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
		[self.passwordCell setUseDummyPassword:YES];
        [self.phoneNumberCell setValue:profile.phoneNumber];
        [self.dateOfBirthCell setValue:profile.dateOfBirth];
        [self.addressCell setValue:profile.addressFirstLine];
        [self.zipCityCell setValue:profile.postCode];
        [self.zipCityCell setSecondValue:profile.city];
        [self.countryCell setValue:profile.countryCode];

        [self.firstLastNameCell setEditable:![profile isFieldReadonly:@"firstName"]];
        [self.firstLastNameCell setSecondEditable:![profile isFieldReadonly:@"lastName"]];
        [self.dateOfBirthCell setEditable:![profile isFieldReadonly:@"dateOfBirth"]];
        [self.phoneNumberCell setEditable:![profile isFieldReadonly:@"phoneNumber"]];
        [self.emailCell setEditable:![Credentials userLoggedIn]];

        [self.addressCell setEditable:![profile isFieldReadonly:@"addressFirstLine"]];
        [self.zipCityCell setEditable:![profile isFieldReadonly:@"postCode"]];
		[self.zipCityCell setSecondEditable:![profile isFieldReadonly:@"postCode"]];
        [self.countryCell setEditable:![profile isFieldReadonly:@"countryCode"]];
    });
}

- (void)loadDataFromProfile:(PhoneBookProfile *)profile
{
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"Did load:%@", profile);
        PersonalProfile *personal = self.objectModel.currentUser.personalProfile;

		if (![personal isFieldReadonly:@"firstName"])
		{
			[self.firstLastNameCell setValue:profile.firstName];
		}
		if (![personal isFieldReadonly:@"lastName"])
		{
			[self.firstLastNameCell setSecondValue:profile.lastName];
		}
		
        [self.phoneNumberCell setValueWhenEditable:profile.phone];
        if (![personal isFieldReadonly:@"dateOfBirth"]) {
            [self.dateOfBirthCell setDateValue:profile.dateOfBirth];
        }

        [self.emailCell setValueWhenEditable:profile.email];

        PhoneBookAddress *address = profile.address;
        [self.addressCell setValueWhenEditable:address.street];
		
		if (![personal isFieldReadonly:@"city"])
		{
			[self.zipCityCell setValue:address.zipCode];
		}
		if (![personal isFieldReadonly:@"postCode"])
		{
			[self.zipCityCell setSecondValue:address.city];
		}
        if (![personal isFieldReadonly:@"countryCode"])
		{
            [self.countryCell setTwoLetterCountryCode:address.countryCode];
        }
    });
}

- (BOOL)inputValid
{
    return [[self.firstLastNameCell value] hasValue] && [[self.firstLastNameCell secondValue] hasValue] && [[self.emailCell value] hasValue]
			&& [self isPasswordValid]
            && [[self.phoneNumberCell value] hasValue] && [[self.dateOfBirthCell value] hasValue]
            && [[self.addressCell value] hasValue] && [[self.zipCityCell value] hasValue] && [[self.zipCityCell secondValue] hasValue]
            && [[self.countryCell value] hasValue];
}

- (BOOL)isPasswordValid
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
    [profile setPhoneNumber:self.phoneNumberCell.value];
    [profile setAddressFirstLine:self.addressCell.value];
    [profile setPostCode:self.zipCityCell.value];
    [profile setCity:self.zipCityCell.secondValue];
    [profile setCountryCode:self.countryCell.value];
    [profile setDateOfBirth:[self.dateOfBirthCell value]];

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
}

- (void)setUpTableView:(UITableView *)tableView
{
	[tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"DateEntryCell" bundle:nil] forCellReuseIdentifier:TWDateEntryCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"CountrySelectionCell" bundle:nil] forCellReuseIdentifier:TWCountrySelectionCellIdentifier];
	[tableView registerNib:[UINib nibWithNibName:@"DoublePasswordEntryCell" bundle:nil] forCellReuseIdentifier:TWDoublePasswordEntryCellIdentifier];
	
	[tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

@end
