//
//  RepeatTransferHelper.h
//  Transfer
//
//  Created by Mats Trovik on 13/01/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Payment;
@class ObjectModel;
@class PendingPayment;
@class Currency;
@class CalculationResult;
@class Recipient;

extern NSString *const NewTransferErrorDomain;
extern NSString *const NewTransferNetworkOperationErrorKey;
extern NSString *const NewTransferMinimumAmountKey;
extern NSString *const NewTransferMaximumAmountKey;
extern NSString *const NewTransferSourceCurrencyCodeKey;
extern NSString *const NewTransferTargetCurrencyCodeKey;

typedef NS_ENUM(short, NewTransferError)
{
    PayInTooLow = 1,
    PayInTooHigh,
    USDPayinTooLow,
    CurrenciesOperationFailed,
    RecipientTypesOperationFailed,
    CalculationOperationFailed,
    DataMissing
};

@interface NewPaymentHelper : NSObject

-(void)repeatTransfer:(Payment*)payment objectModel:(ObjectModel*)objectModel successBlock:(void(^)(PendingPayment* payment))successBlock failureBlock:(void(^)(NSError* error))failureBlock;

-(void)createPendingPaymentWithObjectModel:(ObjectModel*)objectModel source:(Currency*)sourceCurrency target:(Currency*)targetCurrency calculationResult:(CalculationResult*)result recipient:(Recipient*)recipient profile:(NSString*)profile successBlock:(void(^)(PendingPayment* payment))successBlock failureBlock:(void(^)(NSError* error))failureBlock;
@end
