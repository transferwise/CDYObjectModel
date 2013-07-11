// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Currency.h instead.

#import <CoreData/CoreData.h>


extern const struct CurrencyAttributes {
	__unsafe_unretained NSString *code;
	__unsafe_unretained NSString *index;
} CurrencyAttributes;

extern const struct CurrencyRelationships {
	__unsafe_unretained NSString *currencyForRecipients;
	__unsafe_unretained NSString *sourceForPayments;
	__unsafe_unretained NSString *targetForPayments;
} CurrencyRelationships;

extern const struct CurrencyFetchedProperties {
} CurrencyFetchedProperties;

@class Recipient;
@class Payment;
@class Payment;




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





@property (nonatomic, strong) NSSet *currencyForRecipients;

- (NSMutableSet*)currencyForRecipientsSet;




@property (nonatomic, strong) NSSet *sourceForPayments;

- (NSMutableSet*)sourceForPaymentsSet;




@property (nonatomic, strong) NSSet *targetForPayments;

- (NSMutableSet*)targetForPaymentsSet;





@end

@interface _Currency (CoreDataGeneratedAccessors)

- (void)addCurrencyForRecipients:(NSSet*)value_;
- (void)removeCurrencyForRecipients:(NSSet*)value_;
- (void)addCurrencyForRecipientsObject:(Recipient*)value_;
- (void)removeCurrencyForRecipientsObject:(Recipient*)value_;

- (void)addSourceForPayments:(NSSet*)value_;
- (void)removeSourceForPayments:(NSSet*)value_;
- (void)addSourceForPaymentsObject:(Payment*)value_;
- (void)removeSourceForPaymentsObject:(Payment*)value_;

- (void)addTargetForPayments:(NSSet*)value_;
- (void)removeTargetForPayments:(NSSet*)value_;
- (void)addTargetForPaymentsObject:(Payment*)value_;
- (void)removeTargetForPaymentsObject:(Payment*)value_;

@end

@interface _Currency (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCode;
- (void)setPrimitiveCode:(NSString*)value;




- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int16_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int16_t)value_;





- (NSMutableSet*)primitiveCurrencyForRecipients;
- (void)setPrimitiveCurrencyForRecipients:(NSMutableSet*)value;



- (NSMutableSet*)primitiveSourceForPayments;
- (void)setPrimitiveSourceForPayments:(NSMutableSet*)value;



- (NSMutableSet*)primitiveTargetForPayments;
- (void)setPrimitiveTargetForPayments:(NSMutableSet*)value;


@end
