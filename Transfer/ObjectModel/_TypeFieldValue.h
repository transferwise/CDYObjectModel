// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to TypeFieldValue.h instead.

#import <CoreData/CoreData.h>

extern const struct TypeFieldValueAttributes {
	__unsafe_unretained NSString *value;
} TypeFieldValueAttributes;

extern const struct TypeFieldValueRelationships {
	__unsafe_unretained NSString *fieldGroup;
	__unsafe_unretained NSString *recipient;
	__unsafe_unretained NSString *valueForField;
} TypeFieldValueRelationships;

@class FieldGroup;
@class Recipient;
@class RecipientTypeField;

@interface TypeFieldValueID : NSManagedObjectID {}
@end

@interface _TypeFieldValue : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) TypeFieldValueID* objectID;

@property (nonatomic, strong) NSString* value;

//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) FieldGroup *fieldGroup;

//- (BOOL)validateFieldGroup:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) Recipient *recipient;

//- (BOOL)validateRecipient:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RecipientTypeField *valueForField;

//- (BOOL)validateValueForField:(id*)value_ error:(NSError**)error_;

@end

@interface _TypeFieldValue (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;

- (FieldGroup*)primitiveFieldGroup;
- (void)setPrimitiveFieldGroup:(FieldGroup*)value;

- (Recipient*)primitiveRecipient;
- (void)setPrimitiveRecipient:(Recipient*)value;

- (RecipientTypeField*)primitiveValueForField;
- (void)setPrimitiveValueForField:(RecipientTypeField*)value;

@end
