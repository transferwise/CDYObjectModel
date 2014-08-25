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
#import "EmailLookupWrapper.h"
#import "PhoneLookupWrapper.h"
#import "Constants.h"

#define cachedNameLookup @"nameLookup"
#define cachedImageLookup @"imageLookup"

#define addressBookChangeNotification @"addressBookChangeNotification"

#define facebookAddresSuffix @"@facebook.com"


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

- (void)getNameLookupWithHandler:(LookupHandler)handler
{
	[self getLookupWithBlock:^NSArray *{
		return [self getImmutableNameLookup];
	}
					handler:handler];
}

- (void)getPhoneLookupWithHandler:(LookupHandler)handler
{
	[self getLookupWithBlock:^NSArray *{
		return [self getImmutableImageLookup];
	}
					 handler:handler];
}

- (void)getLookupWithBlock:(NSArray *(^)())lookup handler:(LookupHandler)handler
{
	[self getAddressBookAndExecuteInBackground:^(BOOL hasAddressBook) {
		if (handler)
		{
			if(hasAddressBook)
			{
				NSArray *result = lookup();
				[self performBlockOnMainThread:^{
					handler(result);
				}];
			}
			else
			{
				[self performBlockOnMainThread:^{
					handler(nil);
				}];
			}
		}
	}];
}

- (void)getImageForEmail:(NSString*)email completion:(void(^)(UIImage* image))completionBlock
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
            EmailLookupWrapper *wrapper = filteredResult[0];
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

-(void)retrieveNames:(LookupHandler)handler
{
    if(handler)
    {
        NSArray *lookup = [self getImmutableNameLookup];
        [self performBlockOnMainThread:^{
            handler(lookup);
        }];
    }
}

- (NSArray*)getImmutableNameLookup
{
	return [self getImmutableLookup:cachedNameLookup
					  handlingBlock:^(NSMutableArray *result, ABRecordRef entry) {
						  NSString *firstname = (__bridge_transfer NSString *)ABRecordCopyValue(entry, kABPersonFirstNameProperty);
						  NSString *lastName =(__bridge_transfer NSString *) ABRecordCopyValue(entry, kABPersonLastNameProperty);
						  NSArray *items = [self getABMultivalueProperty:entry property:kABPersonEmailProperty];
						  
						  for (NSString *email in items)
						  {
							  //ignore @facebook.com addresses
							  if ([email hasSuffix:facebookAddresSuffix]) continue;
							  
							  EmailLookupWrapper *wrapper = [[EmailLookupWrapper alloc] initWithRecordId:ABRecordGetRecordID(entry) firstname:firstname lastName:lastName email:email];
							  if(wrapper)
							  {
								  [result addObject:wrapper];
							  }
						  }
					  }];
}

- (NSArray *)getImmutableImageLookup
{
	return [self getImmutableLookup:cachedImageLookup
					  handlingBlock:^(NSMutableArray *result, ABRecordRef entry) {
						  if (ABPersonHasImageData(entry))
						  {
							  NSString *firstname = (__bridge_transfer NSString *)ABRecordCopyValue(entry, kABPersonFirstNameProperty);
							  NSString *lastName =(__bridge_transfer NSString *) ABRecordCopyValue(entry, kABPersonLastNameProperty);
							  NSArray *phones = [self getABMultivalueProperty:entry property:kABPersonPhoneProperty];
							  
							  PhoneLookupWrapper *wrapper = [[PhoneLookupWrapper alloc] initWithRecordId:ABRecordGetRecordID(entry)
																							   firstname:firstname
																								lastName:lastName
																								  phones:phones];
							  if(wrapper)
							  {
								  [result addObject:wrapper];
							  }
						  }
					  }];
}

- (NSArray *)getABMultivalueProperty:(ABRecordRef)entry property:(NSInteger)field
{
	CFTypeRef theProperty = ABRecordCopyValue(entry, field);
	NSArray *items = (__bridge_transfer NSArray *) ABMultiValueCopyArrayOfAllValues(theProperty);
	CFRelease(theProperty);
	
	return items;
}

- (NSArray *)getImmutableLookup:(id)key
				  handlingBlock:(void (^)(NSMutableArray* result, ABRecordRef entry))handlingBlock
{
	NSArray *immutableResult = [[AddressBookManager sharedDataCache] objectForKey:key];
	if(!immutableResult)
	{
		CFArrayRef people = ABAddressBookCopyArrayOfAllPeople(self.addressBook);
		NSInteger count = CFArrayGetCount(people);
		NSMutableArray *result = [NSMutableArray arrayWithCapacity:count];
		
		for(NSInteger i = 0; i < count; i++)
		{
			ABRecordRef record = CFArrayGetValueAtIndex(people, i);
			
			handlingBlock(result, record);
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

- (void)requestAddressBookWithHandler:(ABAddressBookRequestAccessCompletionHandler)handler
{
    ABAddressBookRef addressBook = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if(addressBook)
	{
        //Use a semaphore to ensure the dispatch queue is blocked until the addressbook has been set up.
        //otherwise mutiple calls can happen, leading to self.addressbook being re-assigned, leading to deallocated instances being called -> crash.
        dispatch_semaphore_t sema = dispatch_semaphore_create(0);
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
            dispatch_async(self.dispatchQueue, ^{
                handler(granted,error);
            });
            dispatch_semaphore_signal(sema);
        });
        //This should block the local dispatch queue until the address boook has been set up.
        dispatch_semaphore_wait(sema, DISPATCH_TIME_FOREVER);
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
