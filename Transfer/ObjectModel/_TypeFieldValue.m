// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TypeFieldValue.m instead.

#import "_TypeFieldValue.h"

const struct TypeFieldValueAttributes TypeFieldValueAttributes = {
	.value = @"value",
};

const struct TypeFieldValueRelationships TypeFieldValueRelationships = {
	.fieldGroup = @"fieldGroup",
	.recipient = @"recipient",
	.valueForField = @"valueForField",
};

@implementation TypeFieldValueID
@end

@implementation _TypeFieldValue

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"TypeFieldValue" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"TypeFieldValue";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"TypeFieldValue" inManagedObjectContext:moc_];
}

- (TypeFieldValueID*)objectID {
	return (TypeFieldValueID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic value;

@dynamic fieldGroup;

@dynamic recipient;

@dynamic valueForField;

@end

