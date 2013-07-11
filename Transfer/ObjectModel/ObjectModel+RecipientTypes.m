//
//  ObjectModel+RecipientTypes.m
//  Transfer
//
//  Created by Jaanus Siim on 7/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+RecipientTypes.h"
#import "RecipientType.h"

@implementation ObjectModel (RecipientTypes)

- (RecipientType *)recipientTypeWithCode:(NSString *)code {
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"type = %@", code];
    return [self fetchEntityNamed:[RecipientType entityName] withPredicate:predicate];
}

@end
