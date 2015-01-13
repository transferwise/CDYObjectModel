//
//  RepeatTransferHelper.m
//  Transfer
//
//  Created by Mats Trovik on 13/01/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "RepeatTransferHelper.h"
#import "PendingPayment.h"
#import "ObjectModel+PendingPayments.h"
#import "ObjectModel+CurrencyPairs.h"
#import "ObjectModel+RecipientTypes.h"
#import "TransferCalculationsOperation.h"
#import "Currency.h"
#import "CalculationResult.h"
#import "TRWAlertView.h"
#import "PairSourceCurrency.h"
#import "PairTargetCurrency.h"
#import "RecipientTypesOperation.h"
#import "CurrenciesOperation.h"

@interface RepeatTransferHelper ()

@property (nonatomic, strong) TransferwiseOperation* currentOperation;

@end

@implementation RepeatTransferHelper


-(void)repeatTransfer:(Payment*)paymentToRepeat objectModel:(ObjectModel*)objectModel
{
    
    Currency *sourceCurrency = [paymentToRepeat sourceCurrency];
    Currency *targetCurrency = [paymentToRepeat targetCurrency];

    
    NSString *amount = [paymentToRepeat.isFixedAmountValue?paymentToRepeat.payOutString:paymentToRepeat.payInString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *source = paymentToRepeat.sourceCurrency.code;
    NSString *target = paymentToRepeat.targetCurrency.code;
    
    TransferCalculationsOperation *operation = [TransferCalculationsOperation operationWithAmount:amount source:source target:target];
    
    [operation setAmountCurrency:paymentToRepeat.isFixedAmountValue?TargetCurrency:SourceCurrency];
    __weak typeof(self) weakSelf = self;
    [operation setRemoteCalculationHandler:^(CalculationResult *result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.currentOperation = nil;
            if (result) {
                [self createPendingPaymentWithObjectModel:objectModel source:sourceCurrency target:targetCurrency calculationResult:result recipient:paymentToRepeat.recipient profile:paymentToRepeat.profileUsed successBlock:^(PendingPayment *payment) {
                    
                } successBlock:^(NSError *error) {
                    
                }];
            
            }
        });
    }];
    
    self.currentOperation = operation;
    [operation execute];
    
}

-(void)createPendingPaymentWithObjectModel:(ObjectModel*)objectModel source:(Currency*)sourceCurrency target:(Currency*)targetCurrency calculationResult:(CalculationResult*)result recipient:(Recipient*)recipient profile:(NSString*)profile successBlock:(void(^)(PendingPayment* payment))successBlock successBlock:(void(^)(NSError* error))failureBlock
{
    PairSourceCurrency *source = [objectModel pairSourceWithCurrency:sourceCurrency];
    PairTargetCurrency *target = [objectModel pairTargetWithSource:sourceCurrency target:targetCurrency];
    NSNumber *payIn = [result transferwisePayIn];
    
    if (![target acceptablePayIn:payIn])
    {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"transfer.pay.in.too.low.title", nil) message:[NSString stringWithFormat:NSLocalizedString(@"transfer.pay.in.too.low.message.base", nil), target.minInvoiceAmount, target.source.currency.code]];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }
    else if (![source acceptablePayIn:payIn])
    {
        TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"transfer.pay.in.too.high.title", nil) message:[NSString stringWithFormat:NSLocalizedString(@"transfer.pay.in.too.high.message.base", nil), source.maxInvoiceAmount, source.currency.code]];
        [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok", nil)];
        [alertView show];
        return;
    }
    
//    if([@"USD" caseInsensitiveCompare:sourceCurrency.code] == NSOrderedSame && [payIn floatValue] < 3.0f)
//    {
//        CustomInfoViewController *customInfo = [[CustomInfoViewController alloc] init];
//        customInfo.titleText = NSLocalizedString(@"usd.low.title",nil);
//        customInfo.infoText = NSLocalizedString(@"usd.low.info",nil);
//        customInfo.actionButtonTitle = NSLocalizedString(@"usd.low.dismiss",nil);
//        customInfo.infoImage = [UIImage imageNamed:@"illustration_under1500usd"];
//        [customInfo presentOnViewController:self];
//        return;
//    }
    
    RecipientTypesOperation *operation = [RecipientTypesOperation operation];
    [operation setObjectModel:objectModel];
    operation.sourceCurrency = sourceCurrency.code;
    operation.targetCurrency = targetCurrency.code;
    operation.amount = [result transferwisePayIn];
    
    self.currentOperation = operation;
     __weak typeof(self) weakSelf = self;
    [operation setResultHandler:^(NSError *error, NSArray* listOfRecipientTypeCodes) {
        if (error) {
            return;
        }
        
        void (^dataLoadCompletionBlock)() = ^() {
            dispatch_async(dispatch_get_main_queue(), ^{
                
                [objectModel performBlock:^{
                    PendingPayment *payment = [objectModel createPendingPayment];
                    [payment setSourceCurrency:sourceCurrency];
                    [payment setTargetCurrency:targetCurrency];
                    [payment setPayIn:(NSDecimalNumber *) [result transferwisePayIn]];
                    [payment setPayOut:(NSDecimalNumber *) [result transferwisePayOut]];
                    [payment setConversionRate:[result transferwiseRate]];
                    [payment setEstimatedDelivery:[result estimatedDelivery]];
                    [payment setEstimatedDeliveryStringFromServer:[result formattedEstimatedDelivery]];
                    [payment setTransferwiseTransferFee:[result transferwiseTransferFee]];
                    [payment setIsFixedAmountValue:result.isFixedTargetPayment];
                    [payment setRecipient:recipient];
                    [payment setProfileUsed:profile];
                    payment.allowedRecipientTypes = [NSOrderedSet orderedSetWithArray:[objectModel recipientTypesWithCodes:listOfRecipientTypeCodes]];
                    
                    successBlock(payment);
                    
                }];
            });
        };
        
        CurrenciesOperation *currenciesOperation = [CurrenciesOperation operation];
        [currenciesOperation setObjectModel:objectModel];
        [currenciesOperation setResultHandler:^(NSError *error) {
            weakSelf.currentOperation = nil;
            if (error) {
                TRWAlertView *alertView = [TRWAlertView errorAlertWithTitle:NSLocalizedString(@"recipient.controller.recipient.types.load.error.title", nil) error:error];
                [alertView show];
                return;
            }
            
            dataLoadCompletionBlock();
            
        }];
        weakSelf.currentOperation = currenciesOperation;
        [currenciesOperation execute];
    }];
    [operation execute];
}

@end
