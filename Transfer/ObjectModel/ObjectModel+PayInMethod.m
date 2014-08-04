//
//  ObjectModel+PayInMethod.m
//  Transfer
//
//  Created by Mats Trovik on 18/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel+PayInMethod.h"
#import "ObjectModel+Recipients.h"
#import "PayInMethod.h"
#import <objc/runtime.h>

@implementation ObjectModel (PayInMethod)

-(NSOrderedSet*)createPayInMethodsWithData:(NSArray*)data
{
    NSMutableOrderedSet *result = [[NSMutableOrderedSet alloc] initWithCapacity:[data count]];
    for(NSDictionary* payInMethodDictionary in data)
    {
        PayInMethod* method = [PayInMethod insertInManagedObjectContext:self.managedObjectContext];
        NSDictionary* recipientDetails = payInMethodDictionary[@"recipient"];
        if(recipientDetails)
        {
            method.recipient = [self createOrUpdatePayInMethodRecipientWithData:recipientDetails];
        }
        method.bankName = payInMethodDictionary[@"bankName"];
        method.type = payInMethodDictionary[@"type"];
        method.transferWiseAddress = payInMethodDictionary[@"transferwiseAddress"];
        //TODO: m@s Remove special cases for SOFORT and SWIFT when supported
        method.disabled = @([payInMethodDictionary[@"disabled"] boolValue] || [method.type caseInsensitiveCompare:@"SOFORT"] == NSOrderedSame || [method.type caseInsensitiveCompare:@"SWIFT"] == NSOrderedSame);
        method.disabledReason = payInMethodDictionary[@"disabledReason"];
		method.paymentReference = payInMethodDictionary[@"paymentReference"];
        
        [result addObject:method];
    }
    return [[NSOrderedSet alloc] initWithOrderedSet:result];
}


@end
