// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PendingPayment.m instead.

#import "_PendingPayment.h"

const struct PendingPaymentAttributes PendingPaymentAttributes = {
	.addressVerificationRequired = @"addressVerificationRequired",
	.idVerificationRequired = @"idVerificationRequired",
	.paymentPurpose = @"paymentPurpose",
	.paymentPurposeRequired = @"paymentPurposeRequired",
	.proposedPaymentsPurpose = @"proposedPaymentsPurpose",
	.recipientEmail = @"recipientEmail",
	.reference = @"reference",
	.sendVerificationLater = @"sendVerificationLater",
};

const struct PendingPaymentRelationships PendingPaymentRelationships = {
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
	
	if ([key isEqualToString:@"addressVerificationRequiredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"addressVerificationRequired"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"idVerificationRequiredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"idVerificationRequired"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"paymentPurposeRequiredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"paymentPurposeRequired"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sendVerificationLaterValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sendVerificationLater"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic addressVerificationRequired;



- (BOOL)addressVerificationRequiredValue {
	NSNumber *result = [self addressVerificationRequired];
	return [result boolValue];
}

- (void)setAddressVerificationRequiredValue:(BOOL)value_ {
	[self setAddressVerificationRequired:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveAddressVerificationRequiredValue {
	NSNumber *result = [self primitiveAddressVerificationRequired];
	return [result boolValue];
}

- (void)setPrimitiveAddressVerificationRequiredValue:(BOOL)value_ {
	[self setPrimitiveAddressVerificationRequired:[NSNumber numberWithBool:value_]];
}





@dynamic idVerificationRequired;



- (BOOL)idVerificationRequiredValue {
	NSNumber *result = [self idVerificationRequired];
	return [result boolValue];
}

- (void)setIdVerificationRequiredValue:(BOOL)value_ {
	[self setIdVerificationRequired:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIdVerificationRequiredValue {
	NSNumber *result = [self primitiveIdVerificationRequired];
	return [result boolValue];
}

- (void)setPrimitiveIdVerificationRequiredValue:(BOOL)value_ {
	[self setPrimitiveIdVerificationRequired:[NSNumber numberWithBool:value_]];
}





@dynamic paymentPurpose;






@dynamic paymentPurposeRequired;



- (BOOL)paymentPurposeRequiredValue {
	NSNumber *result = [self paymentPurposeRequired];
	return [result boolValue];
}

- (void)setPaymentPurposeRequiredValue:(BOOL)value_ {
	[self setPaymentPurposeRequired:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePaymentPurposeRequiredValue {
	NSNumber *result = [self primitivePaymentPurposeRequired];
	return [result boolValue];
}

- (void)setPrimitivePaymentPurposeRequiredValue:(BOOL)value_ {
	[self setPrimitivePaymentPurposeRequired:[NSNumber numberWithBool:value_]];
}





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










@end
