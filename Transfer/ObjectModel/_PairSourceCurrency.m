// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PairSourceCurrency.m instead.

#import "_PairSourceCurrency.h"

const struct PairSourceCurrencyAttributes PairSourceCurrencyAttributes = {
	.index = @"index",
	.maxInvoiceAmount = @"maxInvoiceAmount",
};

const struct PairSourceCurrencyRelationships PairSourceCurrencyRelationships = {
	.currency = @"currency",
	.targets = @"targets",
};

const struct PairSourceCurrencyFetchedProperties PairSourceCurrencyFetchedProperties = {
};

@implementation PairSourceCurrencyID
@end

@implementation _PairSourceCurrency

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PairSourceCurrency" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PairSourceCurrency";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PairSourceCurrency" inManagedObjectContext:moc_];
}

- (PairSourceCurrencyID*)objectID {
	return (PairSourceCurrencyID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"maxInvoiceAmountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"maxInvoiceAmount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
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





@dynamic maxInvoiceAmount;



- (int32_t)maxInvoiceAmountValue {
	NSNumber *result = [self maxInvoiceAmount];
	return [result intValue];
}

- (void)setMaxInvoiceAmountValue:(int32_t)value_ {
	[self setMaxInvoiceAmount:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveMaxInvoiceAmountValue {
	NSNumber *result = [self primitiveMaxInvoiceAmount];
	return [result intValue];
}

- (void)setPrimitiveMaxInvoiceAmountValue:(int32_t)value_ {
	[self setPrimitiveMaxInvoiceAmount:[NSNumber numberWithInt:value_]];
}





@dynamic currency;

	

@dynamic targets;

	
- (NSMutableSet*)targetsSet {
	[self willAccessValueForKey:@"targets"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"targets"];
  
	[self didAccessValueForKey:@"targets"];
	return result;
}
	






@end
