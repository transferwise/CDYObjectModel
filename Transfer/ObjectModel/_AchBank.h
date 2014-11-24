// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AchBank.h instead.

#import <CoreData/CoreData.h>

extern const struct AchBankAttributes {
	__unsafe_unretained NSString *name;
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

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) FieldGroup *fieldGroups;

//- (BOOL)validateFieldGroups:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _AchBank (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (FieldGroup*)primitiveFieldGroups;
- (void)setPrimitiveFieldGroups:(FieldGroup*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end
