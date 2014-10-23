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
#import "Payment.h"

@implementation ObjectModel (PayInMethod)

-(void)createOrUpdatePayInMethodsWithData:(NSArray*)data forPayment:(Payment*)payment
{
    NSMutableOrderedSet *objectsToDelete = [payment.payInMethods mutableCopy];
    NSOrderedSet *existingTypes = [payment.payInMethods valueForKey:@"type"];
    NSMutableOrderedSet *newSet = [NSMutableOrderedSet orderedSetWithCapacity:[data count]];
    
    for(NSDictionary* payInMethodDictionary in data)
    {
        PayInMethod* method;
        NSString *typeName = payInMethodDictionary[@"type"];
        if([existingTypes containsObject:typeName])
        {
            method = [payment.payInMethods objectAtIndex:[existingTypes indexOfObject:typeName]];
            [objectsToDelete removeObject:method];
        }
        else
        {
            method = [PayInMethod insertInManagedObjectContext:self.managedObjectContext];
            method.type = typeName;
        }
        
        NSDictionary* recipientDetails = payInMethodDictionary[@"recipient"];
        if(recipientDetails)
        {
            method.recipient = [self createOrUpdatePayInMethodRecipientWithData:recipientDetails];
        }
        method.bankName = payInMethodDictionary[@"bankName"];
        method.transferWiseAddress = payInMethodDictionary[@"transferwiseAddress"];
        //TODO: m@s Remove special cases for ADYEN and SOFORT when supported
        method.disabled = @([payInMethodDictionary[@"disabled"] boolValue] || [method.type caseInsensitiveCompare:@"SOFORT"] == NSOrderedSame || [method.type caseInsensitiveCompare:@"ADYEN"] == NSOrderedSame );
        method.disabledReason = payInMethodDictionary[@"disabledReason"];
		method.paymentReference = payInMethodDictionary[@"paymentReference"];
        
        [newSet addObject:method];
    }
    
    payment.payInMethods = newSet;
    for(NSManagedObject* toDelete in objectsToDelete)
    {
        [self.managedObjectContext deleteObject:toDelete];
    }
}


@end
