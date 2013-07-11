// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipientTypeField.h instead.

#import <CoreData/CoreData.h>


extern const struct RecipientTypeFieldAttributes {
	__unsafe_unretained NSString *name;
} RecipientTypeFieldAttributes;

extern const struct RecipientTypeFieldRelationships {
	__unsafe_unretained NSString *fieldForType;
	__unsafe_unretained NSString *values;
} RecipientTypeFieldRelationships;

extern const struct RecipientTypeFieldFetchedProperties {
} RecipientTypeFieldFetchedProperties;

@class RecipientType;
@class TypeFieldValue;



@interface RecipientTypeFieldID : NSManagedObjectID {}
@end

@interface _RecipientTypeField : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RecipientTypeFieldID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) RecipientType *fieldForType;

//- (BOOL)validateFieldForType:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *values;

- (NSMutableSet*)valuesSet;





@end

@interface _RecipientTypeField (CoreDataGeneratedAccessors)

- (void)addValues:(NSSet*)value_;
- (void)removeValues:(NSSet*)value_;
- (void)addValuesObject:(TypeFieldValue*)value_;
- (void)removeValuesObject:(TypeFieldValue*)value_;

@end

@interface _RecipientTypeField (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;





- (RecipientType*)primitiveFieldForType;
- (void)setPrimitiveFieldForType:(RecipientType*)value;



- (NSMutableSet*)primitiveValues;
- (void)setPrimitiveValues:(NSMutableSet*)value;


@end
