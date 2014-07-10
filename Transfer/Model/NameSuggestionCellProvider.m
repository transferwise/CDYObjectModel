//
//  NameSuggestionCellProvider.m
//  Transfer
//
//  Created by Mats Trovik on 17/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "NameSuggestionCellProvider.h"
#import "AddressBookManager.h"
#import "NameLookupWrapper.h"
#import "NameSuggestionCell.h"
#import "MOMstyle.h"
#import "Recipient.h"


@interface NameSuggestionCellProvider ()<NSFetchedResultsControllerDelegate>

@property (nonatomic, strong) AddressBookManager *addressBookManager;
@property (nonatomic, strong) NSArray *dataSource;
@property (copy) NSString *filterString;
@property (nonatomic, strong) UINib *cellNib;
@property (nonatomic, strong) NSArray *recipients;

@end

@implementation NameSuggestionCellProvider

-(id)init
{
    self = [super init];
    if(self)
    {
        _addressBookManager = [[AddressBookManager alloc] init];
        [self refreshNameLookupWithCompletion:nil];
    }
    return self;
}

-(void)refreshNameLookupWithCompletion:(void(^)(void))completionBlock
{
    [_addressBookManager getNameLookupWithHandler:^(NSArray *nameLookup) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if([self.filterString length] > 0)
            {
                NSArray* filteredRecipients = [NSArray array];
                NSMutableArray *workArray;
                if (self.recipients)
                {
                    // Filter and sort existing recipients
                     filteredRecipients = [self.recipients filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NameLookupWrapper *evaluatedObject, NSDictionary *bindings) {
                        return evaluatedObject.firstName && [[evaluatedObject.firstName lowercaseString] rangeOfString:self.filterString].location == 0;
                    }]];
                    
                    filteredRecipients = [filteredRecipients sortedArrayUsingComparator:^NSComparisonResult(NameLookupWrapper *obj1, NameLookupWrapper *obj2) {
                        return [obj1.firstName caseInsensitiveCompare:obj2.firstName];
                    }];
                    
                    // Create email lookup
                    NSArray* emails = [filteredRecipients valueForKey:@"email"];
                    NSMutableArray* alreadyUsedEmails = [NSMutableArray arrayWithCapacity:[emails count]];
                    for(NSString *email in emails)
                    {
                        [alreadyUsedEmails addObject:[email lowercaseString]];
                    }
                
                    //filter out addresss book entries with emails already in recipients
                    workArray = [[nameLookup filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NameLookupWrapper *evaluatedObject, NSDictionary *bindings) {
                        return [alreadyUsedEmails indexOfObject:[evaluatedObject.email lowercaseString]] == NSNotFound;
                    }]] mutableCopy];
                }
                else
                {
                    workArray = [nameLookup mutableCopy];
                }
                
                NSArray *firstnameMatches = [workArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NameLookupWrapper *evaluatedObject, NSDictionary *bindings) {
                    return evaluatedObject.firstName && [[evaluatedObject.firstName lowercaseString] rangeOfString:self.filterString].location == 0;
                }]];
                firstnameMatches = [firstnameMatches sortedArrayUsingComparator:^NSComparisonResult(NameLookupWrapper *obj1, NameLookupWrapper *obj2) {
                    return [obj1.firstName caseInsensitiveCompare:obj2.firstName];
                }];
                [workArray removeObjectsInArray:firstnameMatches];
                
                NSArray *lastnameMatches = [workArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NameLookupWrapper *evaluatedObject, NSDictionary *bindings) {
                    return evaluatedObject.lastName && [[evaluatedObject.lastName lowercaseString] rangeOfString:self.filterString].location == 0;
                }]];
                lastnameMatches = [lastnameMatches sortedArrayUsingComparator:^NSComparisonResult(NameLookupWrapper *obj1, NameLookupWrapper *obj2) {
                    return [obj1.lastName caseInsensitiveCompare:obj2.lastName];
                }];
                [workArray removeObjectsInArray:lastnameMatches];
                
                self.dataSource = @[filteredRecipients, firstnameMatches, lastnameMatches];
            }
            else
            {
                self.dataSource = nil;
            }
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if(completionBlock)
                {
                    completionBlock();
                }
            });
        });

    }];
}

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
