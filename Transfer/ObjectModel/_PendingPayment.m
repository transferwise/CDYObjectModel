// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PendingPayment.m instead.

#import "_PendingPayment.h"

const struct PendingPaymentAttributes PendingPaymentAttributes = {
	.paymentPurpose = @"paymentPurpose",
	.proposedPaymentsPurpose = @"proposedPaymentsPurpose",
	.recipientEmail = @"recipientEmail",
	.reference = @"reference",
	.sendVerificationLater = @"sendVerificationLater",
	.socialSecurityNumber = @"socialSecurityNumber",
	.transferwiseTransferFee = @"transferwiseTransferFee",
	.verificiationNeeded = @"verificiationNeeded",
};

const struct PendingPaymentRelationships PendingPaymentRelationships = {
	.allowedRecipientTypes = @"allowedRecipientTypes",
};

const struct PendingPaymentFetchedProperties PendingPaymentFetchedProperties = {
};

@implementation PendingPaymentID
@end

@implementation _PendingPayment

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PendingPayment" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PendingPayment";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PendingPayment" inManagedObjectContext:moc_];
}

- (PendingPaymentID*)objectID {
	return (PendingPaymentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"sendVerificationLaterValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sendVerificationLater"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"transferwiseTransferFeeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"transferwiseTransferFee"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"verificiationNeededValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"verificiationNeeded"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic paymentPurpose;






@dynamic proposedPaymentsPurpose;






@dynamic recipientEmail;






@dynamic reference;






@dynamic sendVerificationLater;



- (BOOL)sendVerificationLaterValue {
	NSNumber *result = [self sendVerificationLater];
	return [result boolValue];
}

- (void)setSendVerificationLaterValue:(BOOL)value_ {
	[self setSendVerificationLater:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSendVerificationLaterValue {
	NSNumber *result = [self primitiveSendVerificationLater];
	return [result boolValue];
}

- (void)setPrimitiveSendVerificationLaterValue:(BOOL)value_ {
	[self setPrimitiveSendVerificationLater:[NSNumber numberWithBool:value_]];
}





@dynamic socialSecurityNumber;






@dynamic transferwiseTransferFee;



- (double)transferwiseTransferFeeValue {
	NSNumber *result = [self transferwiseTransferFee];
	return [result doubleValue];
}

- (void)setTransferwiseTransferFeeValue:(double)value_ {
	[self setTransferwiseTransferFee:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveTransferwiseTransferFeeValue {
	NSNumber *result = [self primitiveTransferwiseTransferFee];
	return [result doubleValue];
}

- (void)setPrimitiveTransferwiseTransferFeeValue:(double)value_ {
	[self setPrimitiveTransferwiseTransferFee:[NSNumber numberWithDouble:value_]];
}





@dynamic verificiationNeeded;



- (int16_t)verificiationNeededValue {
	NSNumber *result = [self verificiationNeeded];
	return [result shortValue];
}

- (void)setVerificiationNeededValue:(int16_t)value_ {
	[self setVerificiationNeeded:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveVerificiationNeededValue {
	NSNumber *result = [self primitiveVerificiationNeeded];
	return [result shortValue];
}

- (void)setPrimitiveVerificiationNeededValue:(int16_t)value_ {
	[self setPrimitiveVerificiationNeeded:[NSNumber numberWithShort:value_]];
}





@dynamic allowedRecipientTypes;

	
- (NSMutableOrderedSet*)allowedRecipientTypesSet {
	[self willAccessValueForKey:@"allowedRecipientTypes"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"allowedRecipientTypes"];
  
	[self didAccessValueForKey:@"allowedRecipientTypes"];
	return result;
}
	






@end
