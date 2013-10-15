//
//  ObjectModel+Settings.m
//  Transfer
//
//  Created by Jaanus Siim on 10/15/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+Settings.h"
#import "Setting.h"
#import "ObjectModel+Payments.h"
#import "Constants.h"

typedef NS_ENUM(short, SettingKey) {
    SettingRatingShown
};

@implementation ObjectModel (Settings)

- (BOOL)shouldShowRatingPopup {
    BOOL hasBeenShown = ![self booleanValueForKey:SettingRatingShown defaultValue:NO];
    if (hasBeenShown) {
        return NO;
    }

    return [self hasCompletedPayments];
}

- (void)markReviewPopupShown {
    MCLog(@"markReviewPopupShown");
    [self setBooleanValue:YES forKey:SettingRatingShown];
}

- (Setting *)loadSettingForKey:(SettingKey)key {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"key = %d", key];
    return [self fetchEntityNamed:[Setting entityName] withPredicate:predicate];
}

- (BOOL)booleanValueForKey:(SettingKey)key defaultValue:(BOOL)defaultValue {
    Setting *setting = [self loadSettingForKey:key];
    if (!setting) {
        return defaultValue;
    }

    return [setting booleanValue];
}

- (void)setBooleanValue:(BOOL)value forKey:(SettingKey)key {
    Setting *setting = [self loadSettingForKey:key];
    if (!setting) {
        setting = [Setting insertInManagedObjectContext:self.managedObjectContext];
        [setting setKeyValue:key];
    }

    [setting setBooleanValue:value];
    [self saveContext];
}

@end
