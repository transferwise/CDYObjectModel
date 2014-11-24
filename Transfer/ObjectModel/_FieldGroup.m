// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FieldGroup.m instead.

#import "_FieldGroup.h"

const struct FieldGroupAttributes FieldGroupAttributes = {
	.name = @"name",
};

const struct FieldGroupRelationships FieldGroupRelationships = {
	.achBank = @"achBank",
	.typeFieldValues = @"typeFieldValues",
};

@implementation FieldGroupID
@end

@implementation _FieldGroup

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"FieldGroup" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"FieldGroup";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"FieldGroup" inManagedObjectContext:moc_];
}

- (FieldGroupID*)objectID {
	return (FieldGroupID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic name;

@dynamic achBank;

@dynamic typeFieldValues;

@end

