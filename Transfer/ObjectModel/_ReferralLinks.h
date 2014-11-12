// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to ReferralLinks.h instead.

#import <CoreData/CoreData.h>

extern const struct ReferralLinksAttributes {
	__unsafe_unretained NSString *channel;
	__unsafe_unretained NSString *url;
} ReferralLinksAttributes;

extern const struct ReferralLinksRelationships {
	__unsafe_unretained NSString *user;
} ReferralLinksRelationships;

@class User;

@interface ReferralLinksID : NSManagedObjectID {}
@end

@interface _ReferralLinks : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) ReferralLinksID* objectID;

@property (nonatomic, strong) NSString* channel;

//- (BOOL)validateChannel:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* url;

//- (BOOL)validateUrl:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) User *user;

//- (BOOL)validateUser:(id*)value_ error:(NSError**)error_;

@end

@interface _ReferralLinks (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveChannel;
- (void)setPrimitiveChannel:(NSString*)value;

- (NSString*)primitiveUrl;
- (void)setPrimitiveUrl:(NSString*)value;

- (User*)primitiveUser;
- (void)setPrimitiveUser:(User*)value;

@end
