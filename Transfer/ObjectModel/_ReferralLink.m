// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ReferralLink.m instead.

#import "_ReferralLink.h"

const struct ReferralLinkAttributes ReferralLinkAttributes = {
	.channel = @"channel",
	.url = @"url",
};

const struct ReferralLinkRelationships ReferralLinkRelationships = {
	.user = @"user",
};

@implementation ReferralLinkID
@end

@implementation _ReferralLink

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ReferralLink" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ReferralLink";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ReferralLink" inManagedObjectContext:moc_];
}

- (ReferralLinkID*)objectID {
	return (ReferralLinkID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"channelValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"channel"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic channel;

- (int16_t)channelValue {
	NSNumber *result = [self channel];
	return [result shortValue];
}

- (void)setChannelValue:(int16_t)value_ {
	[self setChannel:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveChannelValue {
	NSNumber *result = [self primitiveChannel];
	return [result shortValue];
}

- (void)setPrimitiveChannelValue:(int16_t)value_ {
	[self setPrimitiveChannel:[NSNumber numberWithShort:value_]];
}

@dynamic url;

@dynamic user;

@end

