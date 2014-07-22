// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Currency.h instead.

#import <CoreData/CoreData.h>


extern const struct CurrencyAttributes {
	__unsafe_unretained NSString *code;
	__unsafe_unretained NSString *index;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *referenceMaxLength;
	__unsafe_unretained NSString *symbol;
} CurrencyAttributes;

extern const struct CurrencyRelationships {
	__unsafe_unretained NSString *currencyForRecipients;
	__unsafe_unretained NSString *defaultRecipientType;
	__unsafe_unretained NSString *recipientTypes;
	__unsafe_unretained NSString *sourceForPayments;
	__unsafe_unretained NSString *sources;
	__unsafe_unretained NSString *targetForPayments;
	__unsafe_unretained NSString *targets;
} CurrencyRelationships;

extern const struct CurrencyFetchedProperties {
} CurrencyFetchedProperties;

@class Recipient;
@class RecipientType;
@class RecipientType;
@class Payment;
@class PairSourceCurrency;
@class Payment;
@class PairTargetCurrency;







@interface CurrencyID : NSManagedObjectID {}
@end

@interface _Currency : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CurrencyID*)objectID;





@property (nonatomic, strong) NSString* code;



//- (BOOL)validateCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* index;



@property int16_t indexValue;
- (int16_t)indexValue;
- (void)setIndexValue:(int16_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* referenceMaxLength;



@property int16_t referenceMaxLengthValue;
- (int16_t)referenceMaxLengthValue;
- (void)setReferenceMaxLengthValue:(int16_t)value_;

//- (BOOL)validateReferenceMaxLength:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* symbol;



//- (BOOL)validateSymbol:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSSet *currencyForRecipients;

- (NSMutableSet*)currencyForRecipientsSet;




@property (nonatomic, strong) RecipientType *defaultRecipientType;

//- (BOOL)validateDefaultRecipientType:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSOrderedSet *recipientTypes;

- (NSMutableOrderedSet*)recipientTypesSet;




@property (nonatomic, strong) NSSet *sourceForPayments;

- (NSMutableSet*)sourceForPaymentsSet;




@property (nonatomic, strong) NSSet *sources;

- (NSMutableSet*)sourcesSet;




@property (nonatomic, strong) NSSet *targetForPayments;

- (NSMutableSet*)targetForPaymentsSet;




@property (nonatomic, strong) NSSet *targets;

- (NSMutableSet*)targetsSet;





@end

@interface _Currency (CoreDataGeneratedAccessors)

- (void)addCurrencyForRecipients:(NSSet*)value_;
- (void)removeCurrencyForRecipients:(NSSet*)value_;
- (void)addCurrencyForRecipientsObject:(Recipient*)value_;
- (void)removeCurrencyForRecipientsObject:(Recipient*)value_;

- (void)addRecipientTypes:(NSOrderedSet*)value_;
- (void)removeRecipientTypes:(NSOrderedSet*)value_;
- (void)addRecipientTypesObject:(RecipientType*)value_;
- (void)removeRecipientTypesObject:(RecipientType*)value_;

- (void)addSourceForPayments:(NSSet*)value_;
- (void)removeSourceForPayments:(NSSet*)value_;
- (void)addSourceForPaymentsObject:(Payment*)value_;
- (void)removeSourceForPaymentsObject:(Payment*)value_;

- (void)addSources:(NSSet*)value_;
- (void)removeSources:(NSSet*)value_;
- (void)addSourcesObject:(PairSourceCurrency*)value_;
- (void)removeSourcesObject:(PairSourceCurrency*)value_;

- (void)addTargetForPayments:(NSSet*)value_;
- (void)removeTargetForPayments:(NSSet*)value_;
- (void)addTargetForPaymentsObject:(Payment*)value_;
- (void)removeTargetForPaymentsObject:(Payment*)value_;

- (void)addTargets:(NSSet*)value_;
- (void)removeTargets:(NSSet*)value_;
- (void)addTargetsObject:(PairTargetCurrency*)value_;
- (void)removeTargetsObject:(PairTargetCurrency*)value_;

@end

@interface _Currency (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCode;
- (void)setPrimitiveCode:(NSString*)value;




- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int16_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int16_t)value_;




- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveReferenceMaxLength;
- (void)setPrimitiveReferenceMaxLength:(NSNumber*)value;

- (int16_t)primitiveReferenceMaxLengthValue;
- (void)setPrimitiveReferenceMaxLengthValue:(int16_t)value_;




- (NSString*)primitiveSymbol;
- (void)setPrimitiveSymbol:(NSString*)value;





- (NSMutableSet*)primitiveCurrencyForRecipients;
- (void)setPrimitiveCurrencyForRecipients:(NSMutableSet*)value;



- (RecipientType*)primitiveDefaultRecipientType;
- (void)setPrimitiveDefaultRecipientType:(RecipientType*)value;



- (NSMutableOrderedSet*)primitiveRecipientTypes;
- (void)setPrimitiveRecipientTypes:(NSMutableOrderedSet*)value;



- (NSMutableSet*)primitiveSourceForPayments;
- (void)setPrimitiveSourceForPayments:(NSMutableSet*)value;



- (NSMutableSet*)primitiveSources;
- (void)setPrimitiveSources:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTargetForPayments;
- (void)setPrimitiveTargetForPayments:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTargets;
- (void)setPrimitiveTargets:(NSMutableSet*)value;


@end
