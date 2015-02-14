//
//  RepeatTransferHelper.m
//  Transfer
//
//  Created by Mats Trovik on 13/01/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "NewPaymentHelper.h"
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
#import "GoogleAnalytics.h"
#import "CurrencyLoader.h"

NSString *const NewTransferErrorDomain = @"NewTransferError";
NSString *const NewTransferNetworkOperationErrorKey = @"NetworkOperationError";
NSString *const NewTransferMinimumAmountKey = @"MinimumAmount";
NSString *const NewTransferMaximumAmountKey = @"MaximumAmount";
NSString *const NewTransferSourceCurrencyCodeKey = @"SourceCurrencyCode";



@interface NewPaymentHelper ()

@property (nonatomic, strong) TransferwiseOperation* currentOperation;

@end

@implementation NewPaymentHelper

-(void)repeatTransfer:(Payment*)paymentToRepeat
		  objectModel:(ObjectModel*)objectModel
		 successBlock:(void(^)(PendingPayment* payment))successBlock
		 failureBlock:(void(^)(NSError* error))failureBlock;
{
    Currency *sourceCurrency = [paymentToRepeat sourceCurrency];
    Currency *targetCurrency = [paymentToRepeat targetCurrency];

    
    NSString *amount = [paymentToRepeat.isFixedAmountValue?paymentToRepeat.payOutString:paymentToRepeat.payInString stringByReplacingOccurrencesOfString:@" " withString:@""];
    NSString *source = paymentToRepeat.sourceCurrency.code;
    NSString *target = paymentToRepeat.targetCurrency.code;
    
    TransferCalculationsOperation *operation = [TransferCalculationsOperation operationWithAmount:amount
																						   source:source
																						   target:target];
    
    [operation setAmountCurrency:paymentToRepeat.isFixedAmountValue?TargetCurrency:SourceCurrency];
    __weak typeof(self) weakSelf = self;
    [operation setRemoteCalculationHandler:^(CalculationResult *result, NSError *error) {
        dispatch_async(dispatch_get_main_queue(), ^{
            weakSelf.currentOperation = nil;
            if (result)
			{
				[weakSelf createPendingPaymentWithObjectModel:objectModel
													   source:sourceCurrency
													   target:targetCurrency
											calculationResult:result recipient:paymentToRepeat.recipient
													  profile:paymentToRepeat.profileUsed
												 successBlock:^(PendingPayment *payment) {
													 payment.paymentReference = paymentToRepeat.paymentReference;
													 if(successBlock)
													 {
														 successBlock(payment);
													 }
												 }
												 failureBlock:failureBlock];
            }
            else
            {
                [weakSelf reportFailure:failureBlock
								  error:[NSError errorWithDomain:NewTransferErrorDomain
															code:CalculationOperationFailed
														userInfo:@{NewTransferNetworkOperationErrorKey:error}]];
            }
        });
    }];
    
    self.currentOperation = operation;
    [operation execute];
    
    [[GoogleAnalytics sharedInstance] sendAppEvent:@"RepeatTransferSelected"];
    
}

-(void)createPendingPaymentWithObjectModel:(ObjectModel*)objectModel
									source:(Currency*)sourceCurrency
									target:(Currency*)targetCurrency
						 calculationResult:(CalculationResult*)result
								 recipient:(Recipient*)recipient
								   profile:(NSString*)profile
							  successBlock:(void(^)(PendingPayment* payment))successBlock
							  failureBlock:(void(^)(NSError* error))failureBlock
{
    PairSourceCurrency *source = [objectModel pairSourceWithCurrency:sourceCurrency];
    PairTargetCurrency *target = [objectModel pairTargetWithSource:sourceCurrency target:targetCurrency];
    NSNumber *payIn = [result transferwisePayIn];
    
    if(!source || !target || !payIn)
    {
        [self reportFailure:failureBlock error:[NSError errorWithDomain:NewTransferErrorDomain
																   code:DataMissing
															   userInfo:nil]];
        return;
    }
    
    if (![target acceptablePayIn:payIn])
    {
        [self reportFailure:failureBlock error:[NSError errorWithDomain:NewTransferErrorDomain
																   code:PayInTooLow
															   userInfo:@{NewTransferMinimumAmountKey:target.minInvoiceAmount, NewTransferSourceCurrencyCodeKey:target.source.currency.code}]];
        return;
    }
    else if (![source acceptablePayIn:payIn])
    {
        [self reportFailure:failureBlock error:[NSError errorWithDomain:NewTransferErrorDomain
																   code:PayInTooHigh
															   userInfo:@{NewTransferMinimumAmountKey:source.maxInvoiceAmount, NewTransferSourceCurrencyCodeKey:source.currency.code}]];
        return;
    }
    
   if([@"USD" caseInsensitiveCompare:sourceCurrency.code] == NSOrderedSame && [payIn floatValue] < 3.0f)
   {
       [self reportFailure:failureBlock error:[NSError errorWithDomain:NewTransferErrorDomain
																  code:USDPayinTooLow userInfo:@{NewTransferMinimumAmountKey:@(3), NewTransferSourceCurrencyCodeKey:@"USD"}]];
       return;
   }
    
    RecipientTypesOperation *operation = [RecipientTypesOperation operation];
    [operation setObjectModel:objectModel];
    operation.sourceCurrency = sourceCurrency.code;
    operation.targetCurrency = targetCurrency.code;
    operation.amount = [result transferwisePayIn];
    
    self.currentOperation = operation;
     __weak typeof(self) weakSelf = self;
    [operation setResultHandler:^(NSError *error, NSArray* listOfRecipientTypeCodes) {
        if (error) {
            [weakSelf reportFailure:failureBlock error:[NSError errorWithDomain:NewTransferErrorDomain code:RecipientTypesOperationFailed userInfo:@{NewTransferNetworkOperationErrorKey:error}]];
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
		
		CurrencyLoader *loader = [CurrencyLoader sharedInstanceWithObjectModel:objectModel];
		[loader getCurrencieWithSuccessBlock:^(NSError *error) {
			weakSelf.currentOperation = nil;
			if (error) {
				[weakSelf reportFailure:failureBlock error:[NSError errorWithDomain:NewTransferErrorDomain code:CurrenciesOperationFailed userInfo:@{NewTransferNetworkOperationErrorKey:error}]];
				return;
			}
			
			dataLoadCompletionBlock();
		}];
    }];
    [operation execute];
}

-(void)reportFailure:(void(^)(NSError* error))failureBlock error:(NSError*)error
{
    if(failureBlock)
    {
        dispatch_async(dispatch_get_main_queue(),^{
            failureBlock(error);
        });
    }
}

@end
