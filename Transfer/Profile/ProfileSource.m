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
#import "TextEntryCell.h"
#import "DateEntryCell.h"
#import "DoubleEntryCell.h"
#import "DoublePasswordEntryCell.h"
#import "SelectionCell.h"
#import "Country.h"
#import "DoubleEntryCell.h"

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

- (void)markCellsWithIssues:(NSArray *)issues
{
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
    [tableView registerNib:[UINib nibWithNibName:@"CountrySelectionCell" bundle:nil] forCellReuseIdentifier:TWSelectionCellIdentifier];
	[tableView registerNib:[UINib nibWithNibName:@"DoublePasswordEntryCell" bundle:nil] forCellReuseIdentifier:TWDoublePasswordEntryCellIdentifier];
	[tableView registerNib:[UINib nibWithNibName:@"DoubleEntryCell" bundle:nil] forCellReuseIdentifier:TWDoubleEntryCellIdentifier];
	
	[tableView setTableFooterView:[[UIView alloc] initWithFrame:CGRectZero]];
}

- (TextEntryCell *)includeStateCell:(BOOL)shouldInclude
					 withCompletion:(SelectionCompletion)completion
{
	TextEntryCell *result = [self includeCell:self.stateCell
									afterCell:self.countryCell
								shouldInclude:shouldInclude
							   withCompletion:completion];
	
	if (shouldInclude)
	{
		[self.zipCityCell setFirstTitle:NSLocalizedString(@"profile.post.code.usa.label", nil)];
	}
	else
	{
		[self.zipCityCell setFirstTitle:NSLocalizedString(@"profile.post.code.label", nil)];
	}
	
	return result;
}

- (TextEntryCell *)includeCell:(TextEntryCell *)includeCell
					 afterCell:(UITableViewCell *)afterCell
				 shouldInclude:(BOOL)shouldInclude
				withCompletion:(SelectionCompletion)completion
{
	UITableView* tableView;
	for(UITableView *table in self.tableViews)
	{
		if ([self getIndexPathForCell:afterCell inTableView:table])
		{
			tableView = table;
			break;
		}
	}
	
	NSMutableArray* fields = [self findContainingArrayForObject:afterCell
											 withArray:self.cells];
	if (!fields)
	{
		return nil;
	}
	
	if(shouldInclude && ![fields containsObject:includeCell])
	{
		[fields insertObject:includeCell atIndex:[fields indexOfObject:afterCell] + 1];
		
		NSIndexPath *indexPath = [self getIndexPathForCell:afterCell inTableView:tableView];
		if (indexPath)
		{
			indexPath = [NSIndexPath indexPathForRow:indexPath.row + 1 inSection:indexPath.section];
			
			[self updateTableView:tableView
						   update:^{
                               if(tableView.numberOfSections > indexPath.section)
                               {
                                   [tableView insertRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                               }
						   }
					   completion:completion];
			
			return includeCell;
		}
	}
	else if(!shouldInclude && [fields containsObject:includeCell])
	{
		[fields removeObject:includeCell];
		NSIndexPath *indexPath = [self getIndexPathForCell:includeCell inTableView:tableView];
		if (indexPath)
		{
			[self updateTableView:tableView
						   update:^{
                               if(tableView.numberOfSections > indexPath.section)
                               {
                                   [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationTop];
                               }
						   }
					   completion:completion];
		}
	}
	
	return nil;
}

- (NSIndexPath *)getIndexPathForCell:(UITableViewCell *)cell inTableView:(UITableView *)tableView
{
    NSIndexPath *path = [tableView indexPathForCell:cell];
    if (!path)
    {
        NSUInteger tableViewIndex = [self.tableViews indexOfObject:tableView];
        if(tableViewIndex!=NSNotFound)
        {
            for(NSArray *section in self.cells[tableViewIndex])
            {
                if([section containsObject:cell])
                {
                    NSUInteger sectionIndex = [self.cells[tableViewIndex] indexOfObject:section];
                    NSUInteger row = [section indexOfObject:cell];
                    if(sectionIndex != NSNotFound && row != NSNotFound)
                    {
                        return [NSIndexPath indexPathForRow:row inSection:sectionIndex];
                    }
                    
                }
            }
        }
    }
    
    return path;
}

- (void)updateTableView:(UITableView *)tableView
				 update:(void (^)())update
			 completion:(SelectionCompletion)completion
{
    if(tableView.numberOfSections > 0)
    {
        [CATransaction begin];
        [CATransaction setCompletionBlock:^{
            if (completion)
            {
                completion();
            }
        }];
            [tableView beginUpdates];
            update();
            [tableView endUpdates];
        [CATransaction commit];
    }
    else
    {
        //Table view hasn't loaded cells yet. Don't animate.
        [tableView reloadData];
    }
}

- (TextEntryCell *)countrySelectionCell:(SelectionCell *)cell
					   didSelectCountry:(Country *)country
						 withCompletion:(SelectionCompletion)completion
{
	return [self includeStateCell:[ProfileSource showStateCell:country.iso3Code]
				   withCompletion:completion];
}

+ (BOOL)showStateCell:(NSString *)countryCode
{
	return [self isMatchingSource:@"usa"
					   withTarget:countryCode];
}

+ (BOOL)showAcnAndAbnCells:(NSString *)countryCode
{
	return [self isMatchingSource:@"au"
					   withTarget:countryCode];
}

+ (BOOL)showArbnCell:(NSString *)targetCurrency
{
	return [self isMatchingSource:@"aud"
					   withTarget:targetCurrency];
}

+ (BOOL)isMatchingSource:(NSString *)source
			  withTarget:(NSString *)target
{
	return source && [source caseInsensitiveCompare:target] == NSOrderedSame;
}

- (id)findContainingArrayForObject:(id)object
									   withArray:(NSArray *)array
{
	for (id o in array)
	{
		if (o == object)
		{
			return array;
		}
		else if([o isKindOfClass:[NSArray class]])
		{
			NSArray* result = [self findContainingArrayForObject:object
															  withArray:(NSArray *)o];
			
			if (result)
			{
				return result;
			}
		}
	}
	
	return nil;
}

- (void)clearData
{
	ABSTRACT_METHOD;
}

@end
