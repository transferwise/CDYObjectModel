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

typedef void (^ProfileActionBlock)(NSError *error);

@interface ProfileSource : NSObject

@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) NSArray *cells;

- (NSArray *)presentedCells;
- (NSString *)editViewTitle;
- (void)pullDetailsWithHandler:(ProfileActionBlock)handler;
- (void)loadDataFromProfile:(PhoneBookProfile *)profile;
- (BOOL)inputValid;
- (id)enteredProfile;
- (void)validateProfile:(id)profile withValidation:(id)validation completion:(ProfileActionBlock)completion;
- (NSString *)titleForHeaderInSection:(NSInteger)section;
- (void)loadDetailsToCells;
- (void)fillQuickValidation:(QuickProfileValidationOperation *)operation;
- (void)markCellsWithIssues:(NSArray *)issues;

@end
