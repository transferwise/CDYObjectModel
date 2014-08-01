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


@interface NameSuggestionCellProvider ()

@property (nonatomic, strong) AddressBookManager *addressBookManager;

@end

@implementation NameSuggestionCellProvider

-(id)init
{
    self = [super init];
    if(self)
    {
        _addressBookManager = [[AddressBookManager alloc] init];
        self.nibName = @"NameSuggestionCell";
    }
    return self;
}

-(void)refreshLookupWithCompletion:(void(^)(void))completionBlock
{
    [_addressBookManager getNameLookupWithHandler:^(NSArray *nameLookup) {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            
            if([self.filterString length] > 0)
            {
                NSArray* filteredRecipients = [NSArray array];
                NSMutableArray *workArray;
                if (self.results)
                {
                    // Filter and sort existing recipients
                     filteredRecipients = [self.results filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NameLookupWrapper *evaluatedObject, NSDictionary *bindings) {
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

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameSuggestionCell *cell = (NameSuggestionCell*)[super getCell:tableView];
    
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

-(void)refreshResults
{
    NSMutableArray* result = [NSMutableArray arrayWithCapacity:[self.autoCompleteResults.fetchedObjects count]];
    for(Recipient *recipient in self.autoCompleteResults.fetchedObjects)
    {
        if(recipient.email)
        {
            NameLookupWrapper* wrapper = [[NameLookupWrapper alloc] initWithManagedObjectId:recipient.objectID firstname:recipient.name lastName:nil email:recipient.email];
            [result addObject:wrapper];
        }
    }
	
    self.results = result;
}

@end
