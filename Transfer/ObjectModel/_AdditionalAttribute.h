// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to AdditionalAttribute.h instead.

#import <CoreData/CoreData.h>

extern const struct AdditionalAttributeAttributes {
	__unsafe_unretained NSString *attributeType;
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *value;
} AdditionalAttributeAttributes;

@interface AdditionalAttributeID : NSManagedObjectID {}
@end

@interface _AdditionalAttribute : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) AdditionalAttributeID* objectID;

@property (nonatomic, strong) NSNumber* attributeType;

@property (atomic) int16_t attributeTypeValue;
- (int16_t)attributeTypeValue;
- (void)setAttributeTypeValue:(int16_t)value_;

//- (BOOL)validateAttributeType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* key;

//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* value;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;

@end

@interface _AdditionalAttribute (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveAttributeType;
- (void)setPrimitiveAttributeType:(NSNumber*)value;

- (int16_t)primitiveAttributeTypeValue;
- (void)setPrimitiveAttributeTypeValue:(int16_t)value_;

- (NSString*)primitiveKey;
- (void)setPrimitiveKey:(NSString*)value;

- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;

@end
