// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Payment.h instead.

#import <CoreData/CoreData.h>


extern const struct PaymentAttributes {
	__unsafe_unretained NSString *cancelledDate;
	__unsafe_unretained NSString *estimatedDelivery;
	__unsafe_unretained NSString *lastUpdateTime;
	__unsafe_unretained NSString *payIn;
	__unsafe_unretained NSString *paymentStatus;
	__unsafe_unretained NSString *receivedDate;
	__unsafe_unretained NSString *remoteId;
	__unsafe_unretained NSString *submittedDate;
	__unsafe_unretained NSString *transferredDate;
} PaymentAttributes;

extern const struct PaymentRelationships {
	__unsafe_unretained NSString *recipient;
	__unsafe_unretained NSString *settlementRecipient;
	__unsafe_unretained NSString *sourceCurrency;
	__unsafe_unretained NSString *targetCurrency;
	__unsafe_unretained NSString *user;
} PaymentRelationships;

extern const struct PaymentFetchedProperties {
} PaymentFetchedProperties;

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





@property (nonatomic, strong) NSDate* estimatedDelivery;



//- (BOOL)validateEstimatedDelivery:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDate* lastUpdateTime;



//- (BOOL)validateLastUpdateTime:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSDecimalNumber* payIn;



//- (BOOL)validatePayIn:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* paymentStatus;



//- (BOOL)validatePaymentStatus:(id*)value_ error:(NSError**)error_;





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




- (NSDate*)primitiveEstimatedDelivery;
- (void)setPrimitiveEstimatedDelivery:(NSDate*)value;




- (NSDate*)primitiveLastUpdateTime;
- (void)setPrimitiveLastUpdateTime:(NSDate*)value;




- (NSDecimalNumber*)primitivePayIn;
- (void)setPrimitivePayIn:(NSDecimalNumber*)value;




- (NSString*)primitivePaymentStatus;
- (void)setPrimitivePaymentStatus:(NSString*)value;




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



- (Recipient*)primitiveSettlementRecipient;
- (void)setPrimitiveSettlementRecipient:(Recipient*)value;



- (Currency*)primitiveSourceCurrency;
- (void)setPrimitiveSourceCurrency:(Currency*)value;



- (Currency*)primitiveTargetCurrency;
- (void)setPrimitiveTargetCurrency:(Currency*)value;



- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
