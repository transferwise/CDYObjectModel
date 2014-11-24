// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FieldGroup.h instead.

#import <CoreData/CoreData.h>

extern const struct FieldGroupAttributes {
	__unsafe_unretained NSString *name;
} FieldGroupAttributes;

extern const struct FieldGroupRelationships {
	__unsafe_unretained NSString *achBank;
	__unsafe_unretained NSString *typeFieldValues;
} FieldGroupRelationships;

@class AchBank;
@class TypeFieldValue;

@interface FieldGroupID : NSManagedObjectID {}
@end

@interface _FieldGroup : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FieldGroupID* objectID;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) AchBank *achBank;

//- (BOOL)validateAchBank:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) TypeFieldValue *typeFieldValues;

//- (BOOL)validateTypeFieldValues:(id*)value_ error:(NSError**)error_;

@end

@interface _FieldGroup (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (AchBank*)primitiveAchBank;
- (void)setPrimitiveAchBank:(AchBank*)value;

- (TypeFieldValue*)primitiveTypeFieldValues;
- (void)setPrimitiveTypeFieldValues:(TypeFieldValue*)value;

@end
