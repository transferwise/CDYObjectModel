// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AllowedTypeFieldValue.m instead.

#import "_AllowedTypeFieldValue.h"

const struct AllowedTypeFieldValueAttributes AllowedTypeFieldValueAttributes = {
	.code = @"code",
	.sortOrder = @"sortOrder",
	.title = @"title",
};

const struct AllowedTypeFieldValueRelationships AllowedTypeFieldValueRelationships = {
	.valueForField = @"valueForField",
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

	if ([key isEqualToString:@"sortOrderValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sortOrder"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic code;

@dynamic sortOrder;

- (int16_t)sortOrderValue {
	NSNumber *result = [self sortOrder];
	return [result shortValue];
}

- (void)setSortOrderValue:(int16_t)value_ {
	[self setSortOrder:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSortOrderValue {
	NSNumber *result = [self primitiveSortOrder];
	return [result shortValue];
}

- (void)setPrimitiveSortOrderValue:(int16_t)value_ {
	[self setPrimitiveSortOrder:[NSNumber numberWithShort:value_]];
}

@dynamic title;

@dynamic valueForField;

@end

