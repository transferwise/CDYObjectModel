//
//  MoneyEntryCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "MoneyEntryCell.h"

NSString *const TWMoneyEntryCellIdentifier = @"TWMoneyEntryCell";

@interface MoneyEntryCell () <UITextFieldDelegate>

@property (nonatomic, strong) IBOutlet UILabel *titleLabel;
@property (nonatomic, strong) IBOutlet UITextField *moneyField;
@property (nonatomic, strong) IBOutlet UITextField *currencyField;

@end

@implementation MoneyEntryCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];

    UIBarButtonItem *flexible = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *done = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    [toolbar setItems:@[flexible, done]];
    [self.moneyField setInputAccessoryView:toolbar];

    //TODO jaanus: maybe can find a way how to change keyboard locale
    [self.moneyField setDelegate:self];
}

- (void)donePressed {
    [self.moneyField resignFirstResponder];
}

- (void)setTitle:(NSString *)title {
    [self.titleLabel setText:title];
}

- (void)setAmount:(NSString *)amount currency:(NSString *)currency {
    [self.moneyField setText:amount];
    [self.currencyField setText:currency];
}

- (NSString *)amount {
    return [self.moneyField text];
}

- (NSString *)currency {
    return [self.currencyField text];
}

- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    if (![string isEqualToString:@","]) {
        return YES;
    }

    if ([textField.text rangeOfString:@"."].location == NSNotFound) {
        [textField setText:[textField.text stringByAppendingString:@"."]];
    }

    return NO;
}

@end
