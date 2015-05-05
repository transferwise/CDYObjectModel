// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AdditionalAttribute.m instead.

#import "_AdditionalAttribute.h"

const struct AdditionalAttributeAttributes AdditionalAttributeAttributes = {
	.attributeType = @"attributeType",
	.code = @"code",
	.title = @"title",
};

@implementation AdditionalAttributeID
@end

@implementation _AdditionalAttribute

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"AdditionalAttribute" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"AdditionalAttribute";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"AdditionalAttribute" inManagedObjectContext:moc_];
}

- (AdditionalAttributeID*)objectID {
	return (AdditionalAttributeID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];

	if ([key isEqualToString:@"attributeTypeValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"attributeType"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}

@dynamic attributeType;

- (int16_t)attributeTypeValue {
	NSNumber *result = [self attributeType];
	return [result shortValue];
}

- (void)setAttributeTypeValue:(int16_t)value_ {
	[self setAttributeType:[NSNumber numberWithShort:value_]];
}

- (int16_t)primitiveAttributeTypeValue {
	NSNumber *result = [self primitiveAttributeType];
	return [result shortValue];
}

- (void)setPrimitiveAttributeTypeValue:(int16_t)value_ {
	[self setPrimitiveAttributeType:[NSNumber numberWithShort:value_]];
}

@dynamic code;

@dynamic title;

@end

