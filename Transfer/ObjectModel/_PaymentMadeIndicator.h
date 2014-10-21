// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PaymentMadeIndicator.h instead.

#import <CoreData/CoreData.h>

extern const struct PaymentMadeIndicatorAttributes {
	__unsafe_unretained NSString *payInMethodName;
	__unsafe_unretained NSString *paymentRemoteId;
} PaymentMadeIndicatorAttributes;

extern const struct PaymentMadeIndicatorRelationships {
	__unsafe_unretained NSString *payment;
} PaymentMadeIndicatorRelationships;

@class Payment;

@interface PaymentMadeIndicatorID : NSManagedObjectID {}
@end

@interface _PaymentMadeIndicator : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PaymentMadeIndicatorID* objectID;

@property (nonatomic, strong) NSString* payInMethodName;

//- (BOOL)validatePayInMethodName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* paymentRemoteId;

@property (atomic) int32_t paymentRemoteIdValue;
- (int32_t)paymentRemoteIdValue;
- (void)setPaymentRemoteIdValue:(int32_t)value_;

//- (BOOL)validatePaymentRemoteId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Payment *payment;

//- (BOOL)validatePayment:(id*)value_ error:(NSError**)error_;

@end

@interface _PaymentMadeIndicator (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitivePayInMethodName;
- (void)setPrimitivePayInMethodName:(NSString*)value;

- (NSNumber*)primitivePaymentRemoteId;
- (void)setPrimitivePaymentRemoteId:(NSNumber*)value;

- (int32_t)primitivePaymentRemoteIdValue;
- (void)setPrimitivePaymentRemoteIdValue:(int32_t)value_;

- (Payment*)primitivePayment;
- (void)setPrimitivePayment:(Payment*)value;

@end
