// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recipient.h instead.

#import <CoreData/CoreData.h>

extern const struct RecipientAttributes {
	__unsafe_unretained NSString *addressCity;
	__unsafe_unretained NSString *addressCountryCode;
	__unsafe_unretained NSString *addressFirstLine;
	__unsafe_unretained NSString *addressPostCode;
	__unsafe_unretained NSString *addressState;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *hidden;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *remoteId;
} RecipientAttributes;

extern const struct RecipientRelationships {
	__unsafe_unretained NSString *currency;
	__unsafe_unretained NSString *fieldValues;
	__unsafe_unretained NSString *payInMethods;
	__unsafe_unretained NSString *payments;
	__unsafe_unretained NSString *refundForPayments;
	__unsafe_unretained NSString *type;
	__unsafe_unretained NSString *user;
} RecipientRelationships;

@class Currency;
@class TypeFieldValue;
@class PayInMethod;
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
@property (nonatomic, readonly, strong) RecipientID* objectID;

@property (nonatomic, strong) NSString* addressCity;

//- (BOOL)validateAddressCity:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* addressCountryCode;

//- (BOOL)validateAddressCountryCode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* addressFirstLine;

//- (BOOL)validateAddressFirstLine:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* addressPostCode;

//- (BOOL)validateAddressPostCode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* addressState;

//- (BOOL)validateAddressState:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* hidden;

@property (atomic) BOOL hiddenValue;
- (BOOL)hiddenValue;
- (void)setHiddenValue:(BOOL)value_;

//- (BOOL)validateHidden:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* remoteId;

@property (atomic) int32_t remoteIdValue;
- (int32_t)remoteIdValue;
- (void)setRemoteIdValue:(int32_t)value_;

//- (BOOL)validateRemoteId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Currency *currency;

//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *fieldValues;

- (NSMutableOrderedSet*)fieldValuesSet;

@property (nonatomic, strong) NSSet *payInMethods;

- (NSMutableSet*)payInMethodsSet;

@property (nonatomic, strong) NSSet *payments;

- (NSMutableSet*)paymentsSet;

@property (nonatomic, strong) NSSet *refundForPayments;

- (NSMutableSet*)refundForPaymentsSet;

@property (nonatomic, strong) RecipientType *type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _Recipient (FieldValuesCoreDataGeneratedAccessors)
- (void)addFieldValues:(NSOrderedSet*)value_;
- (void)removeFieldValues:(NSOrderedSet*)value_;
- (void)addFieldValuesObject:(TypeFieldValue*)value_;
- (void)removeFieldValuesObject:(TypeFieldValue*)value_;

- (void)insertObject:(TypeFieldValue*)value inFieldValuesAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFieldValuesAtIndex:(NSUInteger)idx;
- (void)insertFieldValues:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFieldValuesAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFieldValuesAtIndex:(NSUInteger)idx withObject:(TypeFieldValue*)value;
- (void)replaceFieldValuesAtIndexes:(NSIndexSet *)indexes withFieldValues:(NSArray *)values;

@end

@interface _Recipient (PayInMethodsCoreDataGeneratedAccessors)
- (void)addPayInMethods:(NSSet*)value_;
- (void)removePayInMethods:(NSSet*)value_;
- (void)addPayInMethodsObject:(PayInMethod*)value_;
- (void)removePayInMethodsObject:(PayInMethod*)value_;

@end

@interface _Recipient (PaymentsCoreDataGeneratedAccessors)
- (void)addPayments:(NSSet*)value_;
- (void)removePayments:(NSSet*)value_;
- (void)addPaymentsObject:(Payment*)value_;
- (void)removePaymentsObject:(Payment*)value_;

@end

@interface _Recipient (RefundForPaymentsCoreDataGeneratedAccessors)
- (void)addRefundForPayments:(NSSet*)value_;
- (void)removeRefundForPayments:(NSSet*)value_;
- (void)addRefundForPaymentsObject:(Payment*)value_;
- (void)removeRefundForPaymentsObject:(Payment*)value_;

@end

@interface _Recipient (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAddressCity;
- (void)setPrimitiveAddressCity:(NSString*)value;

- (NSString*)primitiveAddressCountryCode;
- (void)setPrimitiveAddressCountryCode:(NSString*)value;

- (NSString*)primitiveAddressFirstLine;
- (void)setPrimitiveAddressFirstLine:(NSString*)value;

- (NSString*)primitiveAddressPostCode;
- (void)setPrimitiveAddressPostCode:(NSString*)value;

- (NSString*)primitiveAddressState;
- (void)setPrimitiveAddressState:(NSString*)value;

- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;

- (NSNumber*)primitiveHidden;
- (void)setPrimitiveHidden:(NSNumber*)value;

- (BOOL)primitiveHiddenValue;
- (void)setPrimitiveHiddenValue:(BOOL)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSNumber*)primitiveRemoteId;
- (void)setPrimitiveRemoteId:(NSNumber*)value;

- (int32_t)primitiveRemoteIdValue;
- (void)setPrimitiveRemoteIdValue:(int32_t)value_;

- (Currency*)primitiveCurrency;
- (void)setPrimitiveCurrency:(Currency*)value;

- (NSMutableOrderedSet*)primitiveFieldValues;
- (void)setPrimitiveFieldValues:(NSMutableOrderedSet*)value;

- (NSMutableSet*)primitivePayInMethods;
- (void)setPrimitivePayInMethods:(NSMutableSet*)value;

- (NSMutableSet*)primitivePayments;
- (void)setPrimitivePayments:(NSMutableSet*)value;

- (NSMutableSet*)primitiveRefundForPayments;
- (void)setPrimitiveRefundForPayments:(NSMutableSet*)value;

- (RecipientType*)primitiveType;
- (void)setPrimitiveType:(RecipientType*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end
