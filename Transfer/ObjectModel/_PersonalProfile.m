// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PersonalProfile.m instead.

#import "_PersonalProfile.h"

const struct PersonalProfileAttributes PersonalProfileAttributes = {
	.addressFirstLine = @"addressFirstLine",
	.city = @"city",
	.countryCode = @"countryCode",
	.dateOfBirth = @"dateOfBirth",
	.firstName = @"firstName",
	.lastName = @"lastName",
	.phoneNumber = @"phoneNumber",
	.postCode = @"postCode",
	.readonlyFields = @"readonlyFields",
	.state = @"state",
};

const struct PersonalProfileRelationships PersonalProfileRelationships = {
	.user = @"user",
};

const struct PersonalProfileFetchedProperties PersonalProfileFetchedProperties = {
};

@implementation PersonalProfileID
@end

@implementation _PersonalProfile

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"PersonalProfile" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"PersonalProfile";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"PersonalProfile" inManagedObjectContext:moc_];
}

- (PersonalProfileID*)objectID {
	return (PersonalProfileID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	

	return keyPaths;
}




@dynamic addressFirstLine;






@dynamic city;






@dynamic countryCode;






@dynamic dateOfBirth;






@dynamic firstName;






@dynamic lastName;






@dynamic phoneNumber;






@dynamic postCode;






@dynamic readonlyFields;






@dynamic state;






@dynamic user;

	






@end
