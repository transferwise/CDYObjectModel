//
//  NameSuggestionCellProvider.h
//  Transfer
//
//  Created by Mats Trovik on 17/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TextFieldSuggestionTable.h"

@interface NameSuggestionCellProvider : NSObject<SuggestionTableCellProvider>

@property (nonatomic, strong) NSFetchedResultsController *autoCompleteRecipients;

@end
