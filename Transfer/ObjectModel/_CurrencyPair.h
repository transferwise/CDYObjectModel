// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to CurrencyPair.h instead.

#import <CoreData/CoreData.h>


extern const struct CurrencyPairAttributes {
	__unsafe_unretained NSString *source;
	__unsafe_unretained NSString *target;
} CurrencyPairAttributes;

extern const struct CurrencyPairRelationships {
} CurrencyPairRelationships;

extern const struct CurrencyPairFetchedProperties {
} CurrencyPairFetchedProperties;





@interface CurrencyPairID : NSManagedObjectID {}
@end

@interface _CurrencyPair : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (CurrencyPairID*)objectID;





@property (nonatomic, strong) NSString* source;



//- (BOOL)validateSource:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* target;



//- (BOOL)validateTarget:(id*)value_ error:(NSError**)error_;






@end

@interface _CurrencyPair (CoreDataGeneratedAccessors)

@end

@interface _CurrencyPair (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveSource;
- (void)setPrimitiveSource:(NSString*)value;




- (NSString*)primitiveTarget;
- (void)setPrimitiveTarget:(NSString*)value;




@end
