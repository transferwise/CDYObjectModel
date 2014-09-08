// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Payment.m instead.

#import "_Payment.h"

const struct PaymentAttributes PaymentAttributes = {
	.cancelledDate = @"cancelledDate",
	.conversionRate = @"conversionRate",
	.estimatedDelivery = @"estimatedDelivery",
	.estimatedDeliveryStringFromServer = @"estimatedDeliveryStringFromServer",
	.isFixedAmount = @"isFixedAmount",
	.lastUpdateTime = @"lastUpdateTime",
	.payIn = @"payIn",
	.payOut = @"payOut",
	.paymentStatus = @"paymentStatus",
	.presentable = @"presentable",
	.profileUsed = @"profileUsed",
	.receivedDate = @"receivedDate",
	.remoteId = @"remoteId",
	.submittedDate = @"submittedDate",
	.transferredDate = @"transferredDate",
};

const struct PaymentRelationships PaymentRelationships = {
	.payInMethods = @"payInMethods",
	.paymentMadeIndicator = @"paymentMadeIndicator",
	.recipient = @"recipient",
	.refundRecipient = @"refundRecipient",
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
	
	if ([key isEqualToString:@"conversionRateValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"conversionRate"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"isFixedAmountValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"isFixedAmount"];
		keyPaths = [keyPaths setByAddingObjectsFromSet:affectingKey];
		return keyPaths;
	}
	if ([key isEqualToString:@"presentableValue"]) {
		NSSet *affectingKey = [NSSet setWithObject:@"presentable"];
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






@dynamic conversionRate;



- (double)conversionRateValue {
	NSNumber *result = [self conversionRate];
	return [result doubleValue];
}

- (void)setConversionRateValue:(double)value_ {
	[self setConversionRate:[NSNumber numberWithDouble:value_]];
}

- (double)primitiveConversionRateValue {
	NSNumber *result = [self primitiveConversionRate];
	return [result doubleValue];
}

- (void)setPrimitiveConversionRateValue:(double)value_ {
	[self setPrimitiveConversionRate:[NSNumber numberWithDouble:value_]];
}





@dynamic estimatedDelivery;






@dynamic estimatedDeliveryStringFromServer;






@dynamic isFixedAmount;



- (BOOL)isFixedAmountValue {
	NSNumber *result = [self isFixedAmount];
	return [result boolValue];
}

- (void)setIsFixedAmountValue:(BOOL)value_ {
	[self setIsFixedAmount:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitiveIsFixedAmountValue {
	NSNumber *result = [self primitiveIsFixedAmount];
	return [result boolValue];
}

- (void)setPrimitiveIsFixedAmountValue:(BOOL)value_ {
	[self setPrimitiveIsFixedAmount:[NSNumber numberWithBool:value_]];
}





@dynamic lastUpdateTime;






@dynamic payIn;






@dynamic payOut;






@dynamic paymentStatus;






@dynamic presentable;



- (BOOL)presentableValue {
	NSNumber *result = [self presentable];
	return [result boolValue];
}

- (void)setPresentableValue:(BOOL)value_ {
	[self setPresentable:[NSNumber numberWithBool:value_]];
}

- (BOOL)primitivePresentableValue {
	NSNumber *result = [self primitivePresentable];
	return [result boolValue];
}

- (void)setPrimitivePresentableValue:(BOOL)value_ {
	[self setPrimitivePresentable:[NSNumber numberWithBool:value_]];
}





@dynamic profileUsed;






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






@dynamic payInMethods;

	
- (NSMutableOrderedSet*)payInMethodsSet {
	[self willAccessValueForKey:@"payInMethods"];
  
	NSMutableOrderedSet *result = (NSMutableOrderedSet*)[self mutableOrderedSetValueForKey:@"payInMethods"];
  
	[self didAccessValueForKey:@"payInMethods"];
	return result;
}
	

@dynamic paymentMadeIndicator;

	

@dynamic recipient;

	

@dynamic refundRecipient;

	

@dynamic sourceCurrency;

	

@dynamic targetCurrency;

	

@dynamic user;

	






@end
