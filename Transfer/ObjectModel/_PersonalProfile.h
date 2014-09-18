// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to PersonalProfile.h instead.

#import <CoreData/CoreData.h>


extern const struct PersonalProfileAttributes {
	__unsafe_unretained NSString *addressFirstLine;
	__unsafe_unretained NSString *city;
	__unsafe_unretained NSString *countryCode;
	__unsafe_unretained NSString *dateOfBirth;
	__unsafe_unretained NSString *firstName;
	__unsafe_unretained NSString *lastName;
	__unsafe_unretained NSString *occupation;
	__unsafe_unretained NSString *phoneNumber;
	__unsafe_unretained NSString *postCode;
	__unsafe_unretained NSString *readonlyFields;
	__unsafe_unretained NSString *sendAsBusiness;
	__unsafe_unretained NSString *state;
} PersonalProfileAttributes;

extern const struct PersonalProfileRelationships {
	__unsafe_unretained NSString *user;
} PersonalProfileRelationships;

extern const struct PersonalProfileFetchedProperties {
} PersonalProfileFetchedProperties;

@class User;














@interface PersonalProfileID : NSManagedObjectID {}
@end

@interface _PersonalProfile : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (PersonalProfileID*)objectID;





@property (nonatomic, strong) NSString* addressFirstLine;



//- (BOOL)validateAddressFirstLine:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* city;



//- (BOOL)validateCity:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* countryCode;



//- (BOOL)validateCountryCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* dateOfBirth;



//- (BOOL)validateDateOfBirth:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* firstName;



//- (BOOL)validateFirstName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* lastName;



//- (BOOL)validateLastName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* occupation;



//- (BOOL)validateOccupation:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* phoneNumber;



//- (BOOL)validatePhoneNumber:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* postCode;



//- (BOOL)validatePostCode:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* readonlyFields;



//- (BOOL)validateReadonlyFields:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* sendAsBusiness;



@property BOOL sendAsBusinessValue;
- (BOOL)sendAsBusinessValue;
- (void)setSendAsBusinessValue:(BOOL)value_;

//- (BOOL)validateSendAsBusiness:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* state;



//- (BOOL)validateState:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;





@end

@interface _PersonalProfile (CoreDataGeneratedAccessors)

@end

@interface _PersonalProfile (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveAddressFirstLine;
- (void)setPrimitiveAddressFirstLine:(NSString*)value;




- (NSString*)primitiveCity;
- (void)setPrimitiveCity:(NSString*)value;




- (NSString*)primitiveCountryCode;
- (void)setPrimitiveCountryCode:(NSString*)value;




- (NSString*)primitiveDateOfBirth;
- (void)setPrimitiveDateOfBirth:(NSString*)value;




- (NSString*)primitiveFirstName;
- (void)setPrimitiveFirstName:(NSString*)value;




- (NSString*)primitiveLastName;
- (void)setPrimitiveLastName:(NSString*)value;




- (NSString*)primitiveOccupation;
- (void)setPrimitiveOccupation:(NSString*)value;




- (NSString*)primitivePhoneNumber;
- (void)setPrimitivePhoneNumber:(NSString*)value;




- (NSString*)primitivePostCode;
- (void)setPrimitivePostCode:(NSString*)value;




- (NSString*)primitiveReadonlyFields;
- (void)setPrimitiveReadonlyFields:(NSString*)value;




- (NSNumber*)primitiveSendAsBusiness;
- (void)setPrimitiveSendAsBusiness:(NSNumber*)value;

- (BOOL)primitiveSendAsBusinessValue;
- (void)setPrimitiveSendAsBusinessValue:(BOOL)value_;




- (NSString*)primitiveState;
- (void)setPrimitiveState:(NSString*)value;





- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;


@end
