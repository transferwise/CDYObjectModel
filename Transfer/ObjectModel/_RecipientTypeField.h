// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipientTypeField.h instead.

#import <CoreData/CoreData.h>

extern const struct RecipientTypeFieldAttributes {
	__unsafe_unretained NSString *example;
	__unsafe_unretained NSString *maxLength;
	__unsafe_unretained NSString *minLength;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *presentationPattern;
	__unsafe_unretained NSString *required;
	__unsafe_unretained NSString *title;
	__unsafe_unretained NSString *type;
	__unsafe_unretained NSString *validationRegexp;
} RecipientTypeFieldAttributes;

extern const struct RecipientTypeFieldRelationships {
	__unsafe_unretained NSString *allowedValues;
	__unsafe_unretained NSString *fieldForGroup;
	__unsafe_unretained NSString *fieldForType;
	__unsafe_unretained NSString *values;
} RecipientTypeFieldRelationships;

@class AllowedTypeFieldValue;
@class FieldGroup;
@class RecipientType;
@class TypeFieldValue;

@interface RecipientTypeFieldID : NSManagedObjectID {}
@end

@interface _RecipientTypeField : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) RecipientTypeFieldID* objectID;

@property (nonatomic, strong) NSString* example;

//- (BOOL)validateExample:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* maxLength;

@property (atomic) int16_t maxLengthValue;
- (int16_t)maxLengthValue;
- (void)setMaxLengthValue:(int16_t)value_;

//- (BOOL)validateMaxLength:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* minLength;

@property (atomic) int16_t minLengthValue;
- (int16_t)minLengthValue;
- (void)setMinLengthValue:(int16_t)value_;

//- (BOOL)validateMinLength:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* presentationPattern;

//- (BOOL)validatePresentationPattern:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* required;

@property (atomic) BOOL requiredValue;
- (BOOL)requiredValue;
- (void)setRequiredValue:(BOOL)value_;

//- (BOOL)validateRequired:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* title;

//- (BOOL)validateTitle:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* type;

//- (BOOL)validateType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* validationRegexp;

//- (BOOL)validateValidationRegexp:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *allowedValues;

- (NSMutableSet*)allowedValuesSet;

@property (nonatomic, strong) FieldGroup *fieldForGroup;

//- (BOOL)validateFieldForGroup:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) RecipientType *fieldForType;

//- (BOOL)validateFieldForType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *values;

- (NSMutableSet*)valuesSet;

@end

@interface _RecipientTypeField (AllowedValuesCoreDataGeneratedAccessors)
- (void)addAllowedValues:(NSSet*)value_;
- (void)removeAllowedValues:(NSSet*)value_;
- (void)addAllowedValuesObject:(AllowedTypeFieldValue*)value_;
- (void)removeAllowedValuesObject:(AllowedTypeFieldValue*)value_;

@end

@interface _RecipientTypeField (ValuesCoreDataGeneratedAccessors)
- (void)addValues:(NSSet*)value_;
- (void)removeValues:(NSSet*)value_;
- (void)addValuesObject:(TypeFieldValue*)value_;
- (void)removeValuesObject:(TypeFieldValue*)value_;

@end

@interface _RecipientTypeField (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveExample;
- (void)setPrimitiveExample:(NSString*)value;

- (NSNumber*)primitiveMaxLength;
- (void)setPrimitiveMaxLength:(NSNumber*)value;

- (int16_t)primitiveMaxLengthValue;
- (void)setPrimitiveMaxLengthValue:(int16_t)value_;

- (NSNumber*)primitiveMinLength;
- (void)setPrimitiveMinLength:(NSNumber*)value;

- (int16_t)primitiveMinLengthValue;
- (void)setPrimitiveMinLengthValue:(int16_t)value_;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitivePresentationPattern;
- (void)setPrimitivePresentationPattern:(NSString*)value;

- (NSNumber*)primitiveRequired;
- (void)setPrimitiveRequired:(NSNumber*)value;

- (BOOL)primitiveRequiredValue;
- (void)setPrimitiveRequiredValue:(BOOL)value_;

- (NSString*)primitiveTitle;
- (void)setPrimitiveTitle:(NSString*)value;

- (NSString*)primitiveValidationRegexp;
- (void)setPrimitiveValidationRegexp:(NSString*)value;

- (NSMutableSet*)primitiveAllowedValues;
- (void)setPrimitiveAllowedValues:(NSMutableSet*)value;

- (FieldGroup*)primitiveFieldForGroup;
- (void)setPrimitiveFieldForGroup:(FieldGroup*)value;

- (RecipientType*)primitiveFieldForType;
- (void)setPrimitiveFieldForType:(RecipientType*)value;

- (NSMutableSet*)primitiveValues;
- (void)setPrimitiveValues:(NSMutableSet*)value;

@end
