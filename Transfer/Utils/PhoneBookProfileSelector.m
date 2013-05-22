//
//  PhoneBookProfileSelector.m
//  Transfer
//
//  Created by Jaanus Siim on 5/22/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <AddressBook/AddressBook.h>
#import <AddressBookUI/AddressBookUI.h>
#import "PhoneBookProfileSelector.h"
#import "PhoneBookProfile.h"
#import "Constants.h"

@interface PhoneBookProfileSelector () <ABPeoplePickerNavigationControllerDelegate>

@property (nonatomic, copy) PhoneBookProfileBlock completionHandler;

@end

@implementation PhoneBookProfileSelector

- (void)presentOnController:(UIViewController *)controller completionHandler:(PhoneBookProfileBlock)completion {
    self.completionHandler = completion;
    ABPeoplePickerNavigationController *pickerController = [[ABPeoplePickerNavigationController alloc] init];
    [pickerController setDisplayedProperties:@[@(kABPersonFirstNameProperty), @(kABPersonLastNameProperty), @(kABPersonEmailProperty), @(kABPersonBirthdayProperty), @(kABPersonAddressProperty)]];
    pickerController.peoplePickerDelegate = self;
    [controller presentViewController:pickerController animated:YES completion:nil];
}

- (void)peoplePickerNavigationControllerDidCancel:(ABPeoplePickerNavigationController *)peoplePicker {
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person {
    PhoneBookProfile *profile = [[PhoneBookProfile alloc] initWithRecord:person];
    [profile loadData];

    if ([profile addressesCount] > 1) {
        return YES;
    }

    self.completionHandler(profile);
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];
    return NO;
}

- (BOOL)peoplePickerNavigationController:(ABPeoplePickerNavigationController *)peoplePicker shouldContinueAfterSelectingPerson:(ABRecordRef)person property:(ABPropertyID)property identifier:(ABMultiValueIdentifier)identifier {
    if (property != kABPersonAddressProperty) {
        return NO;
    }

    MCLog(@"Tapped on address...");
    PhoneBookProfile *profile = [[PhoneBookProfile alloc] initWithRecord:person selectedAddressIdentifier:identifier];
    [profile loadData];
    self.completionHandler(profile);
    [peoplePicker dismissViewControllerAnimated:YES completion:nil];

    return NO;
}

@end
