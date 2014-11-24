// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to FieldGroup.h instead.

#import <CoreData/CoreData.h>

extern const struct FieldGroupAttributes {
	__unsafe_unretained NSString *title;
} FieldGroupAttributes;

extern const struct FieldGroupRelationships {
	__unsafe_unretained NSString *achBank;
	__unsafe_unretained NSString *fields;
} FieldGroupRelationships;

@class AchBank;
@class RecipientTypeField;

@interface FieldGroupID : NSManagedObjectID {}
@end

@interface _FieldGroup : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) FieldGroupID* objectID;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) AchBank *achBank;

//- (BOOL)validateAchBank:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *fields;

- (NSMutableOrderedSet*)fieldsSet;

@end

@interface _FieldGroup (FieldsCoreDataGeneratedAccessors)
- (void)addFields:(NSOrderedSet*)value_;
- (void)removeFields:(NSOrderedSet*)value_;
- (void)addFieldsObject:(RecipientTypeField*)value_;
- (void)removeFieldsObject:(RecipientTypeField*)value_;

- (void)insertObject:(RecipientTypeField*)value inFieldsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFieldsAtIndex:(NSUInteger)idx;
- (void)insertFields:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFieldsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFieldsAtIndex:(NSUInteger)idx withObject:(RecipientTypeField*)value;
- (void)replaceFieldsAtIndexes:(NSIndexSet *)indexes withFields:(NSArray *)values;

@end

@interface _FieldGroup (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (AchBank*)primitiveAchBank;
- (void)setPrimitiveAchBank:(AchBank*)value;

- (NSMutableOrderedSet*)primitiveFields;
- (void)setPrimitiveFields:(NSMutableOrderedSet*)value;

@end
