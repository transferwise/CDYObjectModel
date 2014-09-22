// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AllowedTypeFieldValue.m instead.

#import "_AllowedTypeFieldValue.h"

const struct AllowedTypeFieldValueAttributes AllowedTypeFieldValueAttributes = {
	.code = @"code",
	.title = @"title",
};

const struct AllowedTypeFieldValueRelationships AllowedTypeFieldValueRelationships = {
	.valueForField = @"valueForField",
};

const struct AllowedTypeFieldValueFetchedProperties AllowedTypeFieldValueFetchedProperties = {
};

@implementation AllowedTypeFieldValueID
@end

@implementation _AllowedTypeFieldValue

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AllowedTypeFieldValue" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AllowedTypeFieldValue";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AllowedTypeFieldValue" inManagedObjectContext:moc_];
}

- (AllowedTypeFieldValueID*)objectID {
	return (AllowedTypeFieldValueID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic code;






@dynamic title;






@dynamic valueForField;

	






@end
