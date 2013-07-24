// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PendingPayment.h instead.

#import <CoreData/CoreData.h>
#import "Payment.h"

extern const struct PendingPaymentAttributes {
	__unsafe_unretained NSString *payOut;
	__unsafe_unretained NSString *profileUsed;
	__unsafe_unretained NSString *rate;
} PendingPaymentAttributes;

extern const struct PendingPaymentRelationships {
} PendingPaymentRelationships;

extern const struct PendingPaymentFetchedProperties {
} PendingPaymentFetchedProperties;






@interface PendingPaymentID : NSManagedObjectID {}
@end

@interface _PendingPayment : Payment {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PendingPaymentID*)objectID;





@property (nonatomic, strong) NSDecimalNumber* payOut;



//- (BOOL)validatePayOut:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* profileUsed;



//- (BOOL)validateProfileUsed:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* rate;



@property double rateValue;
- (double)rateValue;
- (void)setRateValue:(double)value_;

//- (BOOL)validateRate:(id*)value_ error:(NSError**)error_;






@end

@interface _PendingPayment (CoreDataGeneratedAccessors)

@end

@interface _PendingPayment (CoreDataGeneratedPrimitiveAccessors)


- (NSDecimalNumber*)primitivePayOut;
- (void)setPrimitivePayOut:(NSDecimalNumber*)value;




- (NSString*)primitiveProfileUsed;
- (void)setPrimitiveProfileUsed:(NSString*)value;




- (NSNumber*)primitiveRate;
- (void)setPrimitiveRate:(NSNumber*)value;

- (double)primitiveRateValue;
- (void)setPrimitiveRateValue:(double)value_;




@end
