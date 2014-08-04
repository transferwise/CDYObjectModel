//
//  ProfileSource.m
//  Transfer
//
//  Created by Jaanus Siim on 6/12/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ProfileSource.h"
#import "PhoneBookProfile.h"
#import "TransferwiseClient.h"
#import "Credentials.h"
#import "Constants.h"
#import "QuickProfileValidationOperation.h"
#import "TextEntryCell.h"
#import "DateEntryCell.h"
#import "DoubleEntryCell.h"
#import "DoublePasswordEntryCell.h"
#import "CountrySelectionCell.h"

@implementation ProfileSource

- (NSArray *)presentedCells {
    ABSTRACT_METHOD;
    return @[];
}

- (NSArray *)presentedLoginCells
{
	ABSTRACT_METHOD;
	return@[];
}

- (void)pullDetailsWithHandler:(ProfileActionBlock)handler {
    MCAssert(self.objectModel);

    if (![Credentials userLoggedIn]) {
        [self loadDetailsToCells];
        handler(nil);
        return;
    }

    __weak typeof(self) weakSelf = self;
    [[TransferwiseClient sharedClient] updateUserDetailsWithCompletionHandler:^(NSError *userError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (userError) {
                handler(userError);
                return;
            }

            [weakSelf loadDetailsToCells];
            handler(nil);
        });
    }];
}

- (void)loadDataFromProfile:(PhoneBookProfile *)profile {
    ABSTRACT_METHOD;
}

- (BOOL)inputValid {
    ABSTRACT_METHOD;
    return NO;
}

- (id)enteredProfile {
    ABSTRACT_METHOD;
    return nil;
}

- (void)validateProfile:(id)profile withValidation:(id)validation completion:(ProfileActionBlock)completion {
    ABSTRACT_METHOD;
}

- (void)loadDetailsToCells {
    ABSTRACT_METHOD;
}

- (void)fillQuickValidation:(QuickProfileValidationOperation *)operation {
    ABSTRACT_METHOD;
}

-(void)includeStateCell:(BOOL)shouldInclude;
{
    ABSTRACT_METHOD;
}

- (void)markCellsWithIssues:(NSArray *)issues {
    [self removeAllErrorMarkers];

    for (NSDictionary *issue in issues) {
        NSString *cellTag = issue[@"field"];
        TextEntryCell *cell = [self cellWithTag:cellTag];
        if (!cell) {
            continue;
        }

        [cell markIssue:issue[@"message"]];
    }
}

- (void)removeAllErrorMarkers
{
	for (NSArray *table in self.cells)
	{
		for (NSArray *sectionCells in table)
		{
			for (TextEntryCell *cell in sectionCells)
			{
				[cell markIssue:@""];
			}
		}
	}
}

- (TextEntryCell *)cellWithTag:(NSString *)tag
{
	for (NSArray *table in self.cells)
	{
		for (NSArray *sectionCells in table)
		{
			for (TextEntryCell *cell in sectionCells)
			{
				if ([cell.cellTag isEqualToString:tag])
				{
					return cell;
				}
			}
		}
	}

    return nil;
}

- (void)setUpTableView:(UITableView *)tableView
{
	[tableView registerNib:[UINib nibWithNibName:@"TextEntryCell" bundle:nil] forCellReuseIdentifier:TWTextEntryCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"DateEntryCell" bundle:nil] forCellReuseIdentifier:TWDateEntryCellIdentifier];
    [tableView registerNib:[UINib nibWithNibName:@"CountrySelectionCell" bundle:nil] forCellReuseIdentifier:TWCountrySelectionCellIdentifier];
	[tableView registerNib:[UINib nibWithNibName:@"DoublePasswordEntryCell" bundle:nil] forCellReuseIdentifier:TWDoublePasswordEntryCellIdentifier];
	[tableView registerNib:[UINib nibWithNibName:@"DoubleEntryCell" bundle:nil] forCellReuseIdentifier:TWDoubleEntryCellIdentifier];
	
	[tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

@end
