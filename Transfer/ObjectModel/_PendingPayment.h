// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PendingPayment.h instead.

#import <CoreData/CoreData.h>
#import "Payment.h"

extern const struct PendingPaymentAttributes {
	__unsafe_unretained NSString *paymentPurpose;
	__unsafe_unretained NSString *proposedPaymentsPurpose;
	__unsafe_unretained NSString *recipientEmail;
	__unsafe_unretained NSString *reference;
	__unsafe_unretained NSString *sendVerificationLater;
	__unsafe_unretained NSString *transferwiseTransferFee;
	__unsafe_unretained NSString *verificiationNeeded;
} PendingPaymentAttributes;

extern const struct PendingPaymentRelationships {
	__unsafe_unretained NSString *allowedRecipientTypes;
} PendingPaymentRelationships;

extern const struct PendingPaymentFetchedProperties {
} PendingPaymentFetchedProperties;

@class RecipientType;









@interface PendingPaymentID : NSManagedObjectID {}
@end

@interface _PendingPayment : Payment {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PendingPaymentID*)objectID;





@property (nonatomic, strong) NSString* paymentPurpose;



//- (BOOL)validatePaymentPurpose:(id*)value_ error:(NSError**)error_;





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





@property (nonatomic, strong) NSNumber* transferwiseTransferFee;



@property double transferwiseTransferFeeValue;
- (double)transferwiseTransferFeeValue;
- (void)setTransferwiseTransferFeeValue:(double)value_;

//- (BOOL)validateTransferwiseTransferFee:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* verificiationNeeded;



@property int16_t verificiationNeededValue;
- (int16_t)verificiationNeededValue;
- (void)setVerificiationNeededValue:(int16_t)value_;

//- (BOOL)validateVerificiationNeeded:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSOrderedSet *allowedRecipientTypes;

- (NSMutableOrderedSet*)allowedRecipientTypesSet;





@end

@interface _PendingPayment (CoreDataGeneratedAccessors)

- (void)addAllowedRecipientTypes:(NSOrderedSet*)value_;
- (void)removeAllowedRecipientTypes:(NSOrderedSet*)value_;
- (void)addAllowedRecipientTypesObject:(RecipientType*)value_;
- (void)removeAllowedRecipientTypesObject:(RecipientType*)value_;

@end

@interface _PendingPayment (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitivePaymentPurpose;
- (void)setPrimitivePaymentPurpose:(NSString*)value;




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




- (NSNumber*)primitiveTransferwiseTransferFee;
- (void)setPrimitiveTransferwiseTransferFee:(NSNumber*)value;

- (double)primitiveTransferwiseTransferFeeValue;
- (void)setPrimitiveTransferwiseTransferFeeValue:(double)value_;




- (NSNumber*)primitiveVerificiationNeeded;
- (void)setPrimitiveVerificiationNeeded:(NSNumber*)value;

- (int16_t)primitiveVerificiationNeededValue;
- (void)setPrimitiveVerificiationNeededValue:(int16_t)value_;





- (NSMutableOrderedSet*)primitiveAllowedRecipientTypes;
- (void)setPrimitiveAllowedRecipientTypes:(NSMutableOrderedSet*)value;


@end
