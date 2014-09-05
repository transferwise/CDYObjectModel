// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>


extern const struct UserAttributes {
	__unsafe_unretained NSString *anonymous;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *hasSuccessfulInvites;
	__unsafe_unretained NSString *inviteUrl;
	__unsafe_unretained NSString *pReference;
	__unsafe_unretained NSString *password;
	__unsafe_unretained NSString *sendAsBusinessDefaultSetting;
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





@property (nonatomic, strong) NSNumber* anonymous;



@property BOOL anonymousValue;
- (BOOL)anonymousValue;
- (void)setAnonymousValue:(BOOL)value_;

//- (BOOL)validateAnonymous:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* email;



//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* hasSuccessfulInvites;



@property BOOL hasSuccessfulInvitesValue;
- (BOOL)hasSuccessfulInvitesValue;
- (void)setHasSuccessfulInvitesValue:(BOOL)value_;

//- (BOOL)validateHasSuccessfulInvites:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* inviteUrl;



//- (BOOL)validateInviteUrl:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* pReference;



//- (BOOL)validatePReference:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* password;



//- (BOOL)validatePassword:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* sendAsBusinessDefaultSetting;



@property BOOL sendAsBusinessDefaultSettingValue;
- (BOOL)sendAsBusinessDefaultSettingValue;
- (void)setSendAsBusinessDefaultSettingValue:(BOOL)value_;

//- (BOOL)validateSendAsBusinessDefaultSetting:(id*)value_ error:(NSError**)error_;





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


- (NSNumber*)primitiveAnonymous;
- (void)setPrimitiveAnonymous:(NSNumber*)value;

- (BOOL)primitiveAnonymousValue;
- (void)setPrimitiveAnonymousValue:(BOOL)value_;




- (NSString*)primitiveEmail;
- (void)setPrimitiveEmail:(NSString*)value;




- (NSNumber*)primitiveHasSuccessfulInvites;
- (void)setPrimitiveHasSuccessfulInvites:(NSNumber*)value;

- (BOOL)primitiveHasSuccessfulInvitesValue;
- (void)setPrimitiveHasSuccessfulInvitesValue:(BOOL)value_;




- (NSString*)primitiveInviteUrl;
- (void)setPrimitiveInviteUrl:(NSString*)value;




- (NSString*)primitivePReference;
- (void)setPrimitivePReference:(NSString*)value;




- (NSString*)primitivePassword;
- (void)setPrimitivePassword:(NSString*)value;




- (NSNumber*)primitiveSendAsBusinessDefaultSetting;
- (void)setPrimitiveSendAsBusinessDefaultSetting:(NSNumber*)value;

- (BOOL)primitiveSendAsBusinessDefaultSettingValue;
- (void)setPrimitiveSendAsBusinessDefaultSettingValue:(BOOL)value_;





- (BusinessProfile*)primitiveBusinessProfile;
- (void)setPrimitiveBusinessProfile:(BusinessProfile*)value;



- (NSMutableSet*)primitiveContacts;
- (void)setPrimitiveContacts:(NSMutableSet*)value;



- (NSMutableSet*)primitivePayments;
- (void)setPrimitivePayments:(NSMutableSet*)value;



- (PersonalProfile*)primitivePersonalProfile;
- (void)setPrimitivePersonalProfile:(PersonalProfile*)value;


@end
