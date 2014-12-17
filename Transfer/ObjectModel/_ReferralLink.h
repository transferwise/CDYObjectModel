// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ReferralLink.h instead.

#import <CoreData/CoreData.h>

extern const struct ReferralLinkAttributes {
	__unsafe_unretained NSString *channel;
	__unsafe_unretained NSString *url;
} ReferralLinkAttributes;

extern const struct ReferralLinkRelationships {
	__unsafe_unretained NSString *user;
} ReferralLinkRelationships;

@class User;

@interface ReferralLinkID : NSManagedObjectID {}
@end

@interface _ReferralLink : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ReferralLinkID* objectID;

@property (nonatomic, strong) NSNumber* channel;

@property (atomic) int16_t channelValue;
- (int16_t)channelValue;
- (void)setChannelValue:(int16_t)value_;

//- (BOOL)validateChannel:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _ReferralLink (CoreDataGeneratedPrimitiveAccessors)

- (NSNumber*)primitiveChannel;
- (void)setPrimitiveChannel:(NSNumber*)value;

- (int16_t)primitiveChannelValue;
- (void)setPrimitiveChannelValue:(int16_t)value_;

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end
