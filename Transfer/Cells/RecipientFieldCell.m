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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self)
	{
        // Initialization code
    }
    return self;
}

- (void)setFieldType:(RecipientTypeField *)field
{
    [self setType:field];
	self.maxValueLength = [self.type maxLengthValue];
    self.presentationPattern = self.type.presentationPattern;
    [self configureWithTitle:field.title value:nil];
}

@end
