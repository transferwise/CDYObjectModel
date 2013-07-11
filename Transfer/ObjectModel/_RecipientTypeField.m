// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipientTypeField.m instead.

#import "_RecipientTypeField.h"

const struct RecipientTypeFieldAttributes RecipientTypeFieldAttributes = {
	.name = @"name",
};

const struct RecipientTypeFieldRelationships RecipientTypeFieldRelationships = {
	.fieldForType = @"fieldForType",
	.values = @"values",
};

const struct RecipientTypeFieldFetchedProperties RecipientTypeFieldFetchedProperties = {
};

@implementation RecipientTypeFieldID
@end

@implementation _RecipientTypeField

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RecipientTypeField" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RecipientTypeField";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RecipientTypeField" inManagedObjectContext:moc_];
}

- (RecipientTypeFieldID*)objectID {
	return (RecipientTypeFieldID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic name;






@dynamic fieldForType;

	

@dynamic values;

	
- (NSMutableSet*)valuesSet {
	[self willAccessValueForKey:@"values"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"values"];
  
	[self didAccessValueForKey:@"values"];
	return result;
}
	






@end
