//
//  DateEntryCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "MultipleEntryCell.h"

extern NSString *const TWDateEntryCellIdentifier;

@interface DateEntryCell : MultipleEntryCell<UITextFieldDelegate>

@property (nonatomic, assign) BOOL usDateOrder;

- (void)setDateValue:(NSDate *)date;
- (BOOL)isValidDate;

@end
