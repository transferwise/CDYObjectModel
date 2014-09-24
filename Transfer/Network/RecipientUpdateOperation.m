//
//  RecipientUpdateOperation.m
//  Transfer
//
//  Created by Mats Trovik on 24/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "RecipientUpdateOperation.h"
#import "TransferwiseOperation+Private.h"
#import "NetworkErrorCodes.h"
#import "Recipient.h"
#import "TypeFieldValue.h"

@implementation RecipientUpdateOperation

static NSString* updatePath = @"recipient/update";

+(instancetype)instanceWithRecipient:(Recipient*)recipient objectModel:(ObjectModel*)objectModel completionHandler:(void (^)(NSError *))completionHandler
{
    RecipientUpdateOperation * operation = [[RecipientUpdateOperation alloc] init];
    operation.objectModel = objectModel;
    operation.recipient = recipient;
    operation.completionHandler = completionHandler;
    return operation;
}


-(void)execute
{
    if(self.recipient && self. objectModel)
    {
        Recipient *recipient = self.recipient;
        NSMutableDictionary* parameters = [NSMutableDictionary dictionary];
        parameters[@"recipientId"] = recipient.remoteId;
        if(recipient.email)
        {
            parameters[@"email"] = recipient.email;
        }
        if(recipient.addressFirstLine)
        {
            parameters[@"addressFirstLine"] = recipient.addressFirstLine;
        }
        if(recipient.addressCity)
        {
            parameters[@"addressCity"] = recipient.addressCity;
        }
        if(recipient.addressPostCode)
        {
            parameters[@"addressPostCode"] = recipient.addressPostCode;
        }
        if(recipient.addressState)
        {
            parameters[@"addressState"] = recipient.addressState;
        }
        if(recipient.addressCountryCode)
        {
            parameters[@"addressCountryCode"] = recipient.addressCountryCode;
        }
        NSOrderedSet* fieldNames = [recipient.fieldValues valueForKeyPath:@"valueForField.name"];
        NSUInteger index = [fieldNames indexOfObject:@"BIC"];
        if(index != NSNotFound)
        {
            TypeFieldValue* value = recipient.fieldValues[index];
            NSString *bic = [value value];
            if(bic)
            {
                parameters[@"bic"] = bic;
            }
        }
        __weak typeof(self) weakSelf = self;
        [self setOperationSuccessHandler:^(NSDictionary *response) {
            if (weakSelf.completionHandler)
            {
                weakSelf.completionHandler(nil);
            }
        }];
        
        [self setOperationErrorHandler:^(NSError *error) {
            if(weakSelf.completionHandler)
            {
                weakSelf.completionHandler(error);
            }
        }];
        
        [self postData:parameters toPath:updatePath];
        

    }
    else
    {
        if(self.completionHandler)
        {
            self.completionHandler([NSError errorWithDomain:TRWErrorDomain code:ResponseLocalError userInfo:nil]);
        }
    }
}
@end
