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
- (void)commitProfile;
- (void)validateProfileWithValidation:(id)validation
						   completion:(ProfileActionBlock)completion;
- (void)loadDetailsToCells;
- (void)fillQuickValidation:(QuickProfileValidationOperation *)operation;

- (void)markCellsWithIssues:(NSArray *)issues;
- (void)setUpTableView:(UITableView *)tableView;
- (NSArray *)countrySelectionCell:(SelectionCell *)cell
				 didSelectCountry:(Country *)country
				   withCompletion:(SelectionCompletion)completion;
- (void)clearData;

@end
