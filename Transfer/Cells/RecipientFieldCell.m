//
//  RecipientFieldCell.m
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientFieldCell.h"
#import "RecipientTypeField.h"
#import "NSString+Validation.h"
#import "NSString+Presentation.h"

NSString *const TWRecipientFieldCellIdentifier = @"TWRecipientFieldCellIdentifier";

@interface RecipientFieldCell ()

@property (nonatomic, strong) RecipientTypeField *type;

@end

@implementation RecipientFieldCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setFieldType:(RecipientTypeField *)field {
    [self setType:field];
    [self configureWithTitle:field.title value:nil];
}

- (BOOL)shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string {
    NSString *pattern = self.type.presentationPattern;
    if (![pattern hasValue]) {
        return YES;
    }

    NSString *modified = [self.entryField.text stringByReplacingCharactersInRange:range withString:string];

    if ([modified length] > [pattern length]) {
        return NO;
    }

    if ([string length] == 0) {
        modified = [modified stringByRemovingPatterChar:pattern];
    } else {
        modified = [modified applyPattern:pattern];
        modified = [modified stringByAddingPatternChar:pattern];
    }

    [self.entryField setText:modified];

    return NO;
}

@end
