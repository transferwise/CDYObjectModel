// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MfaField.m instead.

#import "_MfaField.h"

const struct MfaFieldAttributes MfaFieldAttributes = {
	.key = @"key",
	.value = @"value",
};

const struct MfaFieldRelationships MfaFieldRelationships = {
	.achBank = @"achBank",
};

@implementation MfaFieldID
@end

@implementation _MfaField

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"MfaField" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"MfaField";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"MfaField" inManagedObjectContext:moc_];
}

- (MfaFieldID*)objectID {
	return (MfaFieldID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic key;

@dynamic value;

@dynamic achBank;

@end

