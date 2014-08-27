//
//  BusinessProfileSource.m
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfileSource.h"
#import "CountrySelectionCell.h"
#import "NSString+Validation.h"
#import "BusinessProfileValidation.h"
#import "PhoneBookProfile.h"
#import "PhoneBookAddress.h"
#import "User.h"
#import "ObjectModel+Users.h"
#import "BusinessProfile.h"
#import "QuickProfileValidationOperation.h"
#import "GoogleAnalytics.h"
#import "UIView+Loading.h"
#import "Country.h"

static NSUInteger const kButtonSection = 0;
static NSUInteger const kDetailsSection = 1;

@interface BusinessProfileSource ()<CountrySelectionCellDelegate>

@property (nonatomic, strong) TextEntryCell *businessNameCell;
@property (nonatomic, strong) TextEntryCell *registrationNumberCell;
@property (nonatomic, strong) TextEntryCell *descriptionCell;
@property (nonatomic, strong) TextEntryCell *addressCell;
@property (nonatomic, strong) TextEntryCell *postCodeCell;
@property (nonatomic, strong) TextEntryCell *cityCell;
@property (nonatomic, strong) CountrySelectionCell *countryCell;
@property (nonatomic, strong) TextEntryCell *stateCell;

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

    TextEntryCell *businessNameCell = [TextEntryCell loadInstance];
    [self setBusinessNameCell:businessNameCell];
    [businessCells addObject:businessNameCell];
    [businessNameCell configureWithTitle:NSLocalizedString(@"business.profile.name.label", nil) value:@""];
    [businessNameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [businessNameCell setCellTag:@"businessName"];

    TextEntryCell *registrationNumberCell = [TextEntryCell loadInstance];
    [self setRegistrationNumberCell:registrationNumberCell];
    [businessCells addObject:registrationNumberCell];
    [registrationNumberCell configureWithTitle:NSLocalizedString(@"business.profile.registration.number.label", nil) value:@""];
    [registrationNumberCell setCellTag:@"registrationNumber"];

    TextEntryCell *descriptionCell = [TextEntryCell loadInstance];
    [self setDescriptionCell:descriptionCell];
    [businessCells addObject:descriptionCell];
    [descriptionCell configureWithTitle:NSLocalizedString(@"business.profile.description.label", nil) value:@""];
    [descriptionCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [descriptionCell setCellTag:@"descriptionOfBusiness"];
	[descriptionCell.entryField setAutocorrectionType:UITextAutocorrectionTypeDefault];

    NSMutableArray *addressCells = [NSMutableArray array];

    TextEntryCell *addressCell = [TextEntryCell loadInstance];
    [self setAddressCell:addressCell];
    [addressCells addObject:addressCell];
    [addressCell configureWithTitle:NSLocalizedString(@"business.profile.address.label", nil) value:@""];
    [addressCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [addressCell setCellTag:@"addressFirstLine"];

    TextEntryCell *postCodeCell = [TextEntryCell loadInstance];
    [self setPostCodeCell:postCodeCell];
    [addressCells addObject:postCodeCell];
    [postCodeCell configureWithTitle:NSLocalizedString(@"business.profile.post.code.label", nil) value:@""];
    [postCodeCell setCellTag:@"postCode"];

    TextEntryCell *cityCell = [TextEntryCell loadInstance];
    [self setCityCell:cityCell];
    [addressCells addObject:cityCell];
    [cityCell configureWithTitle:NSLocalizedString(@"business.profile.city.label", nil) value:@""];
    [cityCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [cityCell setCellTag:@"city"];

    CountrySelectionCell *countryCell = [CountrySelectionCell loadInstance];
    [self setCountryCell:countryCell];
    [addressCells addObject:countryCell];
    [countryCell configureWithTitle:NSLocalizedString(@"business.profile.country.label", nil) value:@""];
    [countryCell setCellTag:@"countryCode"];
    countryCell.delegate = self;
    
    TextEntryCell *stateCell = [TextEntryCell loadInstance];
    [self setStateCell:stateCell];
    [addressCells addObject:stateCell];
    [stateCell configureWithTitle:NSLocalizedString(@"business.profile.state.label", nil) value:@""];
    [stateCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeSentences];
    [stateCell setCellTag:@"state"];

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
    [self.stateCell setValue:profile.state];

    [self.businessNameCell setEditable:![profile isFieldReadonly:@"name"]];
    [self.registrationNumberCell setEditable:![profile isFieldReadonly:@"registrationNumber"]];
    [self.descriptionCell setEditable:![profile isFieldReadonly:@"description"]];

    [self.addressCell setEditable:![profile isFieldReadonly:@"addressFirstLine"]];
    [self.postCodeCell setEditable:![profile isFieldReadonly:@"postCode"]];
    [self.cityCell setEditable:![profile isFieldReadonly:@"city"]];
    [self.countryCell setEditable:![profile isFieldReadonly:@"countryCode"]];
    [self.stateCell setEditable:![profile isFieldReadonly:@"state"]];
    [self includeStateCell:[@"usa" caseInsensitiveCompare:profile.countryCode]==NSOrderedSame];
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
	BusinessProfile *profile = [self.objectModel.currentUser businessProfileObject];
    [profile setName:[self.businessNameCell value]];
    [profile setRegistrationNumber:[self.registrationNumberCell value]];
    [profile setBusinessDescription:[self.descriptionCell value]];
    [profile setAddressFirstLine:[self.addressCell value]];
    [profile setPostCode:[self.postCodeCell value]];
    [profile setCity:[self.cityCell value]];
    [profile setCountryCode:[self.countryCell value]];
    [profile setState:[self.stateCell value]];

    [self.objectModel saveContext];

    return profile.objectID;
}

- (void)validateProfile:(id)profile withValidation:(id)validation completion:(ProfileActionBlock)completion {
    [validation validateBusinessProfile:profile withHandler:^(NSError *error) {
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

- (void)loadDataFromProfile:(PhoneBookProfile *)profile {
    [self.businessNameCell setValueWhenEditable:profile.organisation];

    PhoneBookAddress *address = profile.address;
    [self.addressCell setValueWhenEditable:address.street];
    [self.postCodeCell setValueWhenEditable:address.zipCode];
    [self.cityCell setValueWhenEditable:address.city];
    if (![self.objectModel.currentUser.businessProfile isFieldReadonly:@"countryCode"]) {
        [self.countryCell setTwoLetterCountryCode:address.countryCode];
    }
    [self.stateCell setValueWhenEditable:address.state];
    [self includeStateCell:[@"usa" caseInsensitiveCompare:self.countryCell.value]==NSOrderedSame];
}

- (void)fillQuickValidation:(QuickProfileValidationOperation *)operation {
    [operation setName:[self.businessNameCell value]];
    [operation setRegistrationNumber:[self.registrationNumberCell value]];
    [operation setBusinessDescription:[self.descriptionCell value]];
    [operation setAddressFirstLine:[self.addressCell value]];
    [operation setPostCode:[self.postCodeCell value]];
    [operation setCity:[self.cityCell value]];
    [operation setCountryCode:[self.countryCell value]];
    [operation setState:[self.stateCell value]];
}

-(void)includeStateCell:(BOOL)shouldInclude
{
    if (1 > [self.cells count])
    {
        return;
    }
    
    NSMutableArray* addressFields = self.cells[1];
    if(shouldInclude && ![addressFields containsObject:self.stateCell])
    {
        [addressFields addObject:self.stateCell];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:self.countryCell];
        if (indexPath)
        {
            indexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
            [self.tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
        
    }
    else if(!shouldInclude && [addressFields containsObject:self.stateCell])
    {
        [addressFields removeObject:self.stateCell];
        NSIndexPath *indexPath = [self.tableView indexPathForCell:self.stateCell];
        if (indexPath)
        {
            [self.tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
        }
    }
}


-(void)countrySelectionCell:(CountrySelectionCell *)cell selectedCountry:(Country *)country
{
    [self includeStateCell:([@"usa" caseInsensitiveCompare:country.iso3Code]==NSOrderedSame)];
}

@end
