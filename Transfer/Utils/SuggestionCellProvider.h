//
//  SuggestionCellProvider.h
//  Transfer
//
//  Created by Juhan Hion on 29.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "TextFieldSuggestionTable.h"

@interface SuggestionCellProvider : NSObject<SuggestionTableCellProvider>

@property (nonatomic, strong) NSFetchedResultsController *autoCompleteResults;
@property (nonatomic, strong) NSArray *dataSource;

@end
