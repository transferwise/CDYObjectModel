// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PayInMethod.h instead.

#import <CoreData/CoreData.h>


extern const struct PayInMethodAttributes {
	__unsafe_unretained NSString *bankName;
	__unsafe_unretained NSString *disabled;
	__unsafe_unretained NSString *disabledReason;
	__unsafe_unretained NSString *paymentReference;
	__unsafe_unretained NSString *transferWiseAddress;
	__unsafe_unretained NSString *type;
} PayInMethodAttributes;

extern const struct PayInMethodRelationships {
	__unsafe_unretained NSString *payment;
	__unsafe_unretained NSString *recipient;
} PayInMethodRelationships;

extern const struct PayInMethodFetchedProperties {
} PayInMethodFetchedProperties;

@class Payment;
@class Recipient;








@interface PayInMethodID : NSManagedObjectID {}
@end

@interface _PayInMethod : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PayInMethodID*)objectID;





@property (nonatomic, strong) NSString* bankName;



//- (BOOL)validateBankName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* disabled;



@property BOOL disabledValue;
- (BOOL)disabledValue;
- (void)setDisabledValue:(BOOL)value_;

//- (BOOL)validateDisabled:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* disabledReason;



//- (BOOL)validateDisabledReason:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* paymentReference;



//- (BOOL)validatePaymentReference:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* transferWiseAddress;



//- (BOOL)validateTransferWiseAddress:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* type;



//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) Payment *payment;

//- (BOOL)validatePayment:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) Recipient *recipient;

//- (BOOL)validateRecipient:(id*)value_ error:(NSError**)error_;





@end

@interface _PayInMethod (CoreDataGeneratedAccessors)

@end

@interface _PayInMethod (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveBankName;
- (void)setPrimitiveBankName:(NSString*)value;




- (NSNumber*)primitiveDisabled;
- (void)setPrimitiveDisabled:(NSNumber*)value;

- (BOOL)primitiveDisabledValue;
- (void)setPrimitiveDisabledValue:(BOOL)value_;




- (NSString*)primitiveDisabledReason;
- (void)setPrimitiveDisabledReason:(NSString*)value;




- (NSString*)primitivePaymentReference;
- (void)setPrimitivePaymentReference:(NSString*)value;




- (NSString*)primitiveTransferWiseAddress;
- (void)setPrimitiveTransferWiseAddress:(NSString*)value;




- (NSString*)primitiveType;
- (void)setPrimitiveType:(NSString*)value;





- (Payment*)primitivePayment;
- (void)setPrimitivePayment:(Payment*)value;



- (Recipient*)primitiveRecipient;
- (void)setPrimitiveRecipient:(Recipient*)value;


@end
