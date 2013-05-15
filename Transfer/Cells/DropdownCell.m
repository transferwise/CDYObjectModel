//
//  DropdownCell.m
//  Transfer
//
//  Created by Jaanus Siim on 5/14/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "DropdownCell.h"

NSString *const TWDropdownCellIdentifier = @"TWDropdownCellIdentifier";

@interface DropdownCell () <UIPickerViewDataSource, UIPickerViewDelegate>

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) id selectedObject;

@end

@implementation DropdownCell

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [self setPicker:pickerView];
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];

    [self.entryField setInputView:pickerView];

    UIToolbar *toolbar = [[UIToolbar alloc] initWithFrame:CGRectMake(0, 0, 20, 44)];
    [toolbar setBarStyle:UIBarStyleBlackTranslucent];
    UIBarButtonItem *spacer = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *doneButton = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(donePressed)];
    [toolbar setItems:@[spacer, doneButton]];

    [self.entryField setInputAccessoryView:toolbar];
}

- (void)donePressed {
    [self.entryField resignFirstResponder];
}

- (NSString *)value {
    return self.selectedObject ? [self.selectedObject valueForKeyPath:@"name"] : @"";
}

- (void)setAllElements:(NSArray *)allElements {
    _allElements = allElements;
    [self selectedElement:allElements[0]];
}

- (void)setValue:(NSString *)value {
    id element = [self findValueWithName:value];
    if (!element) {
        return;
    }

    [self selectedElement:element];
    NSUInteger index = [self.allElements indexOfObject:element];
    [self.picker selectRow:index inComponent:0 animated:NO];
}

- (id)findValueWithName:(NSString *)name {
    for (id element in self.allElements) {
        NSString *elementName = [element valueForKeyPath:@"name"];
        if ([elementName isEqualToString:name]) {
            return element;
        }
    }
    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView {
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component {
    return [self.allElements count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component {
    id rowObject = self.allElements[(NSUInteger) row];
    return [rowObject valueForKeyPath:@"name"];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component {
    id rowObject = self.allElements[(NSUInteger) row];
    [self selectedElement:rowObject];
}

- (void)selectedElement:(id)rowObject {
    [self setSelectedObject:rowObject];
    [self.entryField setText:[rowObject valueForKeyPath:@"name"]];
}

@end
