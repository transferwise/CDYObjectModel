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
	.occupation = @"occupation",
	.phoneNumber = @"phoneNumber",
	.postCode = @"postCode",
	.readonlyFields = @"readonlyFields",
	.sendAsBusiness = @"sendAsBusiness",
	.state = @"state",
};

const struct PersonalProfileRelationships PersonalProfileRelationships = {
	.user = @"user",
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

	if ([key isEqualToString:@"sendAsBusinessValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sendAsBusiness"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic addressFirstLine;

@dynamic city;

@dynamic countryCode;

@dynamic dateOfBirth;

@dynamic firstName;

@dynamic lastName;

@dynamic occupation;

@dynamic phoneNumber;

@dynamic postCode;

@dynamic readonlyFields;

@dynamic sendAsBusiness;

- (BOOL)sendAsBusinessValue {
	NSNumber *result = [self sendAsBusiness];
	return [result boolValue];
}

- (void)setSendAsBusinessValue:(BOOL)value_ {
	[self setSendAsBusiness:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSendAsBusinessValue {
	NSNumber *result = [self primitiveSendAsBusiness];
	return [result boolValue];
}

- (void)setPrimitiveSendAsBusinessValue:(BOOL)value_ {
	[self setPrimitiveSendAsBusiness:[NSNumber numberWithBool:value_]];
}

@dynamic state;

@dynamic user;

@end

