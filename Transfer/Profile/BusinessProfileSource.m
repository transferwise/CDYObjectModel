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
#import "GoogleAnalytics.h"
#import "UIView+Loading.h"
#import "Country.h"
#import "DoubleEntryCell.h"
#import "DoublePasswordEntryCell.h"
#import "StateSuggestionCellProvider.h"
#import "DropdownCell.h"
#import "ProfileSource+Private.h"

@interface BusinessProfileSource ()

@property (nonatomic, strong) TextEntryCell *businessNameCell;
@property (nonatomic, strong) TextEntryCell *registrationNumberCell;
@property (nonatomic, strong) TextEntryCell *descriptionCell;
@property (nonatomic, strong) TextEntryCell *addressCell;
@property (nonatomic, strong) DropdownCell *companyRoleCell;
@property (nonatomic, strong) DropdownCell *companyTypeCell;
@property (nonatomic, strong) TextEntryCell *acnCell;
@property (nonatomic, strong) TextEntryCell *abnCell;
@property (nonatomic, strong) TextEntryCell *arbnCell;

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
	
	DropdownCell *companyRoleCell = [DropdownCell loadInstance];
	[self setCompanyRoleCell:companyRoleCell];
	[firstColumnCells addObject:companyRoleCell];
	[companyRoleCell configureWithTitle:NSLocalizedString(@"business.profile.company.role.title", nil) value:@""];
	[companyRoleCell setCellTag:@"companyRole"];
	
	DropdownCell *companyTypeCell = [DropdownCell loadInstance];
	[self setCompanyTypeCell:companyTypeCell];
	[firstColumnCells addObject:companyTypeCell];
	[companyTypeCell configureWithTitle:NSLocalizedString(@"business.profile.company.type.title", nil) value:@""];
	[companyTypeCell setCellTag:@"companyRole"];
	
	[self reloadDropDowns];
	
	TextEntryCell *acnCell = [TextEntryCell loadInstance];
	[self setAcnCell:acnCell];
	[acnCell configureWithTitle:NSLocalizedString(@"business.profile.au.acn", nil) value:@""];
	[acnCell setCellTag:@"acn"];
	
	TextEntryCell *abnCell = [TextEntryCell loadInstance];
	[self setAbnCell:abnCell];
	[abnCell configureWithTitle:NSLocalizedString(@"business.profile.au.abn", nil) value:@""];
	[abnCell setCellTag:@"abn"];
	
	TextEntryCell *arbnCell = [TextEntryCell loadInstance];
	[self setArbnCell:arbnCell];
	[arbnCell configureWithTitle:NSLocalizedString(@"business.profile.au.arbn", nil) value:@""];
	[arbnCell setCellTag:@"arbn"];

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
	[self.companyRoleCell setValue:profile.companyRole];
	[self.companyTypeCell setValue:profile.companyType];
    [self.addressCell setValue:profile.addressFirstLine];
    [self.zipCityCell setValue:profile.postCode];
	[self.zipCityCell setSecondValue:profile.city];
    [self.countryCell setValue:profile.countryCode];
    [self.stateCell setValue:profile.state];
	[self.abnCell setValue:profile.abn];
	[self.acnCell setValue:profile.acn];
	[self.arbnCell setValue:profile.arbn];

    [self.businessNameCell setEditable:![profile isFieldReadonly:@"name"]];
    [self.registrationNumberCell setEditable:![profile isFieldReadonly:@"registrationNumber"]];
    [self.descriptionCell setEditable:![profile isFieldReadonly:@"description"]];
	[self.companyRoleCell setEditable:![profile isFieldReadonly:@"companyRole"]];
	[self.companyTypeCell setEditable:![profile isFieldReadonly:@"copmanyType"]];
    [self.addressCell setEditable:![profile isFieldReadonly:@"addressFirstLine"]];
    [self.zipCityCell setEditable:![profile isFieldReadonly:@"postCode"]];
	[self.zipCityCell setSecondEditable:![profile isFieldReadonly:@"postCode"]];
    [self.countryCell setEditable:![profile isFieldReadonly:@"countryCode"]];
    [self.stateCell setEditable:![profile isFieldReadonly:@"state"]];
	[self.abnCell setEditable:![profile isFieldReadonly:@"abn"]];
	[self.acnCell setEditable:![profile isFieldReadonly:@"acn"]];
	[self.arbnCell setEditable:![profile isFieldReadonly:@"arbn"]];
	
    [self includeStateCell:[ProfileSource showStateCell:profile.countryCode]
			withCompletion:nil];
	[self includeAuCells:[BusinessProfileSource showAuCells:profile.countryCode]
				 withCompletion:nil];
}

