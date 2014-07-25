// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BusinessProfile.m instead.

#import "_BusinessProfile.h"

const struct BusinessProfileAttributes BusinessProfileAttributes = {
	.addressFirstLine = @"addressFirstLine",
	.businessDescription = @"businessDescription",
	.city = @"city",
	.countryCode = @"countryCode",
	.name = @"name",
	.postCode = @"postCode",
	.readonlyFields = @"readonlyFields",
	.registrationNumber = @"registrationNumber",
	.state = @"state",
};

const struct BusinessProfileRelationships BusinessProfileRelationships = {
	.user = @"user",
};

const struct BusinessProfileFetchedProperties BusinessProfileFetchedProperties = {
};

@implementation BusinessProfileID
@end

@implementation _BusinessProfile

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"BusinessProfile" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"BusinessProfile";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"BusinessProfile" inManagedObjectContext:moc_];
}

- (BusinessProfileID*)objectID {
	return (BusinessProfileID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic addressFirstLine;






@dynamic businessDescription;






@dynamic city;






@dynamic countryCode;






@dynamic name;






@dynamic postCode;






@dynamic readonlyFields;






@dynamic registrationNumber;






@dynamic state;






@dynamic user;

	






@end
