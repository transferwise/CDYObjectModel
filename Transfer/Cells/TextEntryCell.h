//
//  TextEntryCell.h
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Constants.h"

extern NSString *const TWTextEntryCellIdentifier;

@interface TextEntryCell : UITableViewCell

@property (nonatomic, strong, readonly) UITextField *entryField;
@property (nonatomic, copy) NSString *cellTag;
@property (nonatomic, strong) IBOutlet UIView *separatorLine;

- (void)configureWithTitle:(NSString *)title value:(NSString *)value;
- (NSString *)value;
- (void)setValue:(NSString *)value;
- (void)setEditable:(BOOL)editable;
- (void)setValueWhenEditable:(NSString *)value;
- (BOOL)entryField:(UITextField *)entryField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)markIssue:(NSString *)issueMessage;
- (void)markTouched;

@end
