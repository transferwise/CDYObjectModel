//
//  SuggestionDataEntryViewController.h
//  Transfer
//
//  Created by Juhan Hion on 29.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "DataEntryMultiColumnViewController.h"
#import "TextFieldSuggestionTable.h"
#import "TextEntryCell.h"

@interface SuggestionDataEntryViewController : DataEntryMultiColumnViewController<SuggestionTableDelegate>

@property (nonatomic, strong) IBOutlet TextFieldSuggestionTable* suggestionTable;

- (void)configureWithDataSource:(id<SuggestionTableCellProvider>)dataSource
					  entryCell:(TextEntryCell *)entryCell
						 height:(CGFloat)height;

@end
