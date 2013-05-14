//
//  DropdownCell.h
//  Transfer
//
//  Created by Jaanus Siim on 5/14/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TextEntryCell.h"

extern NSString *const TWDropdownCellIdentifier;

@interface DropdownCell : TextEntryCell

@property (nonatomic, strong) NSArray *allElements;

@end
