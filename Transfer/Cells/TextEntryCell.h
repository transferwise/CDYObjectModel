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

@protocol TextEntryCellDelegate <NSObject>

- (void)textEntryFinishedInCell:(UITableViewCell *)cell;

@end

@interface TextEntryCell : UITableViewCell

@property (nonatomic, weak) id<TextEntryCellDelegate> delegate;
@property (nonatomic, strong, readonly) UITextField *entryField;
@property (nonatomic, copy) NSString *cellTag;
@property (nonatomic, strong) IBOutlet UIView *separatorLine;
@property (nonatomic, readonly) BOOL valueModified;
@property (nonatomic) BOOL editable;
@property (nonatomic) NSInteger maxValueLength;
@property (nonatomic) BOOL validateAlphaNumeric;

- (void)configureWithTitle:(NSString *)title value:(NSString *)value;
- (NSString *)value;
- (void)setValue:(NSString *)value;
- (void)setEditable:(BOOL)value;
- (void)setValueWhenEditable:(NSString *)value;
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string;
- (void)markIssue:(NSString *)issueMessage;
- (void)markTouched;
- (void)textFieldEntryFinished;

@end
