// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AchBank.m instead.

#import "_AchBank.h"

const struct AchBankAttributes AchBankAttributes = {
	.name = @"name",
};

const struct AchBankRelationships AchBankRelationships = {
	.fieldGroups = @"fieldGroups",
	.user = @"user",
};

@implementation AchBankID
@end

@implementation _AchBank

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AchBank" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AchBank";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AchBank" inManagedObjectContext:moc_];
}

- (AchBankID*)objectID {
	return (AchBankID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic name;

@dynamic fieldGroups;

@dynamic user;

@end

