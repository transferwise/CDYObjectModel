// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CurrencyPair.m instead.

#import "_CurrencyPair.h"

const struct CurrencyPairAttributes CurrencyPairAttributes = {
	.source = @"source",
	.target = @"target",
};

const struct CurrencyPairRelationships CurrencyPairRelationships = {
};

const struct CurrencyPairFetchedProperties CurrencyPairFetchedProperties = {
};

@implementation CurrencyPairID
@end

@implementation _CurrencyPair

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"CurrencyPair" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"CurrencyPair";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"CurrencyPair" inManagedObjectContext:moc_];
}

- (CurrencyPairID*)objectID {
	return (CurrencyPairID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic source;






@dynamic target;











@end
