//
//  NameSuggestionCellProvider.m
//  Transfer
//
//  Created by Mats Trovik on 17/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "NameSuggestionCellProvider.h"
#import "AddressBookManager.h"
#import "EmailLookupWrapper.h"
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
                     filteredRecipients = [self.results filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EmailLookupWrapper *evaluatedObject, NSDictionary *bindings) {
                        return evaluatedObject.firstName && [[evaluatedObject.firstName lowercaseString] rangeOfString:self.filterString].location == 0;
                    }]];
                    
                    filteredRecipients = [filteredRecipients sortedArrayUsingComparator:^NSComparisonResult(EmailLookupWrapper *obj1, EmailLookupWrapper *obj2) {
                        return [obj1.firstName caseInsensitiveCompare:obj2.firstName];
                    }];
                    
                    // Create email lookup
                    NSArray* emails = [filteredRecipients valueForKey:@"email"];
                    NSMutableArray* alreadyUsedEmails = [NSMutableArray arrayWithCapacity:[emails count]];
                    for(NSString *email in emails)
                    {
                        if(![email isEqual:[NSNull null]])
                        {
                            [alreadyUsedEmails addObject:[email lowercaseString]];
                        }
                    }
                
                    //filter out addresss book entries with emails already in recipients
                    workArray = [[nameLookup filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EmailLookupWrapper *evaluatedObject, NSDictionary *bindings) {
                        return [alreadyUsedEmails indexOfObject:[evaluatedObject.email lowercaseString]] == NSNotFound;
                    }]] mutableCopy];
                }
                else
                {
                    workArray = [nameLookup mutableCopy];
                }
                
                if(self.onlyShowRecipients)
                {
                    self.dataSource = @[filteredRecipients];
                }
                else
                {
                
                    NSArray *firstnameMatches = [workArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EmailLookupWrapper *evaluatedObject, NSDictionary *bindings) {
                        return evaluatedObject.firstName && [[evaluatedObject.firstName lowercaseString] rangeOfString:self.filterString].location == 0;
                    }]];
                    firstnameMatches = [firstnameMatches sortedArrayUsingComparator:^NSComparisonResult(EmailLookupWrapper *obj1, EmailLookupWrapper *obj2) {
                        return [obj1.firstName caseInsensitiveCompare:obj2.firstName];
                    }];
                    [workArray removeObjectsInArray:firstnameMatches];
                    
                    NSArray *lastnameMatches = [workArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(EmailLookupWrapper *evaluatedObject, NSDictionary *bindings) {
                        return evaluatedObject.lastName && [[evaluatedObject.lastName lowercaseString] rangeOfString:self.filterString].location == 0;
                    }]];
                    lastnameMatches = [lastnameMatches sortedArrayUsingComparator:^NSComparisonResult(EmailLookupWrapper *obj1, EmailLookupWrapper *obj2) {
                        return [obj1.lastName caseInsensitiveCompare:obj2.lastName];
                    }];
                    [workArray removeObjectsInArray:lastnameMatches];
                    
                    self.dataSource = @[filteredRecipients, firstnameMatches, lastnameMatches];
                }
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

    }
									requestAccess:YES];
}

#pragma mark - Suggestion table cell provider

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NameSuggestionCell *cell = (NameSuggestionCell*)[super getCell:tableView];
    
    EmailLookupWrapper *wrapper = self.dataSource[indexPath.section][indexPath.row];
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
    cell.thumbnailImage.hidden = YES;
    [self.addressBookManager getImageForRecordId:wrapper.recordId
								   requestAccess:YES
									  completion:^(UIImage *image) {
        if(image && cell.tag == wrapper.recordId)
        {
            cell.thumbnailImage.hidden = NO;
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
        NSString *email = [recipient.email isEqual:[NSNull null]]?nil:recipient.email;
        EmailLookupWrapper* wrapper = [[EmailLookupWrapper alloc] initWithManagedObjectId:recipient.objectID firstname:recipient.name lastName:nil email:email];
        [result addObject:wrapper];
    }
	
    self.results = result;
}

@end
