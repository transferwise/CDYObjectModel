// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PairTargetCurrency.h instead.

#import <CoreData/CoreData.h>

extern const struct PairTargetCurrencyAttributes {
	__unsafe_unretained NSString *fixedTargetPaymentAllowed;
	__unsafe_unretained NSString *hidden;
	__unsafe_unretained NSString *index;
	__unsafe_unretained NSString *minInvoiceAmount;
} PairTargetCurrencyAttributes;

extern const struct PairTargetCurrencyRelationships {
	__unsafe_unretained NSString *currency;
	__unsafe_unretained NSString *source;
} PairTargetCurrencyRelationships;

@class Currency;
@class PairSourceCurrency;

@interface PairTargetCurrencyID : NSManagedObjectID {}
@end

@interface _PairTargetCurrency : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) PairTargetCurrencyID* objectID;

@property (nonatomic, strong) NSNumber* fixedTargetPaymentAllowed;

@property (atomic) BOOL fixedTargetPaymentAllowedValue;
- (BOOL)fixedTargetPaymentAllowedValue;
- (void)setFixedTargetPaymentAllowedValue:(BOOL)value_;

//- (BOOL)validateFixedTargetPaymentAllowed:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* hidden;

@property (atomic) BOOL hiddenValue;
- (BOOL)hiddenValue;
- (void)setHiddenValue:(BOOL)value_;

//- (BOOL)validateHidden:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* index;

@property (atomic) int16_t indexValue;
- (int16_t)indexValue;
- (void)setIndexValue:(int16_t)value_;

//- (BOOL)validateIndex:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* minInvoiceAmount;

@property (atomic) int32_t minInvoiceAmountValue;
- (int32_t)minInvoiceAmountValue;
- (void)setMinInvoiceAmountValue:(int32_t)value_;

//- (BOOL)validateMinInvoiceAmount:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Currency *currency;

//- (BOOL)validateCurrency:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) PairSourceCurrency *source;

//- (BOOL)validateSource:(id*)value_ error:(NSError**)error_;

@end

@interface _PairTargetCurrency (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveFixedTargetPaymentAllowed;
- (void)setPrimitiveFixedTargetPaymentAllowed:(NSNumber*)value;

- (BOOL)primitiveFixedTargetPaymentAllowedValue;
- (void)setPrimitiveFixedTargetPaymentAllowedValue:(BOOL)value_;

- (NSNumber*)primitiveHidden;
- (void)setPrimitiveHidden:(NSNumber*)value;

- (BOOL)primitiveHiddenValue;
- (void)setPrimitiveHiddenValue:(BOOL)value_;

- (NSNumber*)primitiveIndex;
- (void)setPrimitiveIndex:(NSNumber*)value;

- (int16_t)primitiveIndexValue;
- (void)setPrimitiveIndexValue:(int16_t)value_;

- (NSNumber*)primitiveMinInvoiceAmount;
- (void)setPrimitiveMinInvoiceAmount:(NSNumber*)value;

- (int32_t)primitiveMinInvoiceAmountValue;
- (void)setPrimitiveMinInvoiceAmountValue:(int32_t)value_;

- (Currency*)primitiveCurrency;
- (void)setPrimitiveCurrency:(Currency*)value;

- (PairSourceCurrency*)primitiveSource;
- (void)setPrimitiveSource:(PairSourceCurrency*)value;

@end
