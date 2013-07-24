// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recipient.h instead.

#import <CoreData/CoreData.h>


extern const struct RecipientAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *remoteId;
	__unsafe_unretained NSString *settlementRecipient;
	__unsafe_unretained NSString *temporary;
} RecipientAttributes;

extern const struct RecipientRelationships {
	__unsafe_unretained NSString *currency;
	__unsafe_unretained NSString *fieldValues;
	__unsafe_unretained NSString *payments;
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





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* remoteId;



@property int32_t remoteIdValue;
- (int32_t)remoteIdValue;
- (void)setRemoteIdValue:(int32_t)value_;

//- (BOOL)validateRemoteId:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* settlementRecipient;



@property BOOL settlementRecipientValue;
- (BOOL)settlementRecipientValue;
- (void)setSettlementRecipientValue:(BOOL)value_;

//- (BOOL)validateSettlementRecipient:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* temporary;



@property BOOL temporaryValue;
- (BOOL)temporaryValue;
- (void)setTemporaryValue:(BOOL)value_;

//- (BOOL)validateTemporary:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Currency *currency;

//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSOrderedSet *fieldValues;

- (NSMutableOrderedSet*)fieldValuesSet;




@property (nonatomic, strong) NSSet *payments;

- (NSMutableSet*)paymentsSet;




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




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveRemoteId;
- (void)setPrimitiveRemoteId:(NSNumber*)value;

- (int32_t)primitiveRemoteIdValue;
- (void)setPrimitiveRemoteIdValue:(int32_t)value_;




- (NSNumber*)primitiveSettlementRecipient;
- (void)setPrimitiveSettlementRecipient:(NSNumber*)value;

- (BOOL)primitiveSettlementRecipientValue;
- (void)setPrimitiveSettlementRecipientValue:(BOOL)value_;




- (NSNumber*)primitiveTemporary;
- (void)setPrimitiveTemporary:(NSNumber*)value;

- (BOOL)primitiveTemporaryValue;
- (void)setPrimitiveTemporaryValue:(BOOL)value_;





- (Currency*)primitiveCurrency;
- (void)setPrimitiveCurrency:(Currency*)value;



- (NSMutableOrderedSet*)primitiveFieldValues;
- (void)setPrimitiveFieldValues:(NSMutableOrderedSet*)value;



- (NSMutableSet*)primitivePayments;
- (void)setPrimitivePayments:(NSMutableSet*)value;



- (NSMutableSet*)primitiveSettlementForPayments;
- (void)setPrimitiveSettlementForPayments:(NSMutableSet*)value;



- (RecipientType*)primitiveType;
- (void)setPrimitiveType:(RecipientType*)value;



- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
