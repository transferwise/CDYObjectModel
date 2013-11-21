// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PairSourceCurrency.h instead.

#import <CoreData/CoreData.h>


extern const struct PairSourceCurrencyAttributes {
	__unsafe_unretained NSString *hidden;
	__unsafe_unretained NSString *index;
	__unsafe_unretained NSString *maxInvoiceAmount;
} PairSourceCurrencyAttributes;

extern const struct PairSourceCurrencyRelationships {
	__unsafe_unretained NSString *currency;
	__unsafe_unretained NSString *targets;
} PairSourceCurrencyRelationships;

extern const struct PairSourceCurrencyFetchedProperties {
} PairSourceCurrencyFetchedProperties;

@class Currency;
@class PairTargetCurrency;





@interface PairSourceCurrencyID : NSManagedObjectID {}
@end

@interface _PairSourceCurrency : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PairSourceCurrencyID*)objectID;





@property (nonatomic, strong) NSNumber* hidden;



@property BOOL hiddenValue;
- (BOOL)hiddenValue;
- (void)setHiddenValue:(BOOL)value_;

//- (BOOL)validateHidden:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* index;



@property int16_t indexValue;
- (int16_t)indexValue;
- (void)setIndexValue:(int16_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* maxInvoiceAmount;



@property int32_t maxInvoiceAmountValue;
- (int32_t)maxInvoiceAmountValue;
- (void)setMaxInvoiceAmountValue:(int32_t)value_;

//- (BOOL)validateMaxInvoiceAmount:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Currency *currency;

//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSOrderedSet *targets;

- (NSMutableOrderedSet*)targetsSet;





@end

@interface _PairSourceCurrency (CoreDataGeneratedAccessors)

- (void)addTargets:(NSOrderedSet*)value_;
- (void)removeTargets:(NSOrderedSet*)value_;
- (void)addTargetsObject:(PairTargetCurrency*)value_;
- (void)removeTargetsObject:(PairTargetCurrency*)value_;

@end

@interface _PairSourceCurrency (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveHidden;
- (void)setPrimitiveHidden:(NSNumber*)value;

- (BOOL)primitiveHiddenValue;
- (void)setPrimitiveHiddenValue:(BOOL)value_;




- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int16_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int16_t)value_;




- (NSNumber*)primitiveMaxInvoiceAmount;
- (void)setPrimitiveMaxInvoiceAmount:(NSNumber*)value;

- (int32_t)primitiveMaxInvoiceAmountValue;
- (void)setPrimitiveMaxInvoiceAmountValue:(int32_t)value_;





- (Currency*)primitiveCurrency;
- (void)setPrimitiveCurrency:(Currency*)value;



- (NSMutableOrderedSet*)primitiveTargets;
- (void)setPrimitiveTargets:(NSMutableOrderedSet*)value;


@end
