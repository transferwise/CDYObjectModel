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
#import "PlainProfileDetails.h"
#import "PhoneBookProfile.h"
#import "PhoneBookAddress.h"
#import "NSString+Validation.h"
#import "PersonalProfileValidation.h"
#import "User.h"
#import "ObjectModel+Users.h"
#import "PersonalProfile.h"

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

    TextEntryCell *phoneCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setPhoneNumberCell:phoneCell];
    [personalCells addObject:phoneCell];
    [phoneCell.entryField setKeyboardType:UIKeyboardTypePhonePad];
    [phoneCell addDoneButton];
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

- (void)loadDetailsToCells {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"loadDetailsToCells");
        User *user = [self.objectModel currentUser];
        PersonalProfile *profile = user.personalProfile;
        [self.firstNameCell setValue:profile.firstName];
        [self.lastNameCell setValue:profile.lastName];
        [self.emailCell setValue:user.email];
        [self.phoneNumberCell setValue:profile.phoneNumber];
        [self.dateOfBirthCell setValue:profile.dateOfBirth];
        [self.addressCell setValue:profile.addressFirstLine];
        [self.postCodeCell setValue:profile.postCode];
        [self.cityCell setValue:profile.city];
        [self.countryCell setValue:profile.countryCode];

        [self.firstNameCell setEditable:![profile isFieldReadonly:@"firstName"]];
        [self.lastNameCell setEditable:![profile isFieldReadonly:@"lastName"]];
        [self.dateOfBirthCell setEditable:![profile isFieldReadonly:@"dateOfBirth"]];
        [self.phoneNumberCell setEditable:![profile isFieldReadonly:@"phoneNumber"]];

        [self.addressCell setEditable:![profile isFieldReadonly:@"addressFirstLine"]];
        [self.postCodeCell setEditable:![profile isFieldReadonly:@"postCode"]];
        [self.cityCell setEditable:![profile isFieldReadonly:@"city"]];
        [self.countryCell setEditable:![profile isFieldReadonly:@"countryCode"]];
    });
}

- (void)loadDataFromProfile:(PhoneBookProfile *)profile {
    dispatch_async(dispatch_get_main_queue(), ^{
        MCLog(@"Did load:%@", profile);
        PersonalProfile *personal = self.objectModel.currentUser.personalProfile;

        [self.firstNameCell setValueWhenEditable:profile.firstName];
        [self.lastNameCell setValueWhenEditable:profile.lastName];
        [self.phoneNumberCell setValueWhenEditable:profile.phone];
        if (![personal isFieldReadonly:@"dateOfBirth"]) {
            [self.dateOfBirthCell setDateValue:profile.dateOfBirth];
        }

        self.emailCell.value = profile.email;

        PhoneBookAddress *address = profile.address;
        [self.addressCell setValueWhenEditable:address.street];
        [self.postCodeCell setValueWhenEditable:address.zipCode];
        [self.cityCell setValueWhenEditable:address.city];
        if (![personal isFieldReadonly:@"countryCode"]) {
            [self.countryCell setTwoLetterCountryCode:address.countryCode];
        }
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

    User *user = [self.objectModel currentUser];
    PersonalProfile *profile = [user personalProfileObject];

    [profile setFirstName:self.firstNameCell.value];
    [profile setLastName:self.lastNameCell.value];
    [user setEmail:self.emailCell.value];
    [profile setPhoneNumber:self.phoneNumberCell.value];
    [profile setAddressFirstLine:self.addressCell.value];
    [profile setPostCode:self.postCodeCell.value];
    [profile setCity:self.cityCell.value];
    [profile setCountryCode:self.countryCell.value];
    [profile setDateOfBirth:[self.dateOfBirthCell value]];
    [profile setChangedValue:changed];

    [self.objectModel saveContext];

    return profile.objectID;
}

- (BOOL)valuesChanged {
    User *user = self.objectModel.currentUser;
    PersonalProfile *profile = user.personalProfile;

    return ![[self.firstNameCell value] isEqualToString:profile.firstName]
            || ![[self.lastNameCell value] isEqualToString:profile.lastName]
            || ![[self.emailCell value] isEqualToString:user.email]
            || ![[self.phoneNumberCell value] isEqualToString:profile.phoneNumber]
            || ![[self.dateOfBirthCell value] isEqualToString:profile.dateOfBirth]
            || ![[self.addressCell value] isEqualToString:profile.addressFirstLine]
            || ![[self.postCodeCell value] isEqualToString:profile.postCode]
            || ![[self.cityCell value] isEqualToString:profile.city]
            || ![[self.countryCell value] isEqualToString:profile.countryCode];
}

- (void)validateProfile:(id)profile withValidation:(id)validation completion:(ProfileActionBlock)completion {
    [validation validatePersonalProfile:profile withHandler:^(PlainProfileDetails *details, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(error);
                return;
            }

            [self loadDetailsToCells];

            completion(nil);
        });
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
