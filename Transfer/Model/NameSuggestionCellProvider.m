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


@interface NameSuggestionCellProvider ()

@property (nonatomic, strong) AddressBookManager* addressBookManager;
@property (nonatomic, strong) NSArray* dataSource;
@property (copy) NSString* filterString;
@property (nonatomic, strong) UINib *cellNib;

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
                NSMutableArray* workArray = [nameLookup mutableCopy];
                
                NSArray* firstnameMatches = [workArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NameLookupWrapper* evaluatedObject, NSDictionary *bindings) {
                    return evaluatedObject.firstName && [[evaluatedObject.firstName lowercaseString] rangeOfString:self.filterString].location == 0;
                }]];
                firstnameMatches = [firstnameMatches sortedArrayUsingComparator:^NSComparisonResult(NameLookupWrapper* obj1, NameLookupWrapper* obj2) {
                    return [obj1.firstName caseInsensitiveCompare:obj2.firstName];
                }];
                [workArray removeObjectsInArray:firstnameMatches];
                
                NSArray* lastnameMatches = [workArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NameLookupWrapper* evaluatedObject, NSDictionary *bindings) {
                    return evaluatedObject.lastName && [[evaluatedObject.lastName lowercaseString] rangeOfString:self.filterString].location == 0;
                }]];
                lastnameMatches = [lastnameMatches sortedArrayUsingComparator:^NSComparisonResult(NameLookupWrapper* obj1, NameLookupWrapper* obj2) {
                    return [obj1.lastName caseInsensitiveCompare:obj2.lastName];
                }];
                [workArray removeObjectsInArray:lastnameMatches];
                
                NSArray* nicknameMatches = [workArray filteredArrayUsingPredicate:[NSPredicate predicateWithBlock:^BOOL(NameLookupWrapper* evaluatedObject, NSDictionary *bindings) {
                    return evaluatedObject.nickName && [[evaluatedObject.nickName lowercaseString] rangeOfString:self.filterString].location == 0;
                }]];
                nicknameMatches = [nicknameMatches sortedArrayUsingComparator:^NSComparisonResult(NameLookupWrapper* obj1, NameLookupWrapper* obj2) {
                    return [obj1.nickName caseInsensitiveCompare:obj2.nickName];
                }];
                [workArray removeObjectsInArray:nicknameMatches];
                
                self.dataSource = @[firstnameMatches, lastnameMatches, nicknameMatches];
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
    NameSuggestionCell* cell = (NameSuggestionCell*)[tableView dequeueReusableCellWithIdentifier:@"NameSuggestionCell"];
    
    NameLookupWrapper* wrapper = self.dataSource[indexPath.section][indexPath.row];
    switch (indexPath.section) {
        case 2:
            cell.nameLabel.text = [wrapper presentableString:NickNameFirst];
            break;
        case 1:
            cell.nameLabel.text = [wrapper presentableString:LastNameFirst];
            break;
        case 0:
        default:
            cell.nameLabel.text = [wrapper presentableString:FirstNameFirst];
            break;
    }
    
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



@end
