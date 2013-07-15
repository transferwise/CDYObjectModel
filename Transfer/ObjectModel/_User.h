// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>


extern const struct UserAttributes {
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *pReference;
} UserAttributes;

extern const struct UserRelationships {
	__unsafe_unretained NSString *businessProfile;
	__unsafe_unretained NSString *contacts;
	__unsafe_unretained NSString *payments;
	__unsafe_unretained NSString *personalProfile;
} UserRelationships;

extern const struct UserFetchedProperties {
} UserFetchedProperties;

@class BusinessProfile;
@class Recipient;
@class Payment;
@class PersonalProfile;




@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (UserID*)objectID;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* pReference;



//- (BOOL)validatePReference:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) BusinessProfile *businessProfile;

//- (BOOL)validateBusinessProfile:(id*)value_ error:(NSError**)error_;




@property (nonatomic, strong) NSSet *contacts;

- (NSMutableSet*)contactsSet;




@property (nonatomic, strong) NSSet *payments;

- (NSMutableSet*)paymentsSet;




@property (nonatomic, strong) PersonalProfile *personalProfile;

//- (BOOL)validatePersonalProfile:(id*)value_ error:(NSError**)error_;





@end

@interface _User (CoreDataGeneratedAccessors)

- (void)addContacts:(NSSet*)value_;
- (void)removeContacts:(NSSet*)value_;
- (void)addContactsObject:(Recipient*)value_;
- (void)removeContactsObject:(Recipient*)value_;

- (void)addPayments:(NSSet*)value_;
- (void)removePayments:(NSSet*)value_;
- (void)addPaymentsObject:(Payment*)value_;
- (void)removePaymentsObject:(Payment*)value_;

@end

@interface _User (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSString*)primitivePReference;
- (void)setPrimitivePReference:(NSString*)value;





- (BusinessProfile*)primitiveBusinessProfile;
- (void)setPrimitiveBusinessProfile:(BusinessProfile*)value;



- (NSMutableSet*)primitiveContacts;
- (void)setPrimitiveContacts:(NSMutableSet*)value;



- (NSMutableSet*)primitivePayments;
- (void)setPrimitivePayments:(NSMutableSet*)value;



- (PersonalProfile*)primitivePersonalProfile;
- (void)setPrimitivePersonalProfile:(PersonalProfile*)value;


@end
