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
@class SelectionCell;
@class Country;
@class DoubleEntryCell;

typedef void (^ProfileActionBlock)(NSError *error);
typedef void (^SelectionCompletion)();

@interface ProfileSource : NSObject

@property (nonatomic, strong) NSArray *tableViews;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) NSArray *cells;

@property (nonatomic, strong) SelectionCell *stateCell;
@property (nonatomic, strong) SelectionCell *countryCell;
@property (nonatomic, strong) DoubleEntryCell *zipCityCell;


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
- (TextEntryCell *)includeCell:(TextEntryCell *)includeCell
					 afterCell:(UITableViewCell *)afterCell
				 shouldInclude:(BOOL)shouldInclude
				withCompletion:(SelectionCompletion)completion;
- (TextEntryCell *)includeStateCell:(BOOL)shouldInclude
					 withCompletion:(SelectionCompletion)completion;
- (void)markCellsWithIssues:(NSArray *)issues;
- (void)setUpTableView:(UITableView *)tableView;
- (TextEntryCell *)countrySelectionCell:(SelectionCell *)cell
					   didSelectCountry:(Country *)country
						 withCompletion:(SelectionCompletion)completion;
- (void)clearData;
+ (BOOL)showStateCell:(NSString *)countryCode;
+ (BOOL)isMatchingSource:(NSString *)source
			  withTarget:(NSString *)target;
+ (BOOL)showAcnAndAbnCells:(NSString *)countryCode;
+ (BOOL)showArbnCell:(NSString *)targetCurrency;

@end
