// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recipient.h instead.

#import <CoreData/CoreData.h>


extern const struct RecipientAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *hidden;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *refundRecipient;
	__unsafe_unretained NSString *remoteId;
} RecipientAttributes;

extern const struct RecipientRelationships {
	__unsafe_unretained NSString *currency;
	__unsafe_unretained NSString *fieldValues;
	__unsafe_unretained NSString *payments;
	__unsafe_unretained NSString *refundForPayment;
	__unsafe_unretained NSString *settlementForPayments;
	__unsafe_unretained NSString *type;
	__unsafe_unretained NSString *user;
} RecipientRelationships;

extern const struct RecipientFetchedProperties {
} RecipientFetchedProperties;

@class Currency;
@class TypeFieldValue;
@class Payment;
@class Payment;
@class Payment;
@class RecipientType;
@class User;







@interface RecipientID : NSManagedObjectID {}
@end

@interface _Recipient : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RecipientID*)objectID;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* hidden;



@property BOOL hiddenValue;
- (BOOL)hiddenValue;
- (void)setHiddenValue:(BOOL)value_;

//- (BOOL)validateHidden:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* refundRecipient;



@property BOOL refundRecipientValue;
- (BOOL)refundRecipientValue;
- (void)setRefundRecipientValue:(BOOL)value_;

//- (BOOL)validateRefundRecipient:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* remoteId;



@property int32_t remoteIdValue;
- (int32_t)remoteIdValue;
- (void)setRemoteIdValue:(int32_t)value_;

//- (BOOL)validateRemoteId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Currency *currency;

//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSOrderedSet *fieldValues;

- (NSMutableOrderedSet*)fieldValuesSet;




@property (nonatomic, strong) NSSet *payments;

- (NSMutableSet*)paymentsSet;




@property (nonatomic, strong) Payment *refundForPayment;

//- (BOOL)validateRefundForPayment:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *settlementForPayments;

- (NSMutableSet*)settlementForPaymentsSet;




@property (nonatomic, strong) RecipientType *type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _Recipient (CoreDataGeneratedAccessors)

- (void)addFieldValues:(NSOrderedSet*)value_;
- (void)removeFieldValues:(NSOrderedSet*)value_;
- (void)addFieldValuesObject:(TypeFieldValue*)value_;
- (void)removeFieldValuesObject:(TypeFieldValue*)value_;

- (void)addPayments:(NSSet*)value_;
- (void)removePayments:(NSSet*)value_;
- (void)addPaymentsObject:(Payment*)value_;
- (void)removePaymentsObject:(Payment*)value_;

- (void)addSettlementForPayments:(NSSet*)value_;
- (void)removeSettlementForPayments:(NSSet*)value_;
- (void)addSettlementForPaymentsObject:(Payment*)value_;
- (void)removeSettlementForPaymentsObject:(Payment*)value_;

@end

@interface _Recipient (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSNumber*)primitiveHidden;
- (void)setPrimitiveHidden:(NSNumber*)value;

- (BOOL)primitiveHiddenValue;
- (void)setPrimitiveHiddenValue:(BOOL)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveRefundRecipient;
- (void)setPrimitiveRefundRecipient:(NSNumber*)value;

- (BOOL)primitiveRefundRecipientValue;
- (void)setPrimitiveRefundRecipientValue:(BOOL)value_;




- (NSNumber*)primitiveRemoteId;
- (void)setPrimitiveRemoteId:(NSNumber*)value;

- (int32_t)primitiveRemoteIdValue;
- (void)setPrimitiveRemoteIdValue:(int32_t)value_;





- (Currency*)primitiveCurrency;
- (void)setPrimitiveCurrency:(Currency*)value;



- (NSMutableOrderedSet*)primitiveFieldValues;
- (void)setPrimitiveFieldValues:(NSMutableOrderedSet*)value;



- (NSMutableSet*)primitivePayments;
- (void)setPrimitivePayments:(NSMutableSet*)value;



- (Payment*)primitiveRefundForPayment;
- (void)setPrimitiveRefundForPayment:(Payment*)value;



- (NSMutableSet*)primitiveSettlementForPayments;
- (void)setPrimitiveSettlementForPayments:(NSMutableSet*)value;



- (RecipientType*)primitiveType;
- (void)setPrimitiveType:(RecipientType*)value;



- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
