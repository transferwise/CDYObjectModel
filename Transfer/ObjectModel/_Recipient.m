// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recipient.m instead.

#import "_Recipient.h"

const struct RecipientAttributes RecipientAttributes = {
	.addressCity = @"addressCity",
	.addressCountryCode = @"addressCountryCode",
	.addressFirstLine = @"addressFirstLine",
	.addressPostCode = @"addressPostCode",
	.addressState = @"addressState",
	.email = @"email",
	.hidden = @"hidden",
	.name = @"name",
	.remoteId = @"remoteId",
};

const struct RecipientRelationships RecipientRelationships = {
	.currency = @"currency",
	.fieldValues = @"fieldValues",
	.payInMethods = @"payInMethods",
	.payments = @"payments",
	.refundForPayment = @"refundForPayment",
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
	
	if ([key isEqualToString:@"hiddenValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hidden"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"remoteIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"remoteId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic addressCity;






@dynamic addressCountryCode;






@dynamic addressFirstLine;






@dynamic addressPostCode;






@dynamic addressState;






@dynamic email;






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





@dynamic currency;

	

@dynamic fieldValues;

	
- (NSMutableOrderedSet*)fieldValuesSet {
	[self willAccessValueForKey:@"fieldValues"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"fieldValues"];
  
	[self didAccessValueForKey:@"fieldValues"];
	return result;
}
	

@dynamic payInMethods;

	
- (NSMutableSet*)payInMethodsSet {
	[self willAccessValueForKey:@"payInMethods"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"payInMethods"];
  
	[self didAccessValueForKey:@"payInMethods"];
	return result;
}
	

@dynamic payments;

	
- (NSMutableSet*)paymentsSet {
	[self willAccessValueForKey:@"payments"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"payments"];
  
	[self didAccessValueForKey:@"payments"];
	return result;
}
	

@dynamic refundForPayment;

	

@dynamic type;

	

@dynamic user;

	






@end
