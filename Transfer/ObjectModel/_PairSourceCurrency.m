// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PairSourceCurrency.m instead.

#import "_PairSourceCurrency.h"

const struct PairSourceCurrencyAttributes PairSourceCurrencyAttributes = {
};

const struct PairSourceCurrencyRelationships PairSourceCurrencyRelationships = {
};

const struct PairSourceCurrencyFetchedProperties PairSourceCurrencyFetchedProperties = {
};

@implementation PairSourceCurrencyID
@end

@implementation _PairSourceCurrency

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PairSourceCurrency" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PairSourceCurrency";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PairSourceCurrency" inManagedObjectContext:moc_];
}

- (PairSourceCurrencyID*)objectID {
	return (PairSourceCurrencyID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
