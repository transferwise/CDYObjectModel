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

-(void)getNameLookupWithHandler:(NameLookupHandler)handler;
-(void)getImageForRecordId:(ABRecordID)recordId completion:(void(^)(UIImage* image))completionBlock;

void addressBookExternalChangeCallback (ABAddressBookRef notificationaddressbook,CFDictionaryRef info,void *context);

@end
