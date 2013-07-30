// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recipient.m instead.

#import "_Recipient.h"

const struct RecipientAttributes RecipientAttributes = {
	.email = @"email",
	.name = @"name",
	.remoteId = @"remoteId",
	.settlementRecipient = @"settlementRecipient",
	.temporary = @"temporary",
};

const struct RecipientRelationships RecipientRelationships = {
	.currency = @"currency",
	.fieldValues = @"fieldValues",
	.payments = @"payments",
	.settlementForPayments = @"settlementForPayments",
	.type = @"type",
	.user = @"user",
};

const struct RecipientFetchedProperties RecipientFetchedProperties = {
};

@implementation RecipientID
@end

@implementation _Recipient

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Recipient" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Recipient";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Recipient" inManagedObjectContext:moc_];
}

- (RecipientID*)objectID {
	return (RecipientID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"remoteIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"remoteId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"settlementRecipientValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"settlementRecipient"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"temporaryValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"temporary"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic email;






@dynamic name;






@dynamic remoteId;



- (int32_t)remoteIdValue {
	NSNumber *result = [self remoteId];
	return [result intValue];
}

- (void)setRemoteIdValue:(int32_t)value_ {
	[self setRemoteId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRemoteIdValue {
	NSNumber *result = [self primitiveRemoteId];
	return [result intValue];
}

- (void)setPrimitiveRemoteIdValue:(int32_t)value_ {
	[self setPrimitiveRemoteId:[NSNumber numberWithInt:value_]];
}





@dynamic settlementRecipient;



- (BOOL)settlementRecipientValue {
	NSNumber *result = [self settlementRecipient];
	return [result boolValue];
}

- (void)setSettlementRecipientValue:(BOOL)value_ {
	[self setSettlementRecipient:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSettlementRecipientValue {
	NSNumber *result = [self primitiveSettlementRecipient];
	return [result boolValue];
}

- (void)setPrimitiveSettlementRecipientValue:(BOOL)value_ {
	[self setPrimitiveSettlementRecipient:[NSNumber numberWithBool:value_]];
}





@dynamic temporary;



- (BOOL)temporaryValue {
	NSNumber *result = [self temporary];
	return [result boolValue];
}

- (void)setTemporaryValue:(BOOL)value_ {
	[self setTemporary:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveTemporaryValue {
	NSNumber *result = [self primitiveTemporary];
	return [result boolValue];
}

- (void)setPrimitiveTemporaryValue:(BOOL)value_ {
	[self setPrimitiveTemporary:[NSNumber numberWithBool:value_]];
}





@dynamic currency;

	

@dynamic fieldValues;

	
- (NSMutableOrderedSet*)fieldValuesSet {
	[self willAccessValueForKey:@"fieldValues"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"fieldValues"];
  
	[self didAccessValueForKey:@"fieldValues"];
	return result;
}
	

@dynamic payments;

	
- (NSMutableSet*)paymentsSet {
	[self willAccessValueForKey:@"payments"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"payments"];
  
	[self didAccessValueForKey:@"payments"];
	return result;
}
	

@dynamic settlementForPayments;

	
- (NSMutableSet*)settlementForPaymentsSet {
	[self willAccessValueForKey:@"settlementForPayments"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"settlementForPayments"];
  
	[self didAccessValueForKey:@"settlementForPayments"];
	return result;
}
	

@dynamic type;

	

@dynamic user;

	






@end