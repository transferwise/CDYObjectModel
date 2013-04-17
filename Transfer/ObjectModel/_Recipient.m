// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recipient.m instead.

#import "_Recipient.h"

const struct RecipientAttributes RecipientAttributes = {
	.name = @"name",
	.recipientID = @"recipientID",
};

const struct RecipientRelationships RecipientRelationships = {
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
	
	if ([key isEqualToString:@"recipientIDValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"recipientID"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic name;






@dynamic recipientID;



- (int32_t)recipientIDValue {
	NSNumber *result = [self recipientID];
	return [result intValue];
}

- (void)setRecipientIDValue:(int32_t)value_ {
	[self setRecipientID:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRecipientIDValue {
	NSNumber *result = [self primitiveRecipientID];
	return [result intValue];
}

- (void)setPrimitiveRecipientIDValue:(int32_t)value_ {
	[self setPrimitiveRecipientID:[NSNumber numberWithInt:value_]];
}










@end
