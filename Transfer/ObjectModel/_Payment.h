// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Payment.h instead.

#import <CoreData/CoreData.h>


extern const struct PaymentAttributes {
	__unsafe_unretained NSString *cancelledDate;
	__unsafe_unretained NSString *conversionRate;
	__unsafe_unretained NSString *estimatedDelivery;
	__unsafe_unretained NSString *estimatedDeliveryStringFromServer;
	__unsafe_unretained NSString *isFixedAmount;
	__unsafe_unretained NSString *lastUpdateTime;
	__unsafe_unretained NSString *payIn;
	__unsafe_unretained NSString *payOut;
	__unsafe_unretained NSString *paymentOptions;
	__unsafe_unretained NSString *paymentStatus;
	__unsafe_unretained NSString *presentable;
	__unsafe_unretained NSString *profileUsed;
	__unsafe_unretained NSString *receivedDate;
	__unsafe_unretained NSString *remoteId;
	__unsafe_unretained NSString *submittedDate;
	__unsafe_unretained NSString *transferredDate;
} PaymentAttributes;

extern const struct PaymentRelationships {
	__unsafe_unretained NSString *recipient;
	__unsafe_unretained NSString *refundRecipient;
	__unsafe_unretained NSString *settlementRecipient;
	__unsafe_unretained NSString *sourceCurrency;
	__unsafe_unretained NSString *targetCurrency;
	__unsafe_unretained NSString *user;
} PaymentRelationships;

extern const struct PaymentFetchedProperties {
} PaymentFetchedProperties;

@class Recipient;
@class Recipient;
@class Recipient;
@class Currency;
@class Currency;
@class User;


















@interface PaymentID : NSManagedObjectID {}
@end

@interface _Payment : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PaymentID*)objectID;





@property (nonatomic, strong) NSDate* cancelledDate;



//- (BOOL)validateCancelledDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* conversionRate;



@property double conversionRateValue;
- (double)conversionRateValue;
- (void)setConversionRateValue:(double)value_;

//- (BOOL)validateConversionRate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* estimatedDelivery;



//- (BOOL)validateEstimatedDelivery:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* estimatedDeliveryStringFromServer;



//- (BOOL)validateEstimatedDeliveryStringFromServer:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* isFixedAmount;



@property BOOL isFixedAmountValue;
- (BOOL)isFixedAmountValue;
- (void)setIsFixedAmountValue:(BOOL)value_;

//- (BOOL)validateIsFixedAmount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastUpdateTime;



//- (BOOL)validateLastUpdateTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* payIn;



//- (BOOL)validatePayIn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* payOut;



//- (BOOL)validatePayOut:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* paymentOptions;



@property int16_t paymentOptionsValue;
- (int16_t)paymentOptionsValue;
- (void)setPaymentOptionsValue:(int16_t)value_;

//- (BOOL)validatePaymentOptions:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* paymentStatus;



//- (BOOL)validatePaymentStatus:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* presentable;



@property BOOL presentableValue;
- (BOOL)presentableValue;
- (void)setPresentableValue:(BOOL)value_;

//- (BOOL)validatePresentable:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* profileUsed;



//- (BOOL)validateProfileUsed:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* receivedDate;



//- (BOOL)validateReceivedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* remoteId;



@property int32_t remoteIdValue;
- (int32_t)remoteIdValue;
- (void)setRemoteIdValue:(int32_t)value_;

//- (BOOL)validateRemoteId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* submittedDate;



//- (BOOL)validateSubmittedDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* transferredDate;



//- (BOOL)validateTransferredDate:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Recipient *recipient;

//- (BOOL)validateRecipient:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Recipient *refundRecipient;

//- (BOOL)validateRefundRecipient:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Recipient *settlementRecipient;

//- (BOOL)validateSettlementRecipient:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Currency *sourceCurrency;

//- (BOOL)validateSourceCurrency:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Currency *targetCurrency;

//- (BOOL)validateTargetCurrency:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _Payment (CoreDataGeneratedAccessors)

@end

@interface _Payment (CoreDataGeneratedPrimitiveAccessors)


- (NSDate*)primitiveCancelledDate;
- (void)setPrimitiveCancelledDate:(NSDate*)value;




- (NSNumber*)primitiveConversionRate;
- (void)setPrimitiveConversionRate:(NSNumber*)value;

- (double)primitiveConversionRateValue;
- (void)setPrimitiveConversionRateValue:(double)value_;




- (NSDate*)primitiveEstimatedDelivery;
- (void)setPrimitiveEstimatedDelivery:(NSDate*)value;




- (NSString*)primitiveEstimatedDeliveryStringFromServer;
- (void)setPrimitiveEstimatedDeliveryStringFromServer:(NSString*)value;




- (NSNumber*)primitiveIsFixedAmount;
- (void)setPrimitiveIsFixedAmount:(NSNumber*)value;

- (BOOL)primitiveIsFixedAmountValue;
- (void)setPrimitiveIsFixedAmountValue:(BOOL)value_;




- (NSDate*)primitiveLastUpdateTime;
- (void)setPrimitiveLastUpdateTime:(NSDate*)value;




- (NSDecimalNumber*)primitivePayIn;
- (void)setPrimitivePayIn:(NSDecimalNumber*)value;




- (NSDecimalNumber*)primitivePayOut;
- (void)setPrimitivePayOut:(NSDecimalNumber*)value;




- (NSNumber*)primitivePaymentOptions;
- (void)setPrimitivePaymentOptions:(NSNumber*)value;

- (int16_t)primitivePaymentOptionsValue;
- (void)setPrimitivePaymentOptionsValue:(int16_t)value_;




- (NSString*)primitivePaymentStatus;
- (void)setPrimitivePaymentStatus:(NSString*)value;




- (NSNumber*)primitivePresentable;
- (void)setPrimitivePresentable:(NSNumber*)value;

- (BOOL)primitivePresentableValue;
- (void)setPrimitivePresentableValue:(BOOL)value_;




- (NSString*)primitiveProfileUsed;
- (void)setPrimitiveProfileUsed:(NSString*)value;




- (NSDate*)primitiveReceivedDate;
- (void)setPrimitiveReceivedDate:(NSDate*)value;




- (NSNumber*)primitiveRemoteId;
- (void)setPrimitiveRemoteId:(NSNumber*)value;

- (int32_t)primitiveRemoteIdValue;
- (void)setPrimitiveRemoteIdValue:(int32_t)value_;




- (NSDate*)primitiveSubmittedDate;
- (void)setPrimitiveSubmittedDate:(NSDate*)value;




- (NSDate*)primitiveTransferredDate;
- (void)setPrimitiveTransferredDate:(NSDate*)value;





- (Recipient*)primitiveRecipient;
- (void)setPrimitiveRecipient:(Recipient*)value;



- (Recipient*)primitiveRefundRecipient;
- (void)setPrimitiveRefundRecipient:(Recipient*)value;



- (Recipient*)primitiveSettlementRecipient;
- (void)setPrimitiveSettlementRecipient:(Recipient*)value;



- (Currency*)primitiveSourceCurrency;
- (void)setPrimitiveSourceCurrency:(Currency*)value;



- (Currency*)primitiveTargetCurrency;
- (void)setPrimitiveTargetCurrency:(Currency*)value;



- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
