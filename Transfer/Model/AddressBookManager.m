//
//  AddressBookManager.m
//  Transfer
//
//  Created by Mats Trovik on 16/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "AddressBookManager.h"
#import <AddressBook/AddressBook.h>
#import "GoogleAnalytics.h"
#import "NameLookupWrapper.h"

#define cachedNameLookup @"nameLookup"

#define addressBookChangeNotification @"addressBookChangeNotification"


@interface AddressBookManager ()
@property (nonatomic,assign) ABAddressBookRef addressBook;

+(NSCache*)sharedDataCache;

@end

@implementation AddressBookManager

-(void)getNameLookupWithHandler:(NameLookupHandler)handler
{
    [self getAddressBookAndExecuteInBackground:^(BOOL hasAddressBook) {
        if(hasAddressBook)
        {
            [self retrieveNames:handler];
        }
        else
        {
            if(handler)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    handler(nil);
                });
            }
        }
    }];
}

-(void)getImageForRecordId:(ABRecordID)recordId completion:(void(^)(UIImage* image))completionBlock{
    if(!completionBlock)
    {
        return;
    }
    
    UIImage *cachedResult = [[AddressBookManager sharedDataCache] objectForKey:[self thumbnailKeyForRecord:recordId]];
    if(cachedResult)
    {
        completionBlock(cachedResult);
        return;
    }
    [self getAddressBookAndExecuteInBackground:^(BOOL hasAddressBook) {
        UIImage *result;
        if (hasAddressBook)
        {
            ABRecordRef person = ABAddressBookGetPersonWithRecordID(self.addressBook, recordId);
            CFDataRef imageData = ABPersonCopyImageDataWithFormat(person, kABPersonImageFormatThumbnail);
            if(imageData != NULL)
            {
                result = [UIImage imageWithData:(__bridge NSData *)(imageData)];
                CFRelease(imageData);
                if(result)
                {
                    [[AddressBookManager sharedDataCache] setObject:result forKey:[self thumbnailKeyForRecord:recordId]];
                }
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            completionBlock(result);
        });
    }];
}

-(void)getAddressBookAndExecuteInBackground:(void(^)(BOOL hasAddressBook))excecutionBlock
{
    if(excecutionBlock)
    {
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            if (self.addressBook == NULL)
            {
                [self requestAddressBookWithHandler:^(bool granted, CFErrorRef error) {
                    excecutionBlock(self.addressBook != nil);
                }];
            }
            else
            {
                excecutionBlock(YES);
            }
        });
    }
}


-(void)retrieveNames:(NameLookupHandler)handler
{
    
    NSArray *immutableResult = [[AddressBookManager sharedDataCache] objectForKey:cachedNameLookup];
    if(!immutableResult)
    {
        CFArrayRef people =ABAddressBookCopyArrayOfAllPeople(self.addressBook);
        NSInteger count = CFArrayGetCount(people);
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
        for(NSInteger i = 0; i < count; i++)
        {
            ABRecordRef record = CFArrayGetValueAtIndex(people, i);
            
            CFTypeRef theProperty = ABRecordCopyValue(record, kABPersonEmailProperty);
            NSArray *items = (__bridge_transfer NSArray *) ABMultiValueCopyArrayOfAllValues(theProperty);
            NSString *email = [items lastObject];
            CFRelease(theProperty);
            
            NameLookupWrapper *wrapper = [[NameLookupWrapper alloc] initWithId:ABRecordGetRecordID(record) firstname:(__bridge NSString *)(ABRecordCopyValue(record, kABPersonFirstNameProperty)) lastName:(__bridge NSString *)(ABRecordCopyValue(record, kABPersonLastNameProperty)) email:email nickName:(__bridge NSString *)(ABRecordCopyValue(record, kABPersonNicknameProperty))];
    
            if(wrapper)
            {
                [result addObject:wrapper];
            }
        }
        
        immutableResult = [NSArray arrayWithArray:result];
        CFRelease(people);
        
        [[AddressBookManager sharedDataCache] setObject:immutableResult forKey:cachedNameLookup];
        
    }
    
    if(handler)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            handler(immutableResult);
        });
    }
}


#pragma mark - Address book access


void addressBookExternalChangeCallback (ABAddressBookRef notificationaddressbook,CFDictionaryRef info,void *context)
{
    AddressBookManager *wrappedSelf = (__bridge AddressBookManager*) context;
  dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
       if ([[AddressBookManager sharedDataCache] objectForKey:cachedNameLookup])
       {
           [[AddressBookManager sharedDataCache] removeObjectForKey:cachedNameLookup];
           [wrappedSelf retrieveNames:nil];
       }
  });
}

- (void)requestAddressBookWithHandler:(ABAddressBookRequestAccessCompletionHandler)handler {
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if(addressBook) {
        ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
                if (granted) {
                    self.addressBook = addressBook;
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[GoogleAnalytics sharedInstance] sendEvent:@"ABpermission" category:@"permission" label:@"granted"];
                        ABAddressBookRegisterExternalChangeCallback(self.addressBook, addressBookExternalChangeCallback, (__bridge void *)(self));
                    });
                } else {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        [[GoogleAnalytics sharedInstance] sendEvent:@"ABpermission" category:@"permission" label:@"declined"];
                    });
                    self.addressBook = NULL;
                }
                handler(granted,error);
        });
    }
}

-(NSString*)thumbnailKeyForRecord:(ABRecordID)recordId
{
    return [NSString stringWithFormat:@"TN:%d",recordId];
}


static NSCache* dataCache;
+(NSCache *)sharedDataCache
{
    //Lazy load data cache
    if (! dataCache)
    {
        dataCache = [[NSCache alloc] init];
    }
    
    return dataCache;
}

static ABAddressBookRef mainThreadAddressBook;
+(ABAddressBookRef)sharedMainThreadAddressbook
{
    if ([NSThread isMainThread])
    {
        if (mainThreadAddressBook == NULL)
        {
            ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
            
            if(addressBook) {
                
                dispatch_semaphore_t sema = dispatch_semaphore_create(0);
                
                ABAddressBookRequestAccessWithCompletion(addressBook, ^(bool granted, CFErrorRef error) {
                    if(granted)
                    {
                        mainThreadAddressBook = addressBook;
                    }
                    if (!granted) {
                        mainThreadAddressBook = NULL;
                    }
                    dispatch_semaphore_signal(sema);
                });
                
                dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);

            }
        }
        return mainThreadAddressBook;
    }
    return NULL;
}


@end
