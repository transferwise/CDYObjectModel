// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Payment.m instead.

#import "_Payment.h"

const struct PaymentAttributes PaymentAttributes = {
	.cancelledDate = @"cancelledDate",
	.estimatedDelivery = @"estimatedDelivery",
	.hidden = @"hidden",
	.lastUpdateTime = @"lastUpdateTime",
	.payIn = @"payIn",
	.paymentStatus = @"paymentStatus",
	.receivedDate = @"receivedDate",
	.remoteId = @"remoteId",
	.submittedDate = @"submittedDate",
	.transferredDate = @"transferredDate",
};

const struct PaymentRelationships PaymentRelationships = {
	.recipient = @"recipient",
	.settlementRecipient = @"settlementRecipient",
	.sourceCurrency = @"sourceCurrency",
	.targetCurrency = @"targetCurrency",
	.user = @"user",
};

const struct PaymentFetchedProperties PaymentFetchedProperties = {
};

@implementation PaymentID
@end

@implementation _Payment

+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription insertNewObjectForEntityForName:@"Payment" inManagedObjectContext:moc_];
}

+ (NSString*)entityName {
	return @"Payment";
}

+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_ {
	NSParameterAssert(moc_);
	return [NSEntityDescription entityForName:@"Payment" inManagedObjectContext:moc_];
}

- (PaymentID*)objectID {
	return (PaymentID*)[super objectID];
}

+ (NSSet*)keyPathsForValuesAffectingValueForKey:(NSString*)key {
	NSSet *keyPaths = [super keyPathsForValuesAffectingValueForKey:key];
	
	if ([key isEqualToString:@"hiddenValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"hidden"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"remoteIdValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"remoteId"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}

	return keyPaths;
}




@dynamic cancelledDate;






@dynamic estimatedDelivery;






@dynamic hidden;



- (BOOL)hiddenValue {
	NSNumber *result = [self hidden];
	return [result boolValue];
}

- (void)setHiddenValue:(BOOL)value_ {
	[self setHidden:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveHiddenValue {
	NSNumber *result = [self primitiveHidden];
	return [result boolValue];
}

- (void)setPrimitiveHiddenValue:(BOOL)value_ {
	[self setPrimitiveHidden:[NSNumber numberWithBool:value_]];
}





@dynamic lastUpdateTime;






@dynamic payIn;






@dynamic paymentStatus;






@dynamic receivedDate;






@dynamic remoteId;



- (int32_t)remoteIdValue {
	NSNumber *result = [self remoteId];
	return [result intValue];
}

- (void)setRemoteIdValue:(int32_t)value_ {
	[self setRemoteId:[NSNumber numberWithInt:value_]];
}

- (int32_t)primitiveRemoteIdValue {
	NSNumber *result = [self primitiveRemoteId];
	return [result intValue];
}

- (void)setPrimitiveRemoteIdValue:(int32_t)value_ {
	[self setPrimitiveRemoteId:[NSNumber numberWithInt:value_]];
}





@dynamic submittedDate;






@dynamic transferredDate;






@dynamic recipient;

	

@dynamic settlementRecipient;

	

@dynamic sourceCurrency;

	

@dynamic targetCurrency;

	

@dynamic user;

	






@end
