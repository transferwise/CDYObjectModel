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
@property (nonatomic, strong) NSCache *dataCache;
@end

@implementation AddressBookManager

-(void)dealloc
{
    if (self.addressBook != NULL)
    {
        CFRelease(self.addressBook);
    }
    
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

-(void)getNameLookupWithHandler:(NameLookupHandler)handler
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        if (self.addressBook == NULL)
        {
            [self requestAddressBookWithHandler:^(bool granted, CFErrorRef error) {
                [self retrieveNames:handler];
            }];
        }
        else
        {
            [self retrieveNames:handler];
        }
    });
}

-(void)retrieveNames:(NameLookupHandler)handler
{
    
    NSArray *immutableResult = [self.dataCache objectForKey:cachedNameLookup];
    if(!immutableResult)
    {
        CFArrayRef people =ABAddressBookCopyArrayOfAllPeople(self.addressBook);
        NSInteger count = CFArrayGetCount(people);
        NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
        for(NSInteger i = 0; i < count; i++)
    {
        ABRecordRef record = CFArrayGetValueAtIndex(people, i);
        NameLookupWrapper *wrapper = [[NameLookupWrapper alloc] initWithId:ABRecordGetRecordID(record) firstname:(__bridge NSString *)(ABRecordCopyValue(record, kABPersonFirstNameProperty)) lastName:(__bridge NSString *)(ABRecordCopyValue(record, kABPersonLastNameProperty)) nickName:(__bridge NSString *)(ABRecordCopyValue(record, kABPersonNicknameProperty))];
        if(wrapper)
        {
            [result addObject:wrapper];
        }
    }
        
        immutableResult = [NSArray arrayWithArray:result];
        
        [self.dataCache setObject:immutableResult forKey:cachedNameLookup];
    
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
    if ([wrappedSelf.dataCache objectForKey:cachedNameLookup])
    {
        [wrappedSelf.dataCache removeObjectForKey:cachedNameLookup];
        [wrappedSelf retrieveNames:nil];
    }
}

- (void)requestAddressBookWithHandler:(ABAddressBookRequestAccessCompletionHandler)handler {
    
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if(addressBook) {
        self.addressBook = addressBook;
        /*
         Register for a callback if the addressbook data changes this is important to be notified of new data when the user grants access to the contacts. the application should also be able to handle a nil object being returned as well if the user denies access to the address book.
         */
        ABAddressBookRegisterExternalChangeCallback(self.addressBook, addressBookExternalChangeCallback, (__bridge void *)(self));
        
        /*
         When the application requests to receive address book data that is when the user is presented with a consent dialog.
         */
        ABAddressBookRequestAccessWithCompletion(self.addressBook, ^(bool granted, CFErrorRef error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                if (granted) {
                    [[GoogleAnalytics sharedInstance] sendEvent:@"ABpermission" category:@"permission" label:@"granted"];
                    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(handleAddressBookChange:) name:addressBookChangeNotification object:nil];
                } else {
                    [[GoogleAnalytics sharedInstance] sendEvent:@"ABpermission" category:@"permission" label:@"declined"];
                    CFRelease(self.addressBook);
                    self.addressBook = NULL;
                }
                handler(granted,error);
            });
        });
    }
}

-(NSCache *)dataCache
{
    //Lazy load data cache
    if (! _dataCache)
    {
        _dataCache = [[NSCache alloc] init];
    }
    
    return _dataCache;
}

@end
