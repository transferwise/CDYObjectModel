// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ReferralLinks.m instead.

#import "_ReferralLinks.h"

const struct ReferralLinksAttributes ReferralLinksAttributes = {
	.channel = @"channel",
	.url = @"url",
};

const struct ReferralLinksRelationships ReferralLinksRelationships = {
	.user = @"user",
};

@implementation ReferralLinksID
@end

@implementation _ReferralLinks

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"ReferralLinks" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"ReferralLinks";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"ReferralLinks" inManagedObjectContext:moc_];
}

- (ReferralLinksID*)objectID {
	return (ReferralLinksID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	return keyPaths;
}

@dynamic channel;

@dynamic url;

@dynamic user;

@end

