// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipientType.h instead.

#import <CoreData/CoreData.h>


extern const struct RecipientTypeAttributes {
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *type;
} RecipientTypeAttributes;

extern const struct RecipientTypeRelationships {
	__unsafe_unretained NSString *currencies;
	__unsafe_unretained NSString *defaultForCurrencies;
	__unsafe_unretained NSString *fields;
	__unsafe_unretained NSString *recipients;
} RecipientTypeRelationships;

extern const struct RecipientTypeFetchedProperties {
} RecipientTypeFetchedProperties;

@class Currency;
@class Currency;
@class RecipientTypeField;
@class Recipient;




@interface RecipientTypeID : NSManagedObjectID {}
@end

@interface _RecipientType : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RecipientTypeID*)objectID;





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



- (NSMutableSet*)primitiveRecipients;
- (void)setPrimitiveRecipients:(NSMutableSet*)value;


@end
