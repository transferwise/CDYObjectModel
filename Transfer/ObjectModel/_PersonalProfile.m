// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PersonalProfile.m instead.

#import "_PersonalProfile.h"

const struct PersonalProfileAttributes PersonalProfileAttributes = {
	.addressFirstLine = @"addressFirstLine",
	.changed = @"changed",
	.city = @"city",
	.countryCode = @"countryCode",
	.dateOfBirth = @"dateOfBirth",
	.firstName = @"firstName",
	.lastName = @"lastName",
	.phoneNumber = @"phoneNumber",
	.postCode = @"postCode",
	.readonlyFields = @"readonlyFields",
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
	
	if ([key isEqualToString:@"changedValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"changed"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic addressFirstLine;






@dynamic changed;



- (BOOL)changedValue {
	NSNumber *result = [self changed];
	return [result boolValue];
}

- (void)setChangedValue:(BOOL)value_ {
	[self setChanged:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveChangedValue {
	NSNumber *result = [self primitiveChanged];
	return [result boolValue];
}

- (void)setPrimitiveChangedValue:(BOOL)value_ {
	[self setPrimitiveChanged:[NSNumber numberWithBool:value_]];
}





@dynamic city;






@dynamic countryCode;






@dynamic dateOfBirth;






@dynamic firstName;






@dynamic lastName;






@dynamic phoneNumber;






@dynamic postCode;






@dynamic readonlyFields;






@dynamic user;

	






@end
