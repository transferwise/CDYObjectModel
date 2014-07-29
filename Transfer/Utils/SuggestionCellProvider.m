//
//  SuggestionCellProvider.m
//  Transfer
//
//  Created by Juhan Hion on 29.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "SuggestionCellProvider.h"

@interface SuggestionCellProvider()

@property (copy) NSString *filterString;
@property (nonatomic, strong) UINib *cellNib;

@end

@implementation SuggestionCellProvider

#pragma mark - Suggestion table cell provider

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(section < [self.dataSource count])
    {
        return [self.dataSource[section] count];
    }
    return 0;
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return [self.dataSource count];
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if(!self.cellNib)
    {
        self.cellNib = [UINib nibWithNibName:@"NameSuggestionCell" bundle:[NSBundle mainBundle]];
        [tableView registerNib:self.cellNib forCellReuseIdentifier:@"NameSuggestionCell"];
    }
    NameSuggestionCell *cell = (NameSuggestionCell*)[tableView dequeueReusableCellWithIdentifier:@"NameSuggestionCell"];
    cell.translatesAutoresizingMaskIntoConstraints = NO;
    
    NameLookupWrapper *wrapper = self.dataSource[indexPath.section][indexPath.row];
    NSString *text;
    switch (indexPath.section) {
        case 2:
            text = [wrapper presentableString:LastNameFirst];
            break;
        case 1:
        case 0:
        default:
            text = [wrapper presentableString:FirstNameFirst];
            break;
    }
    
    NSMutableAttributedString  *attributedText= [[NSMutableAttributedString alloc] initWithString:text];
    NSRange range = [[text lowercaseString] rangeOfString:self.filterString];
    if(range.location != NSNotFound)
    {
        [attributedText addAttribute:NSForegroundColorAttributeName value:[UIColor colorFromStyle:@"DarkFont"] range:range];
    }
    cell.nameLabel.attributedText = attributedText;
    
    cell.emailLabel.text = wrapper.email;
    cell.tag = wrapper.recordId;
    [self.addressBookManager getImageForRecordId:wrapper.recordId completion:^(UIImage *image) {
        if(cell.tag == wrapper.recordId)
        {
            cell.thumbnailImage.image = image;
        }
    }];
    return cell;
}

-(void)filterForText:(NSString *)text completionBlock:(void (^)(BOOL))completionBlock
{
    self.filterString = [text lowercaseString];
    [self refreshNameLookupWithCompletion:^{
        completionBlock(YES);
    }];
}

-(id)objectForIndexPath:(NSIndexPath *)indexPath
{
    return self.dataSource[indexPath.section][indexPath.row];
}

-(void)setAutoCompleteRecipients:(NSFetchedResultsController *)autoCompleteRecipients
{
    if(_autoCompleteRecipients != autoCompleteRecipients)
    {
        _autoCompleteRecipients = autoCompleteRecipients;
        [self refreshRecipients];
    }
    
}

-(void)controllerDidChangeContent:(NSFetchedResultsController *)controller
{
    [self refreshRecipients];
}

-(void)refreshRecipients
{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:[self.autoCompleteRecipients.fetchedObjects count]];
    for(Recipient *recipient in self.autoCompleteRecipients.fetchedObjects)
    {
        if(recipient.email)
        {
            NameLookupWrapper* wrapper = [[NameLookupWrapper alloc] initWithManagedObjectId:recipient.objectID firstname:recipient.name lastName:nil email:recipient.email];
            [result addObject:wrapper];
        }
    }
    self.recipients = result;
}

@end
