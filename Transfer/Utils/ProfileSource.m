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
#import "Country.h"

@implementation ProfileSource

- (NSArray *)presentedCells:(BOOL)allowProfileSwitch
				 isExisting:(BOOL)isExisting
{
    ABSTRACT_METHOD;
    return @[];
}

- (NSArray *)presentedLoginCells
{
	ABSTRACT_METHOD;
	return@[];
}

- (void)pullDetailsWithHandler:(ProfileActionBlock)handler
{
    MCAssert(self.objectModel);

    if (![Credentials userLoggedIn])
	{
        [self loadDetailsToCells];
        handler(nil);
        return;
    }

    __weak typeof(self) weakSelf = self;
    [[TransferwiseClient sharedClient] updateUserDetailsWithCompletionHandler:^(NSError *userError) {
        dispatch_async(dispatch_get_main_queue(), ^{
            if (userError)
			{
                handler(userError);
                return;
            }

            [weakSelf loadDetailsToCells];
            handler(nil);
        });
    }];
}

- (void)loadDataFromProfile:(PhoneBookProfile *)profile
{
    ABSTRACT_METHOD;
}

- (BOOL)inputValid
{
    ABSTRACT_METHOD;
    return NO;
}

- (id)enteredProfile
{
    ABSTRACT_METHOD;
    return nil;
}

- (void)validateProfile:(id)profile withValidation:(id)validation completion:(ProfileActionBlock)completion
{
    ABSTRACT_METHOD;
}

- (void)loadDetailsToCells
{
    ABSTRACT_METHOD;
}

- (void)fillQuickValidation:(QuickProfileValidationOperation *)operation
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
			for (UITableViewCell *cell in sectionCells)
			{
				if ([cell isKindOfClass:[TextEntryCell class]])
				{
					[(TextEntryCell *)cell markIssue:@""];
				}
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
			for (UITableViewCell *cell in sectionCells)
			{
				if ([cell isKindOfClass:[TextEntryCell class]])
				{
					TextEntryCell* entryCell = (TextEntryCell *)cell;
					
					if ([entryCell.cellTag isEqualToString:tag])
					{
						return entryCell;
					}
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

- (void)includeStateCell:(BOOL)shouldInclude
		  withCompletion:(CountrySelectionCompletion)completion
{
    UITableView* tableView;
    for(UITableView *table in self.tableViews)
    {
        if ([table indexPathForCell:self.countryCell])
        {
            tableView = table;
            break;
        }
    }
    
    NSMutableArray* addressFields;
	
	if(self.tableViews.count > 1)
	{
		addressFields = self.cells[1][0];
	}
	else
	{
		addressFields = self.cells[0][1];
	}
	
    if(shouldInclude && ![addressFields containsObject:self.stateCell])
    {
        [addressFields insertObject:self.stateCell atIndex:[addressFields indexOfObject:self.countryCell] + 1];
		
        NSIndexPath *indexPath = [tableView indexPathForCell:self.countryCell];
        if (indexPath)
        {
            indexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
			
			[self updateTableView:tableView
						   update:^{
							   [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
						   }
					   completion:completion];
        }
        
    }
    else if(!shouldInclude && [addressFields containsObject:self.stateCell])
    {
        [addressFields removeObject:self.stateCell];
        NSIndexPath *indexPath = [tableView indexPathForCell:self.stateCell];
        if (indexPath)
        {
			[self updateTableView:tableView
						   update:^{
							   [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
						   }
					   completion:completion];			
        }
    }
}

- (void)updateTableView:(UITableView *)tableView
				 update:(void (^)())update
			 completion:(CountrySelectionCompletion)completion
{
	[UIView animateWithDuration:0.5 animations:^{
		[tableView beginUpdates];
		update();
		[tableView reloadData];
		[tableView endUpdates];
		if (completion)
		{
			completion();
		}
	} completion:nil];
}

- (void)countrySelectionCell:(CountrySelectionCell *)cell
			didSelectCountry:(Country *)country
			  withCompletion:(CountrySelectionCompletion)completion
{
    [self includeStateCell:[ProfileSource showStateCell:country.iso3Code]
			withCompletion:completion];
}

+ (BOOL)showStateCell:(NSString *)countryCode
{
	return countryCode && [countryCode caseInsensitiveCompare:@"usa"] == NSOrderedSame;
}

@end
