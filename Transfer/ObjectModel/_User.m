// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.m instead.

#import "_User.h"

const struct UserAttributes UserAttributes = {
	.anonymous = @"anonymous",
	.email = @"email",
	.pReference = @"pReference",
	.password = @"password",
	.sendAsBusinessDefaultSetting = @"sendAsBusinessDefaultSetting",
};

const struct UserRelationships UserRelationships = {
	.businessProfile = @"businessProfile",
	.contacts = @"contacts",
	.payments = @"payments",
	.personalProfile = @"personalProfile",
};

const struct UserFetchedProperties UserFetchedProperties = {
};

@implementation UserID
@end

@implementation _User

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"User" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"User";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"User" inManagedObjectContext:moc_];
}

- (UserID*)objectID {
	return (UserID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"anonymousValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"anonymous"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sendAsBusinessDefaultSettingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sendAsBusinessDefaultSetting"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic anonymous;



- (BOOL)anonymousValue {
	NSNumber *result = [self anonymous];
	return [result boolValue];
}

- (void)setAnonymousValue:(BOOL)value_ {
	[self setAnonymous:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveAnonymousValue {
	NSNumber *result = [self primitiveAnonymous];
	return [result boolValue];
}

- (void)setPrimitiveAnonymousValue:(BOOL)value_ {
	[self setPrimitiveAnonymous:[NSNumber numberWithBool:value_]];
}





@dynamic email;






@dynamic pReference;






@dynamic password;






@dynamic sendAsBusinessDefaultSetting;



- (BOOL)sendAsBusinessDefaultSettingValue {
	NSNumber *result = [self sendAsBusinessDefaultSetting];
	return [result boolValue];
}

- (void)setSendAsBusinessDefaultSettingValue:(BOOL)value_ {
	[self setSendAsBusinessDefaultSetting:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveSendAsBusinessDefaultSettingValue {
	NSNumber *result = [self primitiveSendAsBusinessDefaultSetting];
	return [result boolValue];
}

- (void)setPrimitiveSendAsBusinessDefaultSettingValue:(BOOL)value_ {
	[self setPrimitiveSendAsBusinessDefaultSetting:[NSNumber numberWithBool:value_]];
}





@dynamic businessProfile;

	

@dynamic contacts;

	
- (NSMutableSet*)contactsSet {
	[self willAccessValueForKey:@"contacts"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"contacts"];
  
	[self didAccessValueForKey:@"contacts"];
	return result;
}
	

@dynamic payments;

	
- (NSMutableSet*)paymentsSet {
	[self willAccessValueForKey:@"payments"];
  
	NSMutableSet *result = (NSMutableSet*)[self mutableSetValueForKey:@"payments"];
  
	[self didAccessValueForKey:@"payments"];
	return result;
}
	

@dynamic personalProfile;

	






@end
