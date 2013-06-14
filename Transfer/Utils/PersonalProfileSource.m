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
#import "TRWAlertView.h"
#import "ProfileDetails.h"
#import "TransferwiseClient.h"
#import "PersonalProfile.h"
#import "PhoneBookProfile.h"
#import "PhoneBookAddress.h"
#import "NSString+Validation.h"
#import "PersonalProfileInput.h"
#import "PersonalProfileValidation.h"
#import "Credentials.h"

NSUInteger const kUserButtonSection = 0;
NSUInteger const kUserPersonalSection = 1;

@interface PersonalProfileSource ()

@property (nonatomic, strong) TextEntryCell *firstNameCell;
@property (nonatomic, strong) TextEntryCell *lastNameCell;
@property (nonatomic, strong) TextEntryCell *emailCell;
@property (nonatomic, strong) TextEntryCell *phoneNumberCell;
@property (nonatomic, strong) DateEntryCell *dateOfBirthCell;
@property (nonatomic, strong) TextEntryCell *addressCell;
@property (nonatomic, strong) TextEntryCell *postCodeCell;
@property (nonatomic, strong) TextEntryCell *cityCell;
@property (nonatomic, strong) CountrySelectionCell *countryCell;
@property (nonatomic, strong) ProfileDetails *userDetails;
@property (nonatomic, strong) NSArray *cells;

@end

@implementation PersonalProfileSource

- (NSString *)editViewTitle {
    return NSLocalizedString(@"personal.profile.controller.title", nil);
}

- (NSArray *)presentedCells {
    if (self.cells) {
        return self.cells;
    }

    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"DateEntryCell" bundle:nil] forCellReuseIdentifier:TWDateEntryCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CountrySelectionCell" bundle:nil] forCellReuseIdentifier:TWCountrySelectionCellIdentifier];

    NSMutableArray *personalCells = [NSMutableArray array];

    TextEntryCell *firstNameCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setFirstNameCell:firstNameCell];
    [personalCells addObject:firstNameCell];
    [firstNameCell configureWithTitle:NSLocalizedString(@"personal.profile.first.name.label", nil) value:@""];
    [firstNameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];

    TextEntryCell *lastNameCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setLastNameCell:lastNameCell];
    [personalCells addObject:lastNameCell];
    [lastNameCell configureWithTitle:NSLocalizedString(@"personal.profile.last.name.label", nil) value:@""];
    [lastNameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];

    TextEntryCell *emailCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setEmailCell:emailCell];
    [personalCells addObject:emailCell];
    [emailCell configureWithTitle:NSLocalizedString(@"personal.profile.email.label", nil) value:@""];
    [emailCell.entryField setKeyboardType:UIKeyboardTypeEmailAddress];

    //TODO jaanus: phone pad with custom accessory view
    TextEntryCell *phoneCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setPhoneNumberCell:phoneCell];
    [personalCells addObject:phoneCell];
    [phoneCell configureWithTitle:NSLocalizedString(@"personal.profile.phone.label", nil) value:@""];

    DateEntryCell *dateOfBirthCell = [self.tableView dequeueReusableCellWithIdentifier:TWDateEntryCellIdentifier];
    [self setDateOfBirthCell:dateOfBirthCell];
    [personalCells addObject:dateOfBirthCell];
    [dateOfBirthCell configureWithTitle:NSLocalizedString(@"personal.profile.date.of.birth.label", nil) value:@""];

    NSMutableArray *addressCells = [NSMutableArray array];

    TextEntryCell *addressCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setAddressCell:addressCell];
    [addressCells addObject:addressCell];
    [addressCell configureWithTitle:NSLocalizedString(@"personal.profile.address.label", nil) value:@""];
    [addressCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];

    TextEntryCell *postCodeCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setPostCodeCell:postCodeCell];
    [addressCells addObject:postCodeCell];
    [postCodeCell configureWithTitle:NSLocalizedString(@"personal.profile.post.code.label", nil) value:@""];

    TextEntryCell *cityCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setCityCell:cityCell];
    [addressCells addObject:cityCell];
    [cityCell configureWithTitle:NSLocalizedString(@"personal.profile.city.label", nil) value:@""];
    [cityCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];

    CountrySelectionCell *countryCell = [self.tableView dequeueReusableCellWithIdentifier:TWCountrySelectionCellIdentifier];
    [self setCountryCell:countryCell];
    [addressCells addObject:countryCell];
    [countryCell configureWithTitle:NSLocalizedString(@"personal.profile.country.label", nil) value:@""];

    [self setCells:@[personalCells, addressCells]];

    return self.cells;
}

