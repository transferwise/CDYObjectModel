// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PaymentMadeIndicator.h instead.

#import <CoreData/CoreData.h>


extern const struct PaymentMadeIndicatorAttributes {
	__unsafe_unretained NSString *paymentRemoteId;
} PaymentMadeIndicatorAttributes;

extern const struct PaymentMadeIndicatorRelationships {
	__unsafe_unretained NSString *payment;
} PaymentMadeIndicatorRelationships;

extern const struct PaymentMadeIndicatorFetchedProperties {
} PaymentMadeIndicatorFetchedProperties;

@class Payment;



@interface PaymentMadeIndicatorID : NSManagedObjectID {}
@end

@interface _PaymentMadeIndicator : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PaymentMadeIndicatorID*)objectID;





@property (nonatomic, strong) NSNumber* paymentRemoteId;



@property int32_t paymentRemoteIdValue;
- (int32_t)paymentRemoteIdValue;
- (void)setPaymentRemoteIdValue:(int32_t)value_;

//- (BOOL)validatePaymentRemoteId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Payment *payment;

//- (BOOL)validatePayment:(id*)value_ error:(NSError**)error_;





@end

@interface _PaymentMadeIndicator (CoreDataGeneratedAccessors)

@end

@interface _PaymentMadeIndicator (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitivePaymentRemoteId;
- (void)setPrimitivePaymentRemoteId:(NSNumber*)value;

- (int32_t)primitivePaymentRemoteIdValue;
- (void)setPrimitivePaymentRemoteIdValue:(int32_t)value_;





- (Payment*)primitivePayment;
- (void)setPrimitivePayment:(Payment*)value;


@end