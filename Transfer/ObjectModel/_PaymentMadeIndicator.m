// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PaymentMadeIndicator.m instead.

#import "_PaymentMadeIndicator.h"

const struct PaymentMadeIndicatorAttributes PaymentMadeIndicatorAttributes = {
	.paymentRemoteId = @"paymentRemoteId",
};

const struct PaymentMadeIndicatorRelationships PaymentMadeIndicatorRelationships = {
	.payment = @"payment",
};

const struct PaymentMadeIndicatorFetchedProperties PaymentMadeIndicatorFetchedProperties = {
};

@implementation PaymentMadeIndicatorID
@end

@implementation _PaymentMadeIndicator

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PaymentMadeIndicator" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PaymentMadeIndicator";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PaymentMadeIndicator" inManagedObjectContext:moc_];
}

- (PaymentMadeIndicatorID*)objectID {
	return (PaymentMadeIndicatorID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"paymentRemoteIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"paymentRemoteId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic paymentRemoteId;



- (int32_t)paymentRemoteIdValue {
	NSNumber *result = [self paymentRemoteId];
	return [result intValue];
}

- (void)setPaymentRemoteIdValue:(int32_t)value_ {
	[self setPaymentRemoteId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitivePaymentRemoteIdValue {
	NSNumber *result = [self primitivePaymentRemoteId];
	return [result intValue];
}

- (void)setPrimitivePaymentRemoteIdValue:(int32_t)value_ {
	[self setPrimitivePaymentRemoteId:[NSNumber numberWithInt:value_]];
}





@dynamic payment;

	






@end
