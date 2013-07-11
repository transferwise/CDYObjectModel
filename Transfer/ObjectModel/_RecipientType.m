// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipientType.m instead.

#import "_RecipientType.h"

const struct RecipientTypeAttributes RecipientTypeAttributes = {
	.title = @"title",
	.type = @"type",
};

const struct RecipientTypeRelationships RecipientTypeRelationships = {
	.fields = @"fields",
	.recipients = @"recipients",
};

const struct RecipientTypeFetchedProperties RecipientTypeFetchedProperties = {
};

@implementation RecipientTypeID
@end

@implementation _RecipientType

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"RecipientType" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"RecipientType";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"RecipientType" inManagedObjectContext:moc_];
}

- (RecipientTypeID*)objectID {
	return (RecipientTypeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic title;






@dynamic type;






@dynamic fields;

	
- (NSMutableOrderedSet*)fieldsSet {
	[self willAccessValueForKey:@"fields"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"fields"];
  
	[self didAccessValueForKey:@"fields"];
	return result;
}
	

@dynamic recipients;

	
- (NSMutableSet*)recipientsSet {
	[self willAccessValueForKey:@"recipients"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"recipients"];
  
	[self didAccessValueForKey:@"recipients"];
	return result;
}
	






@end
