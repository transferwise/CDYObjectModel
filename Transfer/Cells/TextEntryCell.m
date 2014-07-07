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
#import "TRWAlertView.h"
#import "MOMStyle.h"
#import <JVFloatLabeledTextField.h>

NSString *const TWTextEntryCellIdentifier = @"TextEntryCell";

@interface TextEntryCell ()

@property (nonatomic, strong) IBOutlet UITextField *entryField;
@property (nonatomic, copy) TRWActionBlock doneButtonAction;
@property (nonatomic, assign) BOOL valueModified;
@property (nonatomic, strong) IBOutlet UIButton *errorButton;
@property (nonatomic, copy) NSString *validationIssue;

- (IBAction)errorButtonTapped;

@end

@implementation TextEntryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self commonSetup];
    }
    return self;
}

-(void)awakeFromNib
{
    [self commonSetup];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)commonSetup
{
    if([_entryField isKindOfClass:[JVFloatLabeledTextField class]])
    {
        JVFloatLabeledTextField* field = (JVFloatLabeledTextField*) _entryField;
        field.fontStyle = @"medium.@16.darkText2";
        MOMBasicStyle* fontStyle = (MOMBasicStyle*)[MOMStyleFactory getStyleForIdentifier:@"medium.@13"];
        field.floatingLabelFont = [fontStyle font];
        field.floatingLabelTextColor = [UIColor colorFromStyle:@"lightText2"];
        field.floatingLabelActiveTextColor =  [UIColor colorFromStyle:@"navBarBlue"];
        field.floatingLabelYPadding = @(2.0f);
    }
}

- (void)configureWithTitle:(NSString *)title value:(NSString *)value {
    [self.entryField setPlaceholder:title];
    [self setValue:value];
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
    [self.entryField setTextColor:(editable ? [UIColor colorFromStyle:self.entryField.fontStyle] : [UIColor disabledEntryTextColor])];
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
    [self setValidationIssue:issueMessage];
    [self.errorButton setHidden:!self.valueModified || ![issueMessage hasValue] || [self.entryField isFirstResponder]];
}

- (IBAction)errorButtonTapped {
    if (![self.validationIssue hasValue]) {
        return;
    }

    TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:self.entryField.placeholder message:self.validationIssue];
    [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
    [alertView show];
}

- (void)markTouched {
    [self setValueModified:YES];
}

@end
