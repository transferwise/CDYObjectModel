// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Currency.m instead.

#import "_Currency.h"

const struct CurrencyAttributes CurrencyAttributes = {
	.code = @"code",
	.index = @"index",
	.name = @"name",
	.paymentReferenceAllowed = @"paymentReferenceAllowed",
	.recipientBicRequired = @"recipientBicRequired",
	.recipientEmailRequired = @"recipientEmailRequired",
	.symbol = @"symbol",
};

const struct CurrencyRelationships CurrencyRelationships = {
	.currencyForRecipients = @"currencyForRecipients",
	.defaultRecipientType = @"defaultRecipientType",
	.recipientTypes = @"recipientTypes",
	.sourceForPayments = @"sourceForPayments",
	.sources = @"sources",
	.targetForPayments = @"targetForPayments",
	.targets = @"targets",
};

const struct CurrencyFetchedProperties CurrencyFetchedProperties = {
};

@implementation CurrencyID
@end

@implementation _Currency

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Currency" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Currency";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Currency" inManagedObjectContext:moc_];
}

- (CurrencyID*)objectID {
	return (CurrencyID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"indexValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"index"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"paymentReferenceAllowedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"paymentReferenceAllowed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"recipientBicRequiredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"recipientBicRequired"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"recipientEmailRequiredValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"recipientEmailRequired"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic code;






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





@dynamic name;






@dynamic paymentReferenceAllowed;



- (BOOL)paymentReferenceAllowedValue {
	NSNumber *result = [self paymentReferenceAllowed];
	return [result boolValue];
}

- (void)setPaymentReferenceAllowedValue:(BOOL)value_ {
	[self setPaymentReferenceAllowed:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePaymentReferenceAllowedValue {
	NSNumber *result = [self primitivePaymentReferenceAllowed];
	return [result boolValue];
}

- (void)setPrimitivePaymentReferenceAllowedValue:(BOOL)value_ {
	[self setPrimitivePaymentReferenceAllowed:[NSNumber numberWithBool:value_]];
}





@dynamic recipientBicRequired;



- (BOOL)recipientBicRequiredValue {
	NSNumber *result = [self recipientBicRequired];
	return [result boolValue];
}

- (void)setRecipientBicRequiredValue:(BOOL)value_ {
	[self setRecipientBicRequired:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveRecipientBicRequiredValue {
	NSNumber *result = [self primitiveRecipientBicRequired];
	return [result boolValue];
}

- (void)setPrimitiveRecipientBicRequiredValue:(BOOL)value_ {
	[self setPrimitiveRecipientBicRequired:[NSNumber numberWithBool:value_]];
}





@dynamic recipientEmailRequired;



- (BOOL)recipientEmailRequiredValue {
	NSNumber *result = [self recipientEmailRequired];
	return [result boolValue];
}

- (void)setRecipientEmailRequiredValue:(BOOL)value_ {
	[self setRecipientEmailRequired:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveRecipientEmailRequiredValue {
	NSNumber *result = [self primitiveRecipientEmailRequired];
	return [result boolValue];
}

- (void)setPrimitiveRecipientEmailRequiredValue:(BOOL)value_ {
	[self setPrimitiveRecipientEmailRequired:[NSNumber numberWithBool:value_]];
}





@dynamic symbol;






@dynamic currencyForRecipients;

	
- (NSMutableSet*)currencyForRecipientsSet {
	[self willAccessValueForKey:@"currencyForRecipients"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"currencyForRecipients"];
  
	[self didAccessValueForKey:@"currencyForRecipients"];
	return result;
}
	

@dynamic defaultRecipientType;

	

@dynamic recipientTypes;

	
- (NSMutableOrderedSet*)recipientTypesSet {
	[self willAccessValueForKey:@"recipientTypes"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"recipientTypes"];
  
	[self didAccessValueForKey:@"recipientTypes"];
	return result;
}
	

@dynamic sourceForPayments;

	
- (NSMutableSet*)sourceForPaymentsSet {
	[self willAccessValueForKey:@"sourceForPayments"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"sourceForPayments"];
  
	[self didAccessValueForKey:@"sourceForPayments"];
	return result;
}
	

@dynamic sources;

	
- (NSMutableSet*)sourcesSet {
	[self willAccessValueForKey:@"sources"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"sources"];
  
	[self didAccessValueForKey:@"sources"];
	return result;
}
	

@dynamic targetForPayments;

	
- (NSMutableSet*)targetForPaymentsSet {
	[self willAccessValueForKey:@"targetForPayments"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"targetForPayments"];
  
	[self didAccessValueForKey:@"targetForPayments"];
	return result;
}
	

@dynamic targets;

	
- (NSMutableSet*)targetsSet {
	[self willAccessValueForKey:@"targets"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"targets"];
  
	[self didAccessValueForKey:@"targets"];
	return result;
}
	






@end
