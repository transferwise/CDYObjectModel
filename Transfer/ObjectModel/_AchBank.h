// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AchBank.h instead.

#import <CoreData/CoreData.h>

extern const struct AchBankAttributes {
	__unsafe_unretained NSString *fieldType;
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *itemId;
	__unsafe_unretained NSString *title;
} AchBankAttributes;

extern const struct AchBankRelationships {
	__unsafe_unretained NSString *fieldGroups;
	__unsafe_unretained NSString *mfaFields;
	__unsafe_unretained NSString *user;
} AchBankRelationships;

@class FieldGroup;
@class MfaField;
@class User;

@interface AchBankID : NSManagedObjectID {}
@end

@interface _AchBank : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) AchBankID* objectID;

@property (nonatomic, strong) NSString* fieldType;

//- (BOOL)validateFieldType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int32_t idValue;
- (int32_t)idValue;
- (void)setIdValue:(int32_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* itemId;

@property (atomic) int32_t itemIdValue;
- (int32_t)itemIdValue;
- (void)setItemIdValue:(int32_t)value_;

//- (BOOL)validateItemId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *fieldGroups;

- (NSMutableOrderedSet*)fieldGroupsSet;

@property (nonatomic, strong) NSOrderedSet *mfaFields;

- (NSMutableOrderedSet*)mfaFieldsSet;

@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _AchBank (FieldGroupsCoreDataGeneratedAccessors)
- (void)addFieldGroups:(NSOrderedSet*)value_;
- (void)removeFieldGroups:(NSOrderedSet*)value_;
- (void)addFieldGroupsObject:(FieldGroup*)value_;
- (void)removeFieldGroupsObject:(FieldGroup*)value_;

- (void)insertObject:(FieldGroup*)value inFieldGroupsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromFieldGroupsAtIndex:(NSUInteger)idx;
- (void)insertFieldGroups:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeFieldGroupsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInFieldGroupsAtIndex:(NSUInteger)idx withObject:(FieldGroup*)value;
- (void)replaceFieldGroupsAtIndexes:(NSIndexSet *)indexes withFieldGroups:(NSArray *)values;

@end

@interface _AchBank (MfaFieldsCoreDataGeneratedAccessors)
- (void)addMfaFields:(NSOrderedSet*)value_;
- (void)removeMfaFields:(NSOrderedSet*)value_;
- (void)addMfaFieldsObject:(MfaField*)value_;
- (void)removeMfaFieldsObject:(MfaField*)value_;

- (void)insertObject:(MfaField*)value inMfaFieldsAtIndex:(NSUInteger)idx;
- (void)removeObjectFromMfaFieldsAtIndex:(NSUInteger)idx;
- (void)insertMfaFields:(NSArray *)value atIndexes:(NSIndexSet *)indexes;
- (void)removeMfaFieldsAtIndexes:(NSIndexSet *)indexes;
- (void)replaceObjectInMfaFieldsAtIndex:(NSUInteger)idx withObject:(MfaField*)value;
- (void)replaceMfaFieldsAtIndexes:(NSIndexSet *)indexes withMfaFields:(NSArray *)values;

@end

@interface _AchBank (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveFieldType;
- (void)setPrimitiveFieldType:(NSString*)value;

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int32_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int32_t)value_;

- (NSNumber*)primitiveItemId;
- (void)setPrimitiveItemId:(NSNumber*)value;

- (int32_t)primitiveItemIdValue;
- (void)setPrimitiveItemIdValue:(int32_t)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSMutableOrderedSet*)primitiveFieldGroups;
- (void)setPrimitiveFieldGroups:(NSMutableOrderedSet*)value;

- (NSMutableOrderedSet*)primitiveMfaFields;
- (void)setPrimitiveMfaFields:(NSMutableOrderedSet*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end
