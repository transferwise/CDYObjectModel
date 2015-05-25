// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to BusinessProfile.h instead.

#import <CoreData/CoreData.h>

extern const struct BusinessProfileAttributes {
	__unsafe_unretained NSString *addressFirstLine;
	__unsafe_unretained NSString *businessDescription;
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *companyRole;
	__unsafe_unretained NSString *companyType;
	__unsafe_unretained NSString *countryCode;
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *postCode;
	__unsafe_unretained NSString *readonlyFields;
	__unsafe_unretained NSString *registrationNumber;
	__unsafe_unretained NSString *state;
} BusinessProfileAttributes;

extern const struct BusinessProfileRelationships {
	__unsafe_unretained NSString *user;
} BusinessProfileRelationships;

@class User;

@interface BusinessProfileID : NSManagedObjectID {}
@end

@interface _BusinessProfile : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) BusinessProfileID* objectID;

@property (nonatomic, strong) NSString* addressFirstLine;

//- (BOOL)validateAddressFirstLine:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* businessDescription;

//- (BOOL)validateBusinessDescription:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* city;

//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* companyRole;

//- (BOOL)validateCompanyRole:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* companyType;

//- (BOOL)validateCompanyType:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* countryCode;

//- (BOOL)validateCountryCode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* postCode;

//- (BOOL)validatePostCode:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* readonlyFields;

//- (BOOL)validateReadonlyFields:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* registrationNumber;

//- (BOOL)validateRegistrationNumber:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* state;

//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _BusinessProfile (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveAddressFirstLine;
- (void)setPrimitiveAddressFirstLine:(NSString*)value;

- (NSString*)primitiveBusinessDescription;
- (void)setPrimitiveBusinessDescription:(NSString*)value;

- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;

- (NSString*)primitiveCompanyRole;
- (void)setPrimitiveCompanyRole:(NSString*)value;

- (NSString*)primitiveCompanyType;
- (void)setPrimitiveCompanyType:(NSString*)value;

- (NSString*)primitiveCountryCode;
- (void)setPrimitiveCountryCode:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

- (NSString*)primitivePostCode;
- (void)setPrimitivePostCode:(NSString*)value;

- (NSString*)primitiveReadonlyFields;
- (void)setPrimitiveReadonlyFields:(NSString*)value;

- (NSString*)primitiveRegistrationNumber;
- (void)setPrimitiveRegistrationNumber:(NSString*)value;

- (NSString*)primitiveState;
- (void)setPrimitiveState:(NSString*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end
