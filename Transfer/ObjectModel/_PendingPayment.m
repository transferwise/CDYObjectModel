// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PendingPayment.m instead.

#import "_PendingPayment.h"

const struct PendingPaymentAttributes PendingPaymentAttributes = {
	.payOut = @"payOut",
	.profileUsed = @"profileUsed",
	.rate = @"rate",
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
	
	if ([key isEqualToString:@"rateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"rate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic payOut;






@dynamic profileUsed;






@dynamic rate;



- (double)rateValue {
	NSNumber *result = [self rate];
	return [result doubleValue];
}

- (void)setRateValue:(double)value_ {
	[self setRate:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveRateValue {
	NSNumber *result = [self primitiveRate];
	return [result doubleValue];
}

- (void)setPrimitiveRateValue:(double)value_ {
	[self setPrimitiveRate:[NSNumber numberWithDouble:value_]];
}










@end
