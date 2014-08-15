//
//  AddressBookManager.h
//  Transfer
//
//  Created by Mats Trovik on 16/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <AddressBook/AddressBook.h>

typedef void(^NameLookupHandler)(NSArray* nameLookup);


@interface AddressBookManager : NSObject

/**
 *  Get an array of NameLookupWrapper objects for all entries in the address book.
 *
 *  Executes asychronously and completeson the main thread.
 *
 *  @param handler calls back with an array with 0 or more entries, or nil if no access granted by user, on the main thread.
 */
-(void)getNameLookupWithHandler:(NameLookupHandler)handler;

/**
 *  Retrieves the profile image for an ABRecord ID and renders it to a UI image
 *
 *  Excecutes asynchronously and completes on the main thread.
 *
 *  @param recordId        recod to retrieve image for
 *  @param completionBlock calls back with a rendered image or nil on the main thread.
 */
-(void)getImageForRecordId:(ABRecordID)recordId completion:(void(^)(UIImage* image))completionBlock;

/**
 *  Retrieves the profile image matching the provided email based on addressbook records
 *
 *  Executes asynchronously and completes on a the main thread.
 *
 *  @param email           email adress to look for.
 *  @param completionBlock calls back on a background thread with an ABRecordID or 0 if none found.
 */
-(void)getImageForEmail:(NSString*)email completion:(void(^)(UIImage* image))completionBlock;


/**
 *  Singleton instance
 *
 *  introduced as use of Addressbook manager increased when dynamically loading profile images from addressbook.
 *  can potentially be removed if support for profile pictures is introduced on the backend.
 *
 *  @return singleton instance.
 */
+ (AddressBookManager *)sharedInstance;

/**
 *  Singleton instance of ABAddressBookRef intended for UI use. @deprecated
 *
 *  @return address book for use on main thread.
 */
+(ABAddressBookRef)sharedMainThreadAddressbook;


void addressBookExternalChangeCallback (ABAddressBookRef notificationaddressbook,CFDictionaryRef info,void *context);

@end
