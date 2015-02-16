//
//  BusinessProfileSource.m
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "BusinessProfileSource.h"
#import "SelectionCell.h"
#import "NSString+Validation.h"
#import "BusinessProfileValidation.h"
#import "User.h"
#import "ObjectModel+Users.h"
#import "BusinessProfile.h"
#import "QuickProfileValidationOperation.h"
#import "GoogleAnalytics.h"
#import "UIView+Loading.h"
#import "Country.h"
#import "DoubleEntryCell.h"
#import "DoublePasswordEntryCell.h"
#import "StateSuggestionCellProvider.h"

@interface BusinessProfileSource ()

@property (nonatomic, strong) TextEntryCell *businessNameCell;
@property (nonatomic, strong) TextEntryCell *registrationNumberCell;
@property (nonatomic, strong) TextEntryCell *descriptionCell;
@property (nonatomic, strong) TextEntryCell *addressCell;

@end

@implementation BusinessProfileSource

- (NSString *)editViewTitle
{
    return NSLocalizedString(@"business.profile.controller.title", nil);
}

- (NSArray *)presentedCells:(BOOL)allowProfileSwitch
				 isExisting:(BOOL)isExisting
{
    if (self.cells)
	{
        return self.cells;
    }

    for (UITableView* tableView in self.tableViews)
    {
        [self setUpTableView:tableView];
    }

    NSMutableArray *firstColumnCells = [NSMutableArray array];

    TextEntryCell *businessNameCell = [TextEntryCell loadInstance];
    [self setBusinessNameCell:businessNameCell];
    [firstColumnCells addObject:businessNameCell];
    [businessNameCell configureWithTitle:NSLocalizedString(@"business.profile.name.label", nil) value:@""];
    [businessNameCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [businessNameCell setCellTag:@"businessName"];

    TextEntryCell *registrationNumberCell = [TextEntryCell loadInstance];
    [self setRegistrationNumberCell:registrationNumberCell];
    [firstColumnCells addObject:registrationNumberCell];
    [registrationNumberCell configureWithTitle:NSLocalizedString(@"business.profile.registration.number.label", nil) value:@""];
    [registrationNumberCell setCellTag:@"registrationNumber"];

    TextEntryCell *descriptionCell = [TextEntryCell loadInstance];
    [self setDescriptionCell:descriptionCell];
    [firstColumnCells addObject:descriptionCell];
    [descriptionCell configureWithTitle:NSLocalizedString(@"business.profile.description.label", nil) value:@""];
    [descriptionCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [descriptionCell setCellTag:@"descriptionOfBusiness"];
	[descriptionCell.entryField setAutocorrectionType:UITextAutocorrectionTypeDefault];

    NSMutableArray *secondColumnCells = [NSMutableArray array];
	
	SelectionCell *countryCell = [SelectionCell loadInstance];
    [self setCountryCell:countryCell];
    [secondColumnCells addObject:countryCell];
    [countryCell configureWithTitle:NSLocalizedString(@"business.profile.country.label", nil) value:@""];
    [countryCell setCellTag:@"countryCode"];

    SelectionCell *stateCell = [SelectionCell loadInstance];
    [self setStateCell:stateCell];
    [stateCell configureWithTitle:NSLocalizedString(@"business.profile.state.label", nil) value:@""];
    [stateCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [stateCell setCellTag:@"state"];
    
    TextEntryCell *addressCell = [TextEntryCell loadInstance];
    [self setAddressCell:addressCell];
    [secondColumnCells addObject:addressCell];
    [addressCell configureWithTitle:NSLocalizedString(@"business.profile.address.label", nil) value:@""];
    [addressCell.entryField setAutocapitalizationType:UITextAutocapitalizationTypeWords];
    [addressCell setCellTag:@"addressFirstLine"];


    DoubleEntryCell *zipCityCell = [DoubleEntryCell loadInstance];
	[self setZipCityCell:zipCityCell];
    [secondColumnCells addObject:zipCityCell];
    [zipCityCell configureWithTitle:NSLocalizedString(@"profile.post.code.label", nil)
							  value:@""
						secondTitle:NSLocalizedString(@"business.profile.city.label", nil)
						secondValue:@""];
    [zipCityCell setCellTag:@"zipCity"];


	if (self.tableViews.count > 1)
	{
		[self setCells:@[
						 @[firstColumnCells],
						 @[secondColumnCells]
						 ]];
	}
	else
	{
		[self setCells:@[
						@[firstColumnCells, secondColumnCells]
						]];
	}

    return self.cells;
}

- (void)loadDetailsToCells
{
    User *user = [self.objectModel currentUser];
    BusinessProfile *profile = user.businessProfile;
    [self.businessNameCell setValue:profile.name];
    [self.registrationNumberCell setValue:profile.registrationNumber];
    [self.descriptionCell setValue:profile.businessDescription];
    [self.addressCell setValue:profile.addressFirstLine];
    [self.zipCityCell setValue:profile.postCode];
	[self.zipCityCell setSecondValue:profile.city];
    [self.countryCell setValue:profile.countryCode];
    [self.stateCell setValue:profile.state];

    [self.businessNameCell setEditable:![profile isFieldReadonly:@"name"]];
    [self.registrationNumberCell setEditable:![profile isFieldReadonly:@"registrationNumber"]];
    [self.descriptionCell setEditable:![profile isFieldReadonly:@"description"]];

    [self.addressCell setEditable:![profile isFieldReadonly:@"addressFirstLine"]];
    [self.zipCityCell setEditable:![profile isFieldReadonly:@"postCode"]];
	[self.zipCityCell setSecondEditable:![profile isFieldReadonly:@"postCode"]];
    [self.countryCell setEditable:![profile isFieldReadonly:@"countryCode"]];
    [self.stateCell setEditable:![profile isFieldReadonly:@"state"]];
	
    [self includeStateCell:[ProfileSource showStateCell:profile.countryCode]
			withCompletion:nil];
}

- (BOOL)inputValid
{
    return [[self.businessNameCell value] hasValue] && [[self.registrationNumberCell value] hasValue]
            && [[self.descriptionCell value] hasValue] && [[self.addressCell value] hasValue]
            && [[self.zipCityCell value] hasValue] && [[self.zipCityCell secondValue] hasValue]
            && [[self.countryCell value] hasValue] && (![ProfileSource showStateCell:self.countryCell.value] || [[self.stateCell value] hasValue]);
}

- (id)enteredProfile
{
	BusinessProfile *profile = [self.objectModel.currentUser businessProfileObject];
    [profile setName:[self.businessNameCell value]];
    [profile setRegistrationNumber:[self.registrationNumberCell value]];
    [profile setBusinessDescription:[self.descriptionCell value]];
    [profile setAddressFirstLine:[self.addressCell value]];
    [profile setPostCode:self.zipCityCell.value];
    [profile setCity:self.zipCityCell.secondValue];
    [profile setCountryCode:[self.countryCell value]];
    [profile setState:self.stateCell.value];

    [self.objectModel saveContext];

    return profile.objectID;
}

- (void)validateProfile:(id)profile withValidation:(id)validation completion:(ProfileActionBlock)completion
{
    [validation validateBusinessProfile:profile withHandler:^(NSError *error) {
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
    [operation setName:[self.businessNameCell value]];
    [operation setRegistrationNumber:[self.registrationNumberCell value]];
    [operation setBusinessDescription:[self.descriptionCell value]];
    [operation setAddressFirstLine:[self.addressCell value]];
    [operation setPostCode:[self.zipCityCell value]];
    [operation setCity:[self.zipCityCell secondValue]];
    [operation setCountryCode:[self.countryCell value]];
    [operation setState:[self.stateCell value]];
}

- (void)clearData
{
	[self.businessNameCell setValue:@""];
	[self.registrationNumberCell setValue:@""];
	[self.descriptionCell setValue:@""];
	[self.addressCell setValue:@""];
	[self.zipCityCell setValue:@""];
	[self.zipCityCell setSecondValue:@""];
	[self.countryCell setValue:@""];
	[self.stateCell setValue:@""];
}

@end
