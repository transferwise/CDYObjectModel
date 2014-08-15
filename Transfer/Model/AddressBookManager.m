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
#import "Constants.h"

#define cachedNameLookup @"nameLookup"

#define addressBookChangeNotification @"addressBookChangeNotification"


@interface AddressBookManager ()
@property (nonatomic,assign) ABAddressBookRef addressBook;
@property (nonatomic,strong) dispatch_queue_t dispatchQueue;

+(NSCache*)sharedDataCache;

@end

@implementation AddressBookManager

+ (AddressBookManager *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        AddressBookManager *manager = [[self alloc] init];
        return manager;
    });
}

-(id)init
{
    self = [super init];
    if(self)
    {
        self.dispatchQueue = dispatch_queue_create("com.transferwise.addressBookManagerQueue", NULL);
    }
    return self;
}

-(void)dealloc
{
    if(_addressBook)
    {
        CFRelease(_addressBook);
    }
}

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
                [self performBlockOnMainThread:^{
                   handler(nil); 
                }];
            }
        }
    }];
}

-(void)getImageForEmail:(NSString*)email completion:(void(^)(UIImage* image))completionBlock
{
    
    NSNumber *recordIdNumber = [[AddressBookManager sharedDataCache] objectForKey:email];
    if(recordIdNumber)
    {
        [self getImageForRecordId:(ABRecordID)[recordIdNumber integerValue] completion:completionBlock];
        return;
    }
    
    [self getAddressBookAndExecuteInBackground:^(BOOL hasAddressBook) {
        
        NSArray* nameLookup = [self getImmutableNameLookup];
        NSArray* filteredResult = [nameLookup filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"email = %@",email]];
        if([filteredResult count])
        {
            NameLookupWrapper *wrapper = filteredResult[0];
            ABRecordID recordId = wrapper.recordId;
            [[AddressBookManager sharedDataCache] setObject:@(recordId) forKey:email];
            [self getImageForRecordId:recordId completion:completionBlock];
            return;
        }
        [self performBlockOnMainThread:^{
            completionBlock(nil);
        }];
    }];
}

-(void)getImageForRecordId:(ABRecordID)recordId completion:(void(^)(UIImage* image))completionBlock{
    if(!completionBlock)
    {
        return;
    }
    
    if(recordId == kABRecordInvalidID)
    {
        [self performBlockOnMainThread:^{
            completionBlock(nil);
            return;
        }];
    }
    
    UIImage *cachedResult = [[AddressBookManager sharedDataCache] objectForKey:[self thumbnailKeyForRecord:recordId]];
    if(cachedResult)
    {
        [self performBlockOnMainThread:^{
            completionBlock(cachedResult);
            return;
        }];
        
    }
    [self getAddressBookAndExecuteInBackground:^(BOOL hasAddressBook) {
        UIImage *result;
        if (hasAddressBook)
        {
            ABRecordRef person = ABAddressBookGetPersonWithRecordID(self.addressBook, recordId);
            if(ABPersonHasImageData(person))
            {
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
        }
        [self performBlockOnMainThread:^{
            completionBlock(result);
        }];
    }];
}

-(void)getAddressBookAndExecuteInBackground:(void(^)(BOOL hasAddressBook))excecutionBlock
{
    if(excecutionBlock)
    {
        dispatch_async(self.dispatchQueue, ^{
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
    if(handler)
    {
        NSArray *lookup = [self getImmutableNameLookup];
        [self performBlockOnMainThread:^{
            handler(lookup);
        }];
        
    }
}

-(NSArray*)getImmutableNameLookup
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
            
            NSString *firstname = (__bridge_transfer NSString *)ABRecordCopyValue(record, kABPersonFirstNameProperty);
            NSString *lastName =(__bridge_transfer NSString *) ABRecordCopyValue(record, kABPersonLastNameProperty);
            
            
            CFTypeRef theProperty = ABRecordCopyValue(record, kABPersonEmailProperty);
            NSArray *items = (__bridge_transfer NSArray *) ABMultiValueCopyArrayOfAllValues(theProperty);
            CFRelease(theProperty);
            for(NSString *email in items)
            {
                NameLookupWrapper *wrapper = [[NameLookupWrapper alloc] initWithRecordId:ABRecordGetRecordID(record) firstname:firstname lastName:lastName email:email];
                if(wrapper)
                {
                    [result addObject:wrapper];
                }
            }
        }
        
        immutableResult = [NSArray arrayWithArray:result];
        CFRelease(people);
        
        [[AddressBookManager sharedDataCache] setObject:immutableResult forKey:cachedNameLookup];
        
    }
    return immutableResult;
}


#pragma mark - Address book access


void addressBookExternalChangeCallback (ABAddressBookRef notificationaddressbook,CFDictionaryRef info,void *context)
{
    AddressBookManager *wrappedSelf = (__bridge AddressBookManager*) context;
  dispatch_async(wrappedSelf.dispatchQueue, ^{
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

#pragma mark - completion helper
-(void)performBlockOnMainThread:(void(^)(void)) block
{
    if([NSThread isMainThread])
    {
        block();
    }
    else
    {
        dispatch_async(dispatch_get_main_queue(), ^{
             block();
        });
    }
}


@end
