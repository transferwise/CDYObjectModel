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
@property (nonatomic, weak) IBOutlet UIView *separatorLine;

- (void)configureWithTitle:(NSString *)title value:(NSString *)value;
- (NSString *)value;
- (void)setValue:(NSString *)value;
- (void)setEditable:(BOOL)editable;
- (void)addDoneButton;
- (void)addDoneButtonToField:(UITextField *)field withAction:(TRWActionBlock)action;
- (void)setValueWhenEditable:(NSString *)value;
- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)markIssue:(NSString *)issueMessage;
- (void)markTouched;

@end