- (void)pullDetailsWithHandler:(ProfileActionBlock)handler {
    if (![Credentials userLoggedIn]) {
        handler(nil);
        return;
    }

    [[TransferwiseClient sharedClient] updateUserDetailsWithCompletionHandler:^(ProfileDetails *result, NSError *userError) {
        if (userError) {
            handler(userError);
            return;
        }

        [self setUserDetails:result];
        [self loadDetailsToCells];
        handler(nil);
    }];
}

- (void)loadDetailsToCells {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"loadDetailsToCells");
        PersonalProfile *profile = self.userDetails.personalProfile;
        [self.firstNameCell setValue:profile.firstName];
        [self.lastNameCell setValue:profile.lastName];
        [self.emailCell setValue:self.userDetails.email];
        [self.phoneNumberCell setValue:profile.phoneNumber];
        [self.dateOfBirthCell setValue:profile.dateOfBirthString];
        [self.addressCell setValue:profile.addressFirstLine];
        [self.postCodeCell setValue:profile.postCode];
        [self.cityCell setValue:profile.city];
        [self.countryCell setValue:profile.countryCode];

        [self.firstNameCell setEditable:![profile identityVerifiedValue]];
        [self.lastNameCell setEditable:![profile identityVerifiedValue]];
        [self.dateOfBirthCell setEditable:![profile identityVerifiedValue]];

        [self.addressCell setEditable:![profile addressVerifiedValue]];
        [self.postCodeCell setEditable:![profile addressVerifiedValue]];
        [self.cityCell setEditable:![profile addressVerifiedValue]];
        [self.countryCell setEditable:![profile addressVerifiedValue]];
    });
}

- (void)loadDataFromProfile:(PhoneBookProfile *)profile {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"Did load:%@", profile);
        self.firstNameCell.value = profile.firstName;
        self.lastNameCell.value = profile.lastName;
        self.emailCell.value = profile.email;
        self.phoneNumberCell.value = profile.phone;
        [self.dateOfBirthCell setDateValue:profile.dateOfBirth];

        PhoneBookAddress *address = profile.address;
        self.addressCell.value = address.street;
        self.postCodeCell.value = address.zipCode;
        self.cityCell.value = address.city;
        [self.countryCell setTwoLetterCountryCode:address.countryCode];
    });
}

- (BOOL)inputValid {
    return [[self.firstNameCell value] hasValue] && [[self.lastNameCell value] hasValue] && [[self.emailCell value] hasValue]
            && [[self.phoneNumberCell value] hasValue] && [[self.dateOfBirthCell value] hasValue]
            && [[self.addressCell value] hasValue] && [[self.postCodeCell value] hasValue] && [[self.cityCell value] hasValue]
            && [[self.countryCell value] hasValue];
}

- (id)enteredProfile {
    BOOL changed = [self valuesChanged];

    PersonalProfileInput *profile = [[PersonalProfileInput alloc] init];
    profile.firstName = self.firstNameCell.value;
    profile.lastName = self.lastNameCell.value;
    profile.email = self.emailCell.value;
    profile.phoneNumber = self.phoneNumberCell.value;
    profile.addressFirstLine = self.addressCell.value;
    profile.postCode = self.postCodeCell.value;
    profile.city = self.cityCell.value;
    profile.countryCode = self.countryCell.value;
    profile.dateOfBirthString = [self.dateOfBirthCell value];
    profile.changed = changed;

    return profile;
}

- (BOOL)valuesChanged {
    PersonalProfile *profile = self.userDetails.personalProfile;

    return ![[self.firstNameCell value] isEqualToString:profile.firstName]
            || ![[self.lastNameCell value] isEqualToString:profile.lastName]
            || ![[self.emailCell value] isEqualToString:self.userDetails.email]
            || ![[self.phoneNumberCell value] isEqualToString:profile.phoneNumber]
            || ![[self.dateOfBirthCell value] isEqualToString:profile.dateOfBirthString]
            || ![[self.addressCell value] isEqualToString:profile.addressFirstLine]
            || ![[self.postCodeCell value] isEqualToString:profile.postCode]
            || ![[self.cityCell value] isEqualToString:profile.city]
            || ![[self.countryCell value] isEqualToString:profile.countryCode];
}

- (void)validateProfile:(id)profile withValidation:(id)validation completion:(ProfileActionBlock)completion {
    [validation validatePersonalProfile:profile withHandler:^(ProfileDetails *details, NSError *error) {
        if (error) {
            completion(error);
            return;
        }

        if (details) {
            [self setUserDetails:details];
        }
        [self loadDetailsToCells];

        completion(nil);
    }];
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
    if (section == kUserButtonSection) {
        return nil;
    }

    if (section == kUserPersonalSection) {
        return NSLocalizedString(@"personal.profile.personal.section.title", nil);
    } else {
        return NSLocalizedString(@"personal.profile.address.section.title", nil);
    }
}

@end
