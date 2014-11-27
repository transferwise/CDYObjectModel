// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AchBank.h instead.

#import <CoreData/CoreData.h>

extern const struct AchBankAttributes {
	__unsafe_unretained NSString *id;
	__unsafe_unretained NSString *title;
} AchBankAttributes;

extern const struct AchBankRelationships {
	__unsafe_unretained NSString *fieldGroups;
	__unsafe_unretained NSString *user;
} AchBankRelationships;

@class FieldGroup;
@class User;

@interface AchBankID : NSManagedObjectID {}
@end

@interface _AchBank : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) AchBankID* objectID;

@property (nonatomic, strong) NSNumber* id;

@property (atomic) int32_t idValue;
- (int32_t)idValue;
- (void)setIdValue:(int32_t)value_;

//- (BOOL)validateId:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSOrderedSet *fieldGroups;

- (NSMutableOrderedSet*)fieldGroupsSet;

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

@interface _AchBank (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveId;
- (void)setPrimitiveId:(NSNumber*)value;

- (int32_t)primitiveIdValue;
- (void)setPrimitiveIdValue:(int32_t)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSMutableOrderedSet*)primitiveFieldGroups;
- (void)setPrimitiveFieldGroups:(NSMutableOrderedSet*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end
