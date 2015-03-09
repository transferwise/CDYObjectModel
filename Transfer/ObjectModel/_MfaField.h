// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to MfaField.h instead.

#import <CoreData/CoreData.h>

extern const struct MfaFieldAttributes {
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *value;
} MfaFieldAttributes;

extern const struct MfaFieldRelationships {
	__unsafe_unretained NSString *achBank;
} MfaFieldRelationships;

@class AchBank;

@interface MfaFieldID : NSManagedObjectID {}
@end

@interface _MfaField : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) MfaFieldID* objectID;

@property (nonatomic, strong) NSString* key;

//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* value;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) AchBank *achBank;

//- (BOOL)validateAchBank:(id*)value_ error:(NSError**)error_;

@end

@interface _MfaField (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;

- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;

- (AchBank*)primitiveAchBank;
- (void)setPrimitiveAchBank:(AchBank*)value;

@end
