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

typedef void (^ProfileActionBlock)(NSError *error);

@interface ProfileSource : NSObject

@property (nonatomic, strong) NSArray *tableViews;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) NSArray *cells;

@property (nonatomic, strong) TextEntryCell *stateCell;
@property (nonatomic, strong) CountrySelectionCell *countryCell;


- (NSArray *)presentedCells:(BOOL)allowProfileSwitch;
- (NSArray *)presentedLoginCells;
- (void)pullDetailsWithHandler:(ProfileActionBlock)handler;
- (BOOL)inputValid;
- (id)enteredProfile;
- (void)validateProfile:(id)profile withValidation:(id)validation completion:(ProfileActionBlock)completion;
- (void)loadDetailsToCells;
- (void)fillQuickValidation:(QuickProfileValidationOperation *)operation;
- (void)includeStateCell:(BOOL)shouldInclude;
- (void)markCellsWithIssues:(NSArray *)issues;
- (void)setUpTableView:(UITableView *)tableView;

@end
