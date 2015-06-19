//
//  ProfileSource+Private.h
//  Transfer
//
//  Created by Juhan Hion on 17.06.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "ProfileSource.h"

@class TextEntryCell;

@interface ProfileSource (Private)

- (TextEntryCell *)includeCell:(TextEntryCell *)includeCell
					 afterCell:(UITableViewCell *)afterCell
				 shouldInclude:(BOOL)shouldInclude
				withCompletion:(SelectionCompletion)completion;

- (TextEntryCell *)includeStateCell:(BOOL)shouldInclude
					 withCompletion:(SelectionCompletion)completion;

+ (BOOL)showStateCell:(NSString *)countryCode;
+ (BOOL)isMatchingSource:(NSString *)source
			  withTarget:(NSString *)target;

@end
