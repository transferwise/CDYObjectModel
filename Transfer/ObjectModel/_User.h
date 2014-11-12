// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to User.h instead.

#import <CoreData/CoreData.h>

extern const struct UserAttributes {
	__unsafe_unretained NSString *anonymous;
	__unsafe_unretained NSString *email;
	__unsafe_unretained NSString *invitationReward;
	__unsafe_unretained NSString *invitationRewardCurrency;
	__unsafe_unretained NSString *inviteUrl;
	__unsafe_unretained NSString *pReference;
	__unsafe_unretained NSString *password;
	__unsafe_unretained NSString *sendAsBusinessDefaultSetting;
	__unsafe_unretained NSString *successfulInviteCount;
} UserAttributes;

extern const struct UserRelationships {
	__unsafe_unretained NSString *businessProfile;
	__unsafe_unretained NSString *contacts;
	__unsafe_unretained NSString *payments;
	__unsafe_unretained NSString *personalProfile;
	__unsafe_unretained NSString *referralLinks;
} UserRelationships;

@class BusinessProfile;
@class Recipient;
@class Payment;
@class PersonalProfile;
@class ReferralLinks;

@interface UserID : NSManagedObjectID {}
@end

@interface _User : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) UserID* objectID;

@property (nonatomic, strong) NSNumber* anonymous;

@property (atomic) BOOL anonymousValue;
- (BOOL)anonymousValue;
- (void)setAnonymousValue:(BOOL)value_;

//- (BOOL)validateAnonymous:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* email;

//- (BOOL)validateEmail:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* invitationReward;

@property (atomic) int16_t invitationRewardValue;
- (int16_t)invitationRewardValue;
- (void)setInvitationRewardValue:(int16_t)value_;

//- (BOOL)validateInvitationReward:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* invitationRewardCurrency;

//- (BOOL)validateInvitationRewardCurrency:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* inviteUrl;

//- (BOOL)validateInviteUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* pReference;

//- (BOOL)validatePReference:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* password;

//- (BOOL)validatePassword:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* sendAsBusinessDefaultSetting;

@property (atomic) BOOL sendAsBusinessDefaultSettingValue;
- (BOOL)sendAsBusinessDefaultSettingValue;
- (void)setSendAsBusinessDefaultSettingValue:(BOOL)value_;

//- (BOOL)validateSendAsBusinessDefaultSetting:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSNumber* successfulInviteCount;

@property (atomic) int16_t successfulInviteCountValue;
- (int16_t)successfulInviteCountValue;
- (void)setSuccessfulInviteCountValue:(int16_t)value_;

//- (BOOL)validateSuccessfulInviteCount:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) BusinessProfile *businessProfile;

//- (BOOL)validateBusinessProfile:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSSet *contacts;

- (NSMutableSet*)contactsSet;

@property (nonatomic, strong) NSSet *payments;

- (NSMutableSet*)paymentsSet;

@property (nonatomic, strong) PersonalProfile *personalProfile;

//- (BOOL)validatePersonalProfile:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) ReferralLinks *referralLinks;

//- (BOOL)validateReferralLinks:(id*)value_ error:(NSError**)error_;

@end

@interface _User (ContactsCoreDataGeneratedAccessors)
- (void)addContacts:(NSSet*)value_;
- (void)removeContacts:(NSSet*)value_;
- (void)addContactsObject:(Recipient*)value_;
- (void)removeContactsObject:(Recipient*)value_;

@end

@interface _User (PaymentsCoreDataGeneratedAccessors)
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

- (NSNumber*)primitiveInvitationReward;
- (void)setPrimitiveInvitationReward:(NSNumber*)value;

- (int16_t)primitiveInvitationRewardValue;
- (void)setPrimitiveInvitationRewardValue:(int16_t)value_;

- (NSString*)primitiveInvitationRewardCurrency;
- (void)setPrimitiveInvitationRewardCurrency:(NSString*)value;

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

- (NSNumber*)primitiveSuccessfulInviteCount;
- (void)setPrimitiveSuccessfulInviteCount:(NSNumber*)value;

- (int16_t)primitiveSuccessfulInviteCountValue;
- (void)setPrimitiveSuccessfulInviteCountValue:(int16_t)value_;

- (BusinessProfile*)primitiveBusinessProfile;
- (void)setPrimitiveBusinessProfile:(BusinessProfile*)value;

- (NSMutableSet*)primitiveContacts;
- (void)setPrimitiveContacts:(NSMutableSet*)value;

- (NSMutableSet*)primitivePayments;
- (void)setPrimitivePayments:(NSMutableSet*)value;

- (PersonalProfile*)primitivePersonalProfile;
- (void)setPrimitivePersonalProfile:(PersonalProfile*)value;

- (ReferralLinks*)primitiveReferralLinks;
- (void)setPrimitiveReferralLinks:(ReferralLinks*)value;

@end
