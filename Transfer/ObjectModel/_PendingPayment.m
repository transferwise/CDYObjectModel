// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PendingPayment.m instead.

#import "_PendingPayment.h"

const struct PendingPaymentAttributes PendingPaymentAttributes = {
};

const struct PendingPaymentRelationships PendingPaymentRelationships = {
};

const struct PendingPaymentFetchedProperties PendingPaymentFetchedProperties = {
};

@implementation PendingPaymentID
@end

@implementation _PendingPayment

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PendingPayment" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PendingPayment";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PendingPayment" inManagedObjectContext:moc_];
}

- (PendingPaymentID*)objectID {
	return (PendingPaymentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}









@end
