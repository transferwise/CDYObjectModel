//
//  TextEntryCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TextEntryCell.h"
#import "UIColor+Theme.h"
#import "NSString+Validation.h"

NSString *const TWTextEntryCellIdentifier = @"TextEntryCell";

@interface TextEntryCell ()

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITextField *entryField;
@property (nonatomic, copy) TRWActionBlock doneButtonAction;
@property (nonatomic, assign) BOOL valueModified;
@property (nonatomic, strong) IBOutlet UIButton *errorButton;

@end

@implementation TextEntryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithTitle:(NSString *)title value:(NSString *)value {
    [self.titleLabel setText:title];
    [self setValue:value];

    CGRect titleFrame = self.titleLabel.frame;
    CGSize titleSize = [self.titleLabel sizeThatFits:CGSizeMake(NSUIntegerMax, CGRectGetHeight(titleFrame))];
    CGFloat widthChange = titleSize.width - CGRectGetWidth(titleFrame);
    titleFrame.size.width += widthChange;
    [self.titleLabel setFrame:titleFrame];

    CGRect entryFrame = self.entryField.frame;
    entryFrame.origin.x += widthChange;
    entryFrame.size.width -= widthChange;
    [self.entryField setFrame:entryFrame];
}

- (NSString *)value {
    if([self.entryField text])
        return [self.entryField text];
    else
        return @"";
}

- (void)setValue:(NSString *)value { 
    [self.entryField setText:value];
}

- (void)setEditable:(BOOL)editable {
    [self.entryField setEnabled:editable];
    [self.titleLabel setTextColor:(editable ? [UIColor blackColor] : [UIColor disabledEntryTextColor])];
    [self.entryField setTextColor:(editable ? [UIColor blackColor] : [UIColor disabledEntryTextColor])];
}

- (void)addDoneButton {
    __block __weak TextEntryCell *weakSelf = self;
    [self addDoneButtonToField:self.entryField withAction:^{
        [weakSelf.entryField.delegate textFieldShouldReturn:weakSelf.entryField];
    }];
}

- (void)addDoneButtonToField:(UITextField *)field withAction:(TRWActionBlock)action {
    [self setDoneButtonAction:action];

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];

    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    //TODO jaanus: button title based on entry return key type
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    [toolbar setItems:@[flexible, done]];
    [field setInputAccessoryView:toolbar];
}

- (void)setValueWhenEditable:(NSString *)value {
    if (![self.entryField isEnabled]) {
        return;
    }

    [self.entryField setText:value];
}

- (void)donePressed {
    if (self.doneButtonAction) {
        self.doneButtonAction();
    }
}

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    [self setValueModified:YES];
    return YES;
}

- (void)markIssue:(NSString *)issueMessage {
    [self.errorButton setHidden:!self.valueModified || ![issueMessage hasValue]];
}

- (void)markTouched {
    [self setValueModified:YES];
}

@end
