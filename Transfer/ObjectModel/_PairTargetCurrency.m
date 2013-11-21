// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PairTargetCurrency.m instead.

#import "_PairTargetCurrency.h"

const struct PairTargetCurrencyAttributes PairTargetCurrencyAttributes = {
	.fixedTargetPaymentAllowed = @"fixedTargetPaymentAllowed",
	.hidden = @"hidden",
	.index = @"index",
	.minInvoiceAmount = @"minInvoiceAmount",
};

const struct PairTargetCurrencyRelationships PairTargetCurrencyRelationships = {
	.currency = @"currency",
	.source = @"source",
};

const struct PairTargetCurrencyFetchedProperties PairTargetCurrencyFetchedProperties = {
};

@implementation PairTargetCurrencyID
@end

@implementation _PairTargetCurrency

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PairTargetCurrency" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PairTargetCurrency";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PairTargetCurrency" inManagedObjectContext:moc_];
}

- (PairTargetCurrencyID*)objectID {
	return (PairTargetCurrencyID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"fixedTargetPaymentAllowedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"fixedTargetPaymentAllowed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"hiddenValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hidden"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"minInvoiceAmountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"minInvoiceAmount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic fixedTargetPaymentAllowed;



- (BOOL)fixedTargetPaymentAllowedValue {
	NSNumber *result = [self fixedTargetPaymentAllowed];
	return [result boolValue];
}

- (void)setFixedTargetPaymentAllowedValue:(BOOL)value_ {
	[self setFixedTargetPaymentAllowed:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveFixedTargetPaymentAllowedValue {
	NSNumber *result = [self primitiveFixedTargetPaymentAllowed];
	return [result boolValue];
}

- (void)setPrimitiveFixedTargetPaymentAllowedValue:(BOOL)value_ {
	[self setPrimitiveFixedTargetPaymentAllowed:[NSNumber numberWithBool:value_]];
}





@dynamic hidden;



- (BOOL)hiddenValue {
	NSNumber *result = [self hidden];
	return [result boolValue];
}

- (void)setHiddenValue:(BOOL)value_ {
	[self setHidden:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHiddenValue {
	NSNumber *result = [self primitiveHidden];
	return [result boolValue];
}

- (void)setPrimitiveHiddenValue:(BOOL)value_ {
	[self setPrimitiveHidden:[NSNumber numberWithBool:value_]];
}





@dynamic index;



- (int16_t)indexValue {
	NSNumber *result = [self index];
	return [result shortValue];
}

- (void)setIndexValue:(int16_t)value_ {
	[self setIndex:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveIndexValue {
	NSNumber *result = [self primitiveIndex];
	return [result shortValue];
}

- (void)setPrimitiveIndexValue:(int16_t)value_ {
	[self setPrimitiveIndex:[NSNumber numberWithShort:value_]];
}





@dynamic minInvoiceAmount;



- (int32_t)minInvoiceAmountValue {
	NSNumber *result = [self minInvoiceAmount];
	return [result intValue];
}

- (void)setMinInvoiceAmountValue:(int32_t)value_ {
	[self setMinInvoiceAmount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMinInvoiceAmountValue {
	NSNumber *result = [self primitiveMinInvoiceAmount];
	return [result intValue];
}

- (void)setPrimitiveMinInvoiceAmountValue:(int32_t)value_ {
	[self setPrimitiveMinInvoiceAmount:[NSNumber numberWithInt:value_]];
}





@dynamic currency;

	

@dynamic source;

	






@end
