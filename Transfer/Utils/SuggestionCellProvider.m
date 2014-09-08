//
//  SuggestionCellProvider.m
//  Transfer
//
//  Created by Juhan Hion on 29.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SuggestionCellProvider.h"
#import "UIColor+MOMStyle.h"
#import "Constants.h"

@interface SuggestionCellProvider()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) UINib *cellNib;

@end

@implementation SuggestionCellProvider

-(id)init
{
    self = [super init];
    if(self)
    {
        self.nibName = @"SuggestionCell";
		
		[self refreshLookupWithCompletion:nil];
    }
    return self;
}

#pragma mark - Suggestion table cell provider

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section < [self.dataSource count])
    {
        return [self.dataSource[section] count];
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    SuggestionCell *cell = [self getCell:tableView];
    
    NSString *text = self.dataSource[indexPath.section][indexPath.row];
    
    NSMutableAttributedString  *attributedText= [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [[text lowercaseString] rangeOfString:self.filterString];
    if(range.location != NSNotFound)
    {
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromStyle:@"DarkFont"] range:range];
    }
    cell.nameLabel.attributedText = attributedText;
    return cell;
}

- (SuggestionCell *)getCell:(UITableView *)tableView
{
	if(!self.cellNib)
    {
        self.cellNib = [UINib nibWithNibName:self.nibName bundle:[NSBundle mainBundle]];
        [tableView registerNib:self.cellNib forCellReuseIdentifier:self.nibName];
    }
	
    SuggestionCell *cell = (SuggestionCell*)[tableView dequeueReusableCellWithIdentifier:self.nibName];
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    cell.clipsToBounds = YES;
	return cell;
}

-(void)filterForText:(NSString *)text completionBlock:(void (^)(BOOL))completionBlock
{
    self.filterString = [text lowercaseString];
	
    [self refreshLookupWithCompletion:^{
        completionBlock(YES);
    }];
}

-(id)objectForIndexPath:(NSIndexPath *)indexPath
{
    return self.dataSource[indexPath.section][indexPath.row];
}

-(void)setAutoCompleteResults:(NSFetchedResultsController *)autoCompleteResults
{
    if(_autoCompleteResults != autoCompleteResults)
    {
        _autoCompleteResults = autoCompleteResults;
        [self refreshResults];
    }
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self refreshResults];
}

-(void)refreshLookupWithCompletion:(void(^)(void))completionBlock
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
		if([self.filterString length] > 0)
		{
			NSArray* filteredResults = [self.results filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NSString *evaluatedObject, NSDictionary *bindings) {
				return evaluatedObject && [[evaluatedObject lowercaseString] rangeOfString:self.filterString].location == 0;
			}]];
			filteredResults = [filteredResults sortedArrayUsingComparator:^NSComparisonResult(NSString *obj1, NSString *obj2) {
				return [obj1 caseInsensitiveCompare:obj2];
			}];
			
			self.dataSource = @[filteredResults];
		}
		else
		{
			self.dataSource = nil;
		}
		
		dispatch_async(dispatch_get_main_queue(), ^{
			if(completionBlock)
			{
				completionBlock();
			}
		});
	});
}

-(void)refreshResults
{
    ABSTRACT_METHOD;
}

@end
