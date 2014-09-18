// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AllowedTypeFieldValue.h instead.

#import <CoreData/CoreData.h>


extern const struct AllowedTypeFieldValueAttributes {
	__unsafe_unretained NSString *code;
	__unsafe_unretained NSString *title;
} AllowedTypeFieldValueAttributes;

extern const struct AllowedTypeFieldValueRelationships {
	__unsafe_unretained NSString *valueForField;
} AllowedTypeFieldValueRelationships;

extern const struct AllowedTypeFieldValueFetchedProperties {
} AllowedTypeFieldValueFetchedProperties;

@class RecipientTypeField;




@interface AllowedTypeFieldValueID : NSManagedObjectID {}
@end

@interface _AllowedTypeFieldValue : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (AllowedTypeFieldValueID*)objectID;





@property (nonatomic, strong) NSString* code;



//- (BOOL)validateCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* title;



//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) RecipientTypeField *valueForField;

//- (BOOL)validateValueForField:(id*)value_ error:(NSError**)error_;





@end

@interface _AllowedTypeFieldValue (CoreDataGeneratedAccessors)

@end

@interface _AllowedTypeFieldValue (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveCode;
- (void)setPrimitiveCode:(NSString*)value;




- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;





- (RecipientTypeField*)primitiveValueForField;
- (void)setPrimitiveValueForField:(RecipientTypeField*)value;


@end
