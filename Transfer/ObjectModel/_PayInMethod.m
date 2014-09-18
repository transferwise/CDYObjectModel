// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PayInMethod.m instead.

#import "_PayInMethod.h"

const struct PayInMethodAttributes PayInMethodAttributes = {
	.bankName = @"bankName",
	.disabled = @"disabled",
	.disabledReason = @"disabledReason",
	.paymentReference = @"paymentReference",
	.transferWiseAddress = @"transferWiseAddress",
	.type = @"type",
};

const struct PayInMethodRelationships PayInMethodRelationships = {
	.payment = @"payment",
	.recipient = @"recipient",
};

@implementation PayInMethodID
@end

@implementation _PayInMethod

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PayInMethod" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PayInMethod";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PayInMethod" inManagedObjectContext:moc_];
}

- (PayInMethodID*)objectID {
	return (PayInMethodID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"disabledValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"disabled"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic bankName;

@dynamic disabled;

- (BOOL)disabledValue {
	NSNumber *result = [self disabled];
	return [result boolValue];
}

- (void)setDisabledValue:(BOOL)value_ {
	[self setDisabled:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveDisabledValue {
	NSNumber *result = [self primitiveDisabled];
	return [result boolValue];
}

- (void)setPrimitiveDisabledValue:(BOOL)value_ {
	[self setPrimitiveDisabled:[NSNumber numberWithBool:value_]];
}

@dynamic disabledReason;

@dynamic paymentReference;

@dynamic transferWiseAddress;

@dynamic type;

@dynamic payment;

@dynamic recipient;

@end

