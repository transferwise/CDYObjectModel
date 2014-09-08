//
//  AddressBookSuggestionTable.m
//  Transfer
//
//  Created by Mats Trovik on 17/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TextFieldSuggestionTable.h"
#import "Constants.h"

@interface TextFieldSuggestionTable ()<UITableViewDelegate>
@property (nonatomic, strong) NSDate *startedEditing;
@property (nonatomic, strong) IBOutlet UITableView* tableView;
@end

@implementation TextFieldSuggestionTable

-(void)layoutSubviews
{
    if(!self.tableView.tableFooterView)
    {
        self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    }
}

#pragma mark - input text changed

-(void)didStartEditing:(UITextField*)field
{
    self.startedEditing = [NSDate date];
    self.tableView.delegate = self;
    if ([self.suggestionTableDelegate respondsToSelector:@selector(suggestionTableDidStartEditing:)])
    {
        [self.suggestionTableDelegate suggestionTableDidStartEditing:self];
    }

}

-(void)didEndEditing:(UITextField*)field
{
    self.hidden = YES;
    if ([self.suggestionTableDelegate respondsToSelector:@selector(suggestionTableDidEndEditing:)])
    {
        [self.suggestionTableDelegate suggestionTableDidEndEditing:self];
    }

}

-(void)textFieldChanged:(UITextField*)field
{
    if (field.isFirstResponder)
    {
        self.hidden = ([field.text length] <= 0 || [self.tableView.visibleCells count] == 0);
        if(self.dataSource)
        {
            [self.dataSource filterForText:field.text completionBlock:^(BOOL contentDidChange) {
                if(contentDidChange)
                {
                    [self.tableView reloadData];
                    self.hidden = (! field.isFirstResponder || [self.tableView.visibleCells count] == 0);
                }
            }];
        }        
    }
    else
    {
        self.hidden = YES;
    }
}

#pragma mark - text field

-(void)setTextField:(UITextField *)textField
{
    if (_textField)
    {
        [_textField removeTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
        [_textField removeTarget:self action:@selector(didStartEditing:) forControlEvents:UIControlEventEditingDidBegin];
        [_textField removeTarget:self action:@selector(didEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
    }
    
    _textField = textField;
    [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventEditingChanged];
    [textField addTarget:self action:@selector(didStartEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [textField addTarget:self action:@selector(didEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return IPAD?70.0f:60.0f;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([self.suggestionTableDelegate respondsToSelector:@selector(suggestionTable:selectedObject:)])
    {
        [self.suggestionTableDelegate suggestionTable:self selectedObject:[self.dataSource respondsToSelector:@selector(objectForIndexPath:)]?[self.dataSource objectForIndexPath:indexPath]:nil];
    }
}

-(void)setDataSource:(id<SuggestionTableCellProvider>)dataSource
{
    _dataSource = dataSource;
    self.tableView.dataSource = dataSource;
}


@end
