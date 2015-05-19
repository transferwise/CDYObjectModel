//
//  DropdownCell.m
//  Transfer
//
//  Created by Jaanus Siim on 5/14/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "DropdownCell.h"

NSString *const TWDropdownCellIdentifier = @"TWDropdownCellIdentifier";

@interface DropdownCell () <UIPickerViewDataSource, UIPickerViewDelegate, UIGestureRecognizerDelegate>

@property (nonatomic, strong) UIPickerView *picker;
@property (nonatomic, strong) id selectedObject;

@end

@implementation DropdownCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self)
	{
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];

    UIPickerView *pickerView = [[UIPickerView alloc] initWithFrame:CGRectZero];
    [self setPicker:pickerView];
    [pickerView setShowsSelectionIndicator:YES];
    [pickerView setDataSource:self];
    [pickerView setDelegate:self];
	
	UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self
																					action:@selector(pickerTapped:)];
	[pickerView addGestureRecognizer:tapRecognizer];
	tapRecognizer.delegate = self;
	
    [self.entryField setInputView:pickerView];
}

- (NSString *)value
{
    return self.selectedObject ? [self.selectedObject valueForKeyPath:@"code"] : @"";
}

- (void)setAllElements:(NSFetchedResultsController *)allElements
{
    _allElements = allElements;
    [self selectedElement:allElements.fetchedObjects[0]];
}

- (void)setValue:(NSString *)value
{
    id element = [self findValueWithName:value];
    if (!element)
	{
        return;
    }

    [self selectedElement:element];
    NSInteger index = [self.allElements indexPathForObject:element].row;
    [self.picker selectRow:index inComponent:0 animated:NO];
}

- (id)findValueWithName:(NSString *)name
{
    for (id element in self.allElements.fetchedObjects)
	{
        NSString *elementName = [element valueForKeyPath:@"code"];
        if ([elementName isEqualToString:name])
		{
            return element;
        }
    }
    return nil;
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return [self.allElements.fetchedObjects count];
}

- (NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    id rowObject = [self.allElements objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    return [[rowObject valueForKeyPath:@"title"] capitalizedString];
}

- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    id rowObject = [self.allElements objectAtIndexPath:[NSIndexPath indexPathForRow:row inSection:0]];
    [self selectedElement:rowObject];
}

- (void)selectedElement:(id)rowObject
{
    [self setSelectedObject:rowObject];
    [self.entryField setText:[[rowObject valueForKeyPath:@"title"] capitalizedString]];
}

- (BOOL)gestureRecognizer:(UIGestureRecognizer *)gestureRecognizer
shouldRecognizeSimultaneouslyWithGestureRecognizer:(UIGestureRecognizer *)otherGestureRecognizer
{
	return YES;
}

-(void)pickerTapped:(UITapGestureRecognizer*)sender;
{
    CGPoint tappedPoint = [sender locationInView:self.picker];
    if(ABS(tappedPoint.y - self.picker.bounds.size.height/2.0f) < 15.0f)
    {
        [self cellTapped:sender];
    }
}

- (IBAction)cellTapped:(id)sender
{
    if(self.entryField.isFirstResponder)
    {
        [self.entryField resignFirstResponder];
    }
    else
    {
        [self.entryField becomeFirstResponder];
    }
}

@end
