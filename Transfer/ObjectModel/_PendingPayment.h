// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PendingPayment.h instead.

#import <CoreData/CoreData.h>
#import "Payment.h"

extern const struct PendingPaymentAttributes {
	__unsafe_unretained NSString *addressVerificationRequired;
	__unsafe_unretained NSString *idVerificationRequired;
	__unsafe_unretained NSString *paymentPurpose;
	__unsafe_unretained NSString *paymentPurposeRequired;
	__unsafe_unretained NSString *proposedPaymentsPurpose;
	__unsafe_unretained NSString *recipientEmail;
	__unsafe_unretained NSString *reference;
	__unsafe_unretained NSString *sendVerificationLater;
} PendingPaymentAttributes;

extern const struct PendingPaymentRelationships {
} PendingPaymentRelationships;

extern const struct PendingPaymentFetchedProperties {
} PendingPaymentFetchedProperties;











@interface PendingPaymentID : NSManagedObjectID {}
@end

@interface _PendingPayment : Payment {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PendingPaymentID*)objectID;





@property (nonatomic, strong) NSNumber* addressVerificationRequired;



@property BOOL addressVerificationRequiredValue;
- (BOOL)addressVerificationRequiredValue;
- (void)setAddressVerificationRequiredValue:(BOOL)value_;

//- (BOOL)validateAddressVerificationRequired:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* idVerificationRequired;



@property BOOL idVerificationRequiredValue;
- (BOOL)idVerificationRequiredValue;
- (void)setIdVerificationRequiredValue:(BOOL)value_;

//- (BOOL)validateIdVerificationRequired:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* paymentPurpose;



//- (BOOL)validatePaymentPurpose:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* paymentPurposeRequired;



@property BOOL paymentPurposeRequiredValue;
- (BOOL)paymentPurposeRequiredValue;
- (void)setPaymentPurposeRequiredValue:(BOOL)value_;

//- (BOOL)validatePaymentPurposeRequired:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* proposedPaymentsPurpose;



//- (BOOL)validateProposedPaymentsPurpose:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* recipientEmail;



//- (BOOL)validateRecipientEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* reference;



//- (BOOL)validateReference:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* sendVerificationLater;



@property BOOL sendVerificationLaterValue;
- (BOOL)sendVerificationLaterValue;
- (void)setSendVerificationLaterValue:(BOOL)value_;

//- (BOOL)validateSendVerificationLater:(id*)value_ error:(NSError**)error_;






@end

@interface _PendingPayment (CoreDataGeneratedAccessors)

@end

@interface _PendingPayment (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveAddressVerificationRequired;
- (void)setPrimitiveAddressVerificationRequired:(NSNumber*)value;

- (BOOL)primitiveAddressVerificationRequiredValue;
- (void)setPrimitiveAddressVerificationRequiredValue:(BOOL)value_;




- (NSNumber*)primitiveIdVerificationRequired;
- (void)setPrimitiveIdVerificationRequired:(NSNumber*)value;

- (BOOL)primitiveIdVerificationRequiredValue;
- (void)setPrimitiveIdVerificationRequiredValue:(BOOL)value_;




- (NSString*)primitivePaymentPurpose;
- (void)setPrimitivePaymentPurpose:(NSString*)value;




- (NSNumber*)primitivePaymentPurposeRequired;
- (void)setPrimitivePaymentPurposeRequired:(NSNumber*)value;

- (BOOL)primitivePaymentPurposeRequiredValue;
- (void)setPrimitivePaymentPurposeRequiredValue:(BOOL)value_;




- (NSString*)primitiveProposedPaymentsPurpose;
- (void)setPrimitiveProposedPaymentsPurpose:(NSString*)value;




- (NSString*)primitiveRecipientEmail;
- (void)setPrimitiveRecipientEmail:(NSString*)value;




- (NSString*)primitiveReference;
- (void)setPrimitiveReference:(NSString*)value;




- (NSNumber*)primitiveSendVerificationLater;
- (void)setPrimitiveSendVerificationLater:(NSNumber*)value;

- (BOOL)primitiveSendVerificationLaterValue;
- (void)setPrimitiveSendVerificationLaterValue:(BOOL)value_;




@end
