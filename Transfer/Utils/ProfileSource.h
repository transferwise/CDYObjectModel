//
//  ProfileSource.h
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class PhoneBookProfile;
@class ObjectModel;
@class QuickProfileValidationOperation;
@class TextEntryCell;
@class CountrySelectionCell;
@class Country;

typedef void (^ProfileActionBlock)(NSError *error);
typedef void (^CountrySelectionCompletion)();

@interface ProfileSource : NSObject

@property (nonatomic, strong) NSArray *tableViews;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) NSArray *cells;

@property (nonatomic, strong) TextEntryCell *stateCell;
@property (nonatomic, strong) CountrySelectionCell *countryCell;


- (NSArray *)presentedCells:(BOOL)allowProfileSwitch
				 isExisting:(BOOL)isExisting;
- (NSArray *)presentedLoginCells;
- (void)pullDetailsWithHandler:(ProfileActionBlock)handler;
- (BOOL)inputValid;
- (id)enteredProfile;
- (void)validateProfile:(id)profile
		 withValidation:(id)validation
			 completion:(ProfileActionBlock)completion;
- (void)loadDetailsToCells;
- (void)fillQuickValidation:(QuickProfileValidationOperation *)operation;
- (TextEntryCell *)includeStateCell:(BOOL)shouldInclude
					 withCompletion:(CountrySelectionCompletion)completion;
- (void)markCellsWithIssues:(NSArray *)issues;
- (void)setUpTableView:(UITableView *)tableView;
- (TextEntryCell *)countrySelectionCell:(CountrySelectionCell *)cell
					   didSelectCountry:(Country *)country
						 withCompletion:(CountrySelectionCompletion)completion;

+ (BOOL)showStateCell:(NSString *)countryCode;

@end
