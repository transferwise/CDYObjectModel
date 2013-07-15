//
//  BusinessProfileSource.m
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfileSource.h"
#import "CountrySelectionCell.h"
#import "PlainProfileDetails.h"
#import "PlainBusinessProfile.h"
#import "NSString+Validation.h"
#import "PlainBusinessProfileInput.h"
#import "BusinessProfileValidation.h"
#import "PhoneBookProfile.h"
#import "PhoneBookAddress.h"
#import "User.h"
#import "ObjectModel+Users.h"
#import "BusinessProfile.h"

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
@property (nonatomic, strong) NSArray *cells;

@end

@implementation BusinessProfileSource

- (NSString *)editViewTitle {
    return NSLocalizedString(@"business.profile.controller.title", nil);
}

- (NSArray *)presentedCells {
    if (self.cells) {
        return self.cells;
    }

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

    [self setCells:@[businessCells, addressCells]];

    return self.cells;
}

- (void)loadDetailsToCells {
    User *user = [self.objectModel currentUser];
    BusinessProfile *profile = user.businessProfile;
    [self.businessNameCell setValue:profile.name];
    [self.registrationNumberCell setValue:profile.registrationNumber];
    [self.descriptionCell setValue:profile.businessDescription];
    [self.addressCell setValue:profile.addressFirstLine];
    [self.postCodeCell setValue:profile.postCode];
    [self.cityCell setValue:profile.city];
    [self.countryCell setValue:profile.countryCode];

    [self.businessNameCell setEditable:![profile isFieldReadonly:@"name"]];
    [self.registrationNumberCell setEditable:![profile isFieldReadonly:@"registrationNumber"]];
    [self.descriptionCell setEditable:![profile isFieldReadonly:@"description"]];

    [self.addressCell setEditable:![profile isFieldReadonly:@"addressFirstLine"]];
    [self.postCodeCell setEditable:![profile isFieldReadonly:@"postCode"]];
    [self.cityCell setEditable:![profile isFieldReadonly:@"city"]];
    [self.countryCell setEditable:![profile isFieldReadonly:@"countryCode"]];
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
    return [[self.businessNameCell value] hasValue] && [[self.registrationNumberCell value] hasValue]
            && [[self.descriptionCell value] hasValue] && [[self.addressCell value] hasValue]
            && [[self.postCodeCell value] hasValue] && [[self.cityCell value] hasValue]
            && [[self.countryCell value] hasValue];
}

- (id)enteredProfile {
    PlainBusinessProfileInput *data = [[PlainBusinessProfileInput alloc] init];
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
    [validation validateBusinessProfile:profile withHandler:^(PlainProfileDetails *details, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (error) {
                completion(error);
                return;
            }

            if (details) {
                [self loadDetailsToCells];
            }

            completion(nil);
        });
    }];
}

- (void)loadDataFromProfile:(PhoneBookProfile *)profile {
    [self.businessNameCell setValueWhenEditable:profile.organisation];

    PhoneBookAddress *address = profile.address;
    [self.addressCell setValueWhenEditable:address.street];
    [self.postCodeCell setValueWhenEditable:address.zipCode];
    [self.cityCell setValueWhenEditable:address.city];
    if (![self.objectModel.currentUser.businessProfile isFieldReadonly:@"countryCode"]) {
        [self.countryCell setTwoLetterCountryCode:address.countryCode];
    }
}

@end
