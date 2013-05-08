//
//  TextEntryCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const TWTextEntryCellIdentifier;

@interface TextEntryCell : UITableViewCell

@property (nonatomic, strong, readonly) UITextField *entryField;

- (void)configureWithTitle:(NSString *)title value:(NSString *)value;
- (NSString *)value;
- (void)setValue:(NSString *)value;
- (void)setEditable:(BOOL)editable;

@end
