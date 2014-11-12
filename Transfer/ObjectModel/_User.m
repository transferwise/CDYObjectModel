// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.m instead.

#import "_User.h"

const struct UserAttributes UserAttributes = {
	.anonymous = @"anonymous",
	.email = @"email",
	.invitationReward = @"invitationReward",
	.invitationRewardCurrency = @"invitationRewardCurrency",
	.pReference = @"pReference",
	.password = @"password",
	.sendAsBusinessDefaultSetting = @"sendAsBusinessDefaultSetting",
	.successfulInviteCount = @"successfulInviteCount",
};

const struct UserRelationships UserRelationships = {
	.businessProfile = @"businessProfile",
	.contacts = @"contacts",
	.payments = @"payments",
	.personalProfile = @"personalProfile",
	.referralLinks = @"referralLinks",
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
	if ([key isEqualToString:@"invitationRewardValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"invitationReward"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"sendAsBusinessDefaultSettingValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"sendAsBusinessDefaultSetting"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"successfulInviteCountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"successfulInviteCount"];
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

@dynamic invitationReward;

- (int16_t)invitationRewardValue {
	NSNumber *result = [self invitationReward];
	return [result shortValue];
}

- (void)setInvitationRewardValue:(int16_t)value_ {
	[self setInvitationReward:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveInvitationRewardValue {
	NSNumber *result = [self primitiveInvitationReward];
	return [result shortValue];
}

- (void)setPrimitiveInvitationRewardValue:(int16_t)value_ {
	[self setPrimitiveInvitationReward:[NSNumber numberWithShort:value_]];
}

@dynamic invitationRewardCurrency;

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

@dynamic successfulInviteCount;

- (int16_t)successfulInviteCountValue {
	NSNumber *result = [self successfulInviteCount];
	return [result shortValue];
}

- (void)setSuccessfulInviteCountValue:(int16_t)value_ {
	[self setSuccessfulInviteCount:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveSuccessfulInviteCountValue {
	NSNumber *result = [self primitiveSuccessfulInviteCount];
	return [result shortValue];
}

- (void)setPrimitiveSuccessfulInviteCountValue:(int16_t)value_ {
	[self setPrimitiveSuccessfulInviteCount:[NSNumber numberWithShort:value_]];
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

@dynamic referralLinks;

@end

