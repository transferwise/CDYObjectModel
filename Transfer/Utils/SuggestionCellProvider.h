//
//  SuggestionCellProvider.h
//  Transfer
//
//  Created by Juhan Hion on 29.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldSuggestionTable.h"

NSString * const kCellReuseIdentifier = @"SuggestCell";

@interface SuggestionCellProvider : NSObject<SuggestionTableCellProvider>

@property (nonatomic, strong) NSString *nibName;
@property (nonatomic, strong) NSFetchedResultsController *autoCompleteResults;
@property (nonatomic, strong) NSArray *dataSource;
@property (nonatomic, strong) NSArray *results;

- (void)refreshLookupWithCompletion:(void(^)(void))completionBlock;

@end
