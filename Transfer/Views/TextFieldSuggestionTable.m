//
//  AddressBookSuggestionTable.m
//  Transfer
//
//  Created by Mats Trovik on 17/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TextFieldSuggestionTable.h"

@implementation TextFieldSuggestionTable

-(void)linkToTextField:(UITextField*)textField
{
    [textField addTarget:self action:@selector(textFieldChanged:) forControlEvents:UIControlEventAllEditingEvents];
    [textField addTarget:self action:@selector(didStartEditing:) forControlEvents:UIControlEventEditingDidBegin];
    [textField addTarget:self action:@selector(didEndEditing:) forControlEvents:UIControlEventEditingDidEnd];
}

#pragma mark - input text changed

-(void)didStartEditing:(UITextField*)field
{
    if ([self.suggestionTableDelegate respondsToSelector:@selector(suggestionTableDidStartEditing:)])
    {
        [self.suggestionTableDelegate suggestionTableDidStartEditing:self];
    }
}

-(void)didEndEditing:(UITextField*)field
{
    if ([self.suggestionTableDelegate respondsToSelector:@selector(suggestionTableDidEndEditing:)])
    {
        [self.suggestionTableDelegate suggestionTableDidEndEditing:self];
    }
}

-(void)textFieldChanged:(UITextField*)field
{
    if (field.isFirstResponder)
    {
        if ([field.text length]>0)
        {
            self.hidden = NO;
            if(self.cellProvider)
            {
                [self.cellProvider filterForText:field.text completionBlock:^(BOOL contentDidChange) {
                    if(contentDidChange)
                    {
                        [self reloadData];
                    }
                }];
            }
        }
        else
        {
            self.hidden = YES;
        }
    }
    else
    {
        self.hidden = YES;
    }
}


@end
