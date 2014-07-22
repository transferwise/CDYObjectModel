// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Currency.m instead.

#import "_Currency.h"

const struct CurrencyAttributes CurrencyAttributes = {
	.code = @"code",
	.index = @"index",
	.name = @"name",
	.referenceMaxLength = @"referenceMaxLength",
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
	if ([key isEqualToString:@"referenceMaxLengthValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"referenceMaxLength"];
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






@dynamic referenceMaxLength;



- (int16_t)referenceMaxLengthValue {
	NSNumber *result = [self referenceMaxLength];
	return [result shortValue];
}

- (void)setReferenceMaxLengthValue:(int16_t)value_ {
	[self setReferenceMaxLength:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveReferenceMaxLengthValue {
	NSNumber *result = [self primitiveReferenceMaxLength];
	return [result shortValue];
}

- (void)setPrimitiveReferenceMaxLengthValue:(int16_t)value_ {
	[self setPrimitiveReferenceMaxLength:[NSNumber numberWithShort:value_]];
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
