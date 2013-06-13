//
//  BusinessProfileSource.m
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfileSource.h"
#import "CountrySelectionCell.h"
#import "ProfileDetails.h"
#import "TransferwiseClient.h"
#import "BusinessProfile.h"
#import "NSString+Validation.h"
#import "BusinessProfileInput.h"
#import "BusinessProfileValidation.h"
#import "PhoneBookProfile.h"
#import "PhoneBookAddress.h"

static NSUInteger const kButtonSection = 0;
static NSUInteger const kDetailsSection = 1;

@interface BusinessProfileSource ()

@property (nonatomic, strong) TextEntryCell *businessNameCell;
@property (nonatomic, strong) TextEntryCell *registrationNumberCell;
@property (nonatomic, strong) TextEntryCell *descriptionCell;
@property (nonatomic, strong) TextEntryCell *addressCell;
@property (nonatomic, strong) TextEntryCell *postCodeCell;
@property (nonatomic, strong) TextEntryCell *cityCell;
@property (nonatomic, strong) CountrySelectionCell *countryCell;

@property (nonatomic, strong) ProfileDetails *userDetails;
@end

@implementation BusinessProfileSource

- (NSString *)editViewTitle {
    return NSLocalizedString(@"business.profile.controller.title", nil);
}

- (NSArray *)presentedCells {
    [self.tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [self.tableView registerNib:[UINib nibWithNibName:@"CountrySelectionCell" bundle:nil] forCellReuseIdentifier:TWCountrySelectionCellIdentifier];

    NSMutableArray *businessCells = [NSMutableArray array];

    TextEntryCell *businessNameCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setBusinessNameCell:businessNameCell];
    [businessCells addObject:businessNameCell];
    [businessNameCell configureWithTitle:NSLocalizedString(@"business.profile.name.label", nil) value:@""];
    [businessNameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];

    TextEntryCell *registrationNumberCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setRegistrationNumberCell:registrationNumberCell];
    [businessCells addObject:registrationNumberCell];
    [registrationNumberCell configureWithTitle:NSLocalizedString(@"business.profile.registration.number.label", nil) value:@""];

    TextEntryCell *descriptionCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setDescriptionCell:descriptionCell];
    [businessCells addObject:descriptionCell];
    [descriptionCell configureWithTitle:NSLocalizedString(@"business.profile.description.label", nil) value:@""];
    [descriptionCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];

    NSMutableArray *addressCells = [NSMutableArray array];

    TextEntryCell *addressCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setAddressCell:addressCell];
    [addressCells addObject:addressCell];
    [addressCell configureWithTitle:NSLocalizedString(@"business.profile.address.label", nil) value:@""];
    [addressCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];

    TextEntryCell *postCodeCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setPostCodeCell:postCodeCell];
    [addressCells addObject:postCodeCell];
    [postCodeCell configureWithTitle:NSLocalizedString(@"business.profile.post.code.label", nil) value:@""];

    TextEntryCell *cityCell = [self.tableView dequeueReusableCellWithIdentifier:TWTextEntryCellIdentifier];
    [self setCityCell:cityCell];
    [addressCells addObject:cityCell];
    [cityCell configureWithTitle:NSLocalizedString(@"business.profile.city.label", nil) value:@""];
    [cityCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];

    CountrySelectionCell *countryCell = [self.tableView dequeueReusableCellWithIdentifier:TWCountrySelectionCellIdentifier];
    [self setCountryCell:countryCell];
    [addressCells addObject:countryCell];
    [countryCell configureWithTitle:NSLocalizedString(@"business.profile.country.label", nil) value:@""];

    return @[businessCells, addressCells];
}


- (void)pullDetailsWithHandler:(ProfileActionBlock)handler {
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
    BusinessProfile *profile = self.userDetails.businessProfile;
    [self.businessNameCell setValue:profile.businessName];
    [self.registrationNumberCell setValue:profile.registrationNumber];
    [self.descriptionCell setValue:profile.descriptionOfBusiness];
    [self.addressCell setValue:profile.addressFirstLine];
    [self.postCodeCell setValue:profile.postCode];
    [self.cityCell setValue:profile.city];
    [self.countryCell setValue:profile.countryCode];

    [self.businessNameCell setEditable:![profile businessVerifiedValue]];
    [self.registrationNumberCell setEditable:![profile businessVerifiedValue]];
    [self.descriptionCell setEditable:![profile businessVerifiedValue]];

    [self.addressCell setEditable:![profile businessVerifiedValue]];
    [self.postCodeCell setEditable:![profile businessVerifiedValue]];
    [self.cityCell setEditable:![profile businessVerifiedValue]];
    [self.countryCell setEditable:![profile businessVerifiedValue]];
}

- (NSString *)titleForHeaderInSection:(NSInteger)section {
    if (section == kButtonSection) {
        return nil;
    }

    if (section == kDetailsSection) {
        return NSLocalizedString(@"business.profile.details.section.title", nil);
    } else {
        return NSLocalizedString(@"business.profile.address.section.title", nil);
    }
}

- (BOOL)inputValid {
    return [[self.businessNameCell value] hasValue] && [[self.registrationNumberCell value] hasValue] && [[self.descriptionCell value] hasValue]
            && [[self.addressCell value] hasValue] && [[self.postCodeCell value] hasValue] && [[self.cityCell value] hasValue]
            && [[self.countryCell value] hasValue];
}

- (id)enteredProfile {
    BusinessProfileInput *data = [[BusinessProfileInput alloc] init];
    data.businessName = [self.businessNameCell value];
    data.registrationNumber = [self.registrationNumberCell value];
    data.descriptionOfBusiness = [self.descriptionCell value];
    data.addressFirstLine = [self.addressCell value];
    data.postCode = [self.postCodeCell value];
    data.city = [self.cityCell value];
    data.countryCode = [self.countryCell value];

    return data;
}

- (void)validateProfile:(id)profile withValidation:(id)validation completion:(ProfileActionBlock)completion {
    [validation validateBusinessProfile:profile withHandler:^(ProfileDetails *details, NSError *error) {
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

- (void)loadDataFromProfile:(PhoneBookProfile *)profile {
    self.businessNameCell.value = profile.organisation;

    PhoneBookAddress *address = profile.address;
    self.addressCell.value = address.street;
    self.postCodeCell.value = address.zipCode;
    self.cityCell.value = address.city;
    [self.countryCell setTwoLetterCountryCode:address.countryCode];
}

@end
