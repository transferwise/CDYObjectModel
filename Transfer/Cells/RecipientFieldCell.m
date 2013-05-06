//
//  RecipientFieldCell.m
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientFieldCell.h"
#import "RecipientTypeField.h"

NSString *const TWRecipientFieldCellIdentifier = @"TWRecipientFieldCellIdentifier";

@interface RecipientFieldCell ()

@property RecipientTypeField *type;

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

@end