- (BOOL)inputValid
{
    return [[self.businessNameCell value] hasValue] && [[self.registrationNumberCell value] hasValue]
            && [[self.descriptionCell value] hasValue] && [[self.companyRoleCell value] hasValue]
			&& [[self.companyTypeCell value] hasValue] && [[self.addressCell value] hasValue]
            && [[self.zipCityCell value] hasValue] && [[self.zipCityCell secondValue] hasValue]
            && [[self.countryCell value] hasValue] && (![ProfileSource showStateCell:self.countryCell.value] || [[self.stateCell value] hasValue]);
}

- (void)commitProfile
{
	BusinessProfile *profile = [self.objectModel.currentUser businessProfileObject];
    [profile setName:[self.businessNameCell value]];
    [profile setRegistrationNumber:[self.registrationNumberCell value]];
    [profile setBusinessDescription:[self.descriptionCell value]];
	[profile setCompanyRole:[self.companyRoleCell value]];
	[profile setCompanyType:[self.companyTypeCell value]];
    [profile setAddressFirstLine:[self.addressCell value]];
    [profile setPostCode:self.zipCityCell.value];
    [profile setCity:self.zipCityCell.secondValue];
    [profile setCountryCode:[self.countryCell value]];
    [profile setState:self.stateCell.value];
	[profile setAbn:self.abnCell.value];
	[profile setAcn:self.acnCell.value];
	[profile setArbn:self.arbnCell.value];

    [self.objectModel saveContext];

}

- (void)validateProfileWithValidation:(id)validation completion:(ProfileActionBlock)completion
{
    [validation validateBusinessProfile:^(NSError *error) {
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

- (void)clearData
{
	[self.businessNameCell setValue:@""];
	[self.registrationNumberCell setValue:@""];
	[self.descriptionCell setValue:@""];
	[self.companyRoleCell setValue:@""];
	[self.companyTypeCell setValue:@""];
	[self.addressCell setValue:@""];
	[self.zipCityCell setValue:@""];
	[self.zipCityCell setSecondValue:@""];
	[self.countryCell setValue:@""];
	[self.stateCell setValue:@""];
	[self.abnCell setValue:@""];
	[self.acnCell setValue:@""];
	[self.arbnCell setValue:@""];
}

- (void)reloadDropDowns
{
	if (self.companyRoleCell)
	{
		[self.companyRoleCell setAllElements:[self.objectModel fetchedControllerForAttributesOfType:CompanyRole]];
	}
	if (self.companyTypeCell)
	{		
		[self.companyTypeCell setAllElements:[self.objectModel fetchedControllerForAttributesOfType:CompanyType]];
	}
}

#pragma mark - AU specific cells
- (NSArray *)includeAuCells:(BOOL)shouldInclude
					withCompletion:(SelectionCompletion)completion
{
	[self includeCell:self.acnCell
			afterCell:self.zipCityCell
		shouldInclude:shouldInclude
	   withCompletion:completion];
	
	[self includeCell:self.abnCell
			afterCell:self.acnCell
		shouldInclude:shouldInclude
	   withCompletion:completion];
	
	[self includeCell:self.arbnCell
			afterCell:self.abnCell
		shouldInclude:shouldInclude
	   withCompletion:completion];
	
	if (shouldInclude)
	{
		return @[self.acnCell, self.abnCell];
	}
	
	return nil;
}

+ (BOOL)showAuCells:(NSString *)countryCode
{
	return [self isMatchingSource:@"aus"
					   withTarget:countryCode];
}

- (NSArray *)countrySelectionCell:(SelectionCell *)cell
					   didSelectCountry:(Country *)country
						 withCompletion:(SelectionCompletion)completion
{
	if ([BusinessProfileSource showAuCells:country.code])
	{
		return [self includeAuCells:[BusinessProfileSource showAuCells:country.code]
							withCompletion:nil];
	}
	else
	{
		return [super countrySelectionCell:cell
						  didSelectCountry:country
							withCompletion:completion];
	}
}

@end
