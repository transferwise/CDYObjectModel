// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipientType.h instead.

#import <CoreData/CoreData.h>


extern const struct RecipientTypeAttributes {
	__unsafe_unretained NSString *hideFromCreation;
	__unsafe_unretained NSString *recipientAddressRequired;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *type;
} RecipientTypeAttributes;

extern const struct RecipientTypeRelationships {
	__unsafe_unretained NSString *currencies;
	__unsafe_unretained NSString *defaultForCurrencies;
	__unsafe_unretained NSString *fields;
	__unsafe_unretained NSString *pendingPayment;
	__unsafe_unretained NSString *recipients;
} RecipientTypeRelationships;

extern const struct RecipientTypeFetchedProperties {
} RecipientTypeFetchedProperties;

@class Currency;
@class Currency;
@class RecipientTypeField;
@class PendingPayment;
@class Recipient;






@interface RecipientTypeID : NSManagedObjectID {}
@end

@interface _RecipientType : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RecipientTypeID*)objectID;





@property (nonatomic, strong) NSNumber* hideFromCreation;



@property BOOL hideFromCreationValue;
- (BOOL)hideFromCreationValue;
- (void)setHideFromCreationValue:(BOOL)value_;

//- (BOOL)validateHideFromCreation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* recipientAddressRequired;



@property BOOL recipientAddressRequiredValue;
- (BOOL)recipientAddressRequiredValue;
- (void)setRecipientAddressRequiredValue:(BOOL)value_;

//- (BOOL)validateRecipientAddressRequired:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* type;



//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *currencies;

- (NSMutableSet*)currenciesSet;




@property (nonatomic, strong) NSSet *defaultForCurrencies;

- (NSMutableSet*)defaultForCurrenciesSet;




@property (nonatomic, strong) NSOrderedSet *fields;

- (NSMutableOrderedSet*)fieldsSet;




@property (nonatomic, strong) PendingPayment *pendingPayment;

//- (BOOL)validatePendingPayment:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *recipients;

- (NSMutableSet*)recipientsSet;





@end

@interface _RecipientType (CoreDataGeneratedAccessors)

- (void)addCurrencies:(NSSet*)value_;
- (void)removeCurrencies:(NSSet*)value_;
- (void)addCurrenciesObject:(Currency*)value_;
- (void)removeCurrenciesObject:(Currency*)value_;

- (void)addDefaultForCurrencies:(NSSet*)value_;
- (void)removeDefaultForCurrencies:(NSSet*)value_;
- (void)addDefaultForCurrenciesObject:(Currency*)value_;
- (void)removeDefaultForCurrenciesObject:(Currency*)value_;

- (void)addFields:(NSOrderedSet*)value_;
- (void)removeFields:(NSOrderedSet*)value_;
- (void)addFieldsObject:(RecipientTypeField*)value_;
- (void)removeFieldsObject:(RecipientTypeField*)value_;

- (void)addRecipients:(NSSet*)value_;
- (void)removeRecipients:(NSSet*)value_;
- (void)addRecipientsObject:(Recipient*)value_;
- (void)removeRecipientsObject:(Recipient*)value_;

@end

@interface _RecipientType (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveHideFromCreation;
- (void)setPrimitiveHideFromCreation:(NSNumber*)value;

- (BOOL)primitiveHideFromCreationValue;
- (void)setPrimitiveHideFromCreationValue:(BOOL)value_;




- (NSNumber*)primitiveRecipientAddressRequired;
- (void)setPrimitiveRecipientAddressRequired:(NSNumber*)value;

- (BOOL)primitiveRecipientAddressRequiredValue;
- (void)setPrimitiveRecipientAddressRequiredValue:(BOOL)value_;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;





- (NSMutableSet*)primitiveCurrencies;
- (void)setPrimitiveCurrencies:(NSMutableSet*)value;



- (NSMutableSet*)primitiveDefaultForCurrencies;
- (void)setPrimitiveDefaultForCurrencies:(NSMutableSet*)value;



- (NSMutableOrderedSet*)primitiveFields;
- (void)setPrimitiveFields:(NSMutableOrderedSet*)value;



- (PendingPayment*)primitivePendingPayment;
- (void)setPrimitivePendingPayment:(PendingPayment*)value;



- (NSMutableSet*)primitiveRecipients;
- (void)setPrimitiveRecipients:(NSMutableSet*)value;


@end
