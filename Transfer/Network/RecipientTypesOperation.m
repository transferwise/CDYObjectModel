//
//  RecipientTypesOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/3/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RecipientTypesOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Constants.h"
#import "ObjectModel+RecipientTypes.h"

NSString *const kRecipientTypesPath = @"/recipient/listTypes";

@implementation RecipientTypesOperation

static RecipientTypesOperation *runningAllTypesOperation;
static NSMutableSet *allTypesOperationsWaitingForResponse;

- (void)execute {
    __block __weak RecipientTypesOperation *weakSelf = self;
    
    if(![self shouldExecuteRequest:weakSelf])
    {
        return;
    }
    
    NSString *path = [self addTokenToPath:kRecipientTypesPath];

    [self setOperationErrorHandler:^(NSError *error) {
        [weakSelf completeRequest:weakSelf error:error typeList:nil];
    }];

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf.workModel.managedObjectContext performBlock:^{
            NSArray *recipients = response[@"recipients"];
            MCLog(@"Pulled %lu receipient types", (unsigned long)[recipients count]);
            NSDictionary* commonData;
            if(weakSelf.sourceCurrency)
            {
                BOOL addressRequired = [response[@"recipientAddressRequired"] boolValue];
                commonData = @{@"recipientAddressRequired":@(addressRequired)};
            }
            
            [weakSelf.workModel createOrUpdateRecipientTypesWithData:recipients commonAdditions:commonData];
            
            [weakSelf.workModel saveContext:^{
                [weakSelf completeRequest:weakSelf error:nil typeList:[recipients valueForKey:@"type"]];
            }];
        }];
    }];

    if(self.sourceCurrency)
    {
        [self getDataFromPath:path params:@{@"sourceCurrency":self.sourceCurrency, @"targetCurrency":self.targetCurrency, @"amount":self.amount, @"amountType":@"source"}];
    }
    else
    {
        [self getDataFromPath:path];
    }
}

-(BOOL)shouldExecuteRequest:(RecipientTypesOperation*)operation
{
    if(!operation.sourceCurrency)
    {
        //No source currency means we're getting a list of all recipient types.
        //We'll only execute one of these requests and keep the others around and call their completion
        //when the request completes.
        
        if(!allTypesOperationsWaitingForResponse)
        {
            allTypesOperationsWaitingForResponse = [NSMutableSet set];
        }
        [allTypesOperationsWaitingForResponse addObject:operation];
        
        if(runningAllTypesOperation)
        {
            return NO;
        }
        else
        {
            runningAllTypesOperation = operation;
        }
    }
    return YES;

}

-(void)completeRequest:(RecipientTypesOperation*)operation error:(NSError*) error typeList:(NSArray*)typeList
{
    if(!operation.sourceCurrency)
    {
        //No source currency means we're getting a list of all recipient types.
        //complete all queued requests
        for(RecipientTypesOperation* target in allTypesOperationsWaitingForResponse)
        {
            target.resultHandler(error,typeList);
        }
        allTypesOperationsWaitingForResponse = nil;
        runningAllTypesOperation = nil;
    }
    else
    {
        operation.resultHandler(error, typeList);
    }
}

+ (RecipientTypesOperation *)operation {
    return [[RecipientTypesOperation alloc] init];
}

@end
