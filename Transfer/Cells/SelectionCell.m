//
//  CountrySelectionCell.m
//  Transfer
//
//  Created by Jaanus Siim on 4/29/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "SelectionCell.h"
#import "Country.h"
#import "NSString+Validation.h"

NSString *const TWSelectionCellIdentifier = @"CountrySelectionCell";

@interface SelectionCell ()

@property (nonatomic, strong) id<SelectionItem> selectedItem;

@end

@implementation SelectionCell

- (void)configureWithTitle:(NSString *)title value:(NSString *)value;
{
	[super configureWithTitle:title value:value];
	[self.entryField addTarget:self action:@selector(editingEnded) forControlEvents:UIControlEventEditingDidEnd];
}

- (void)setValue:(NSString *)value
{
    [self setValueFromCode:value];
}

- (NSString *)value
{
	//if we have selected country, set selected value
	//if we do not have selected country, but user has typed something, set to invalid
	//if we do not have selected country and user hasn't typed anything, leave empty
    return self.selectedItem ? self.selectedItem.code :
		([self.entryField.text hasValue] ? @"invalid" : @"");
}

- (void)setCode:(NSString *)code
{
	[self setValueFromCode:code];
}

- (void)setValueFromCode:(NSString *)value
{
	id<SelectionItem> selected = [self.selectionDelegate selectionCell:self
													   getByCodeOrName:value];
	
    self.selectedItem = selected;
    [self.entryField setText:selected.name];
}

- (void)editingEnded
{
	if ([self.entryField.text hasValue])
	{
		//this will be either set to a correct country if user typed the name of the country
		//or nil, if value is incorrect
		//if user selected country form the list then that selection will be done after this
		self.selectedItem = [self.selectionDelegate selectionCell:self
												  getByCodeOrName:self.entryField.text];
	}
	else
	{
		self.selectedItem = nil;
	}
}

@end
