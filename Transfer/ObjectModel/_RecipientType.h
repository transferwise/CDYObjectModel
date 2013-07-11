// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to RecipientType.h instead.

#import <CoreData/CoreData.h>


extern const struct RecipientTypeAttributes {
} RecipientTypeAttributes;

extern const struct RecipientTypeRelationships {
	__unsafe_unretained NSString *fields;
	__unsafe_unretained NSString *recipients;
} RecipientTypeRelationships;

extern const struct RecipientTypeFetchedProperties {
} RecipientTypeFetchedProperties;

@class RecipientTypeField;
@class Recipient;


@interface RecipientTypeID : NSManagedObjectID {}
@end

@interface _RecipientType : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RecipientTypeID*)objectID;





@property (nonatomic, strong) NSSet *fields;

- (NSMutableSet*)fieldsSet;




@property (nonatomic, strong) NSSet *recipients;

- (NSMutableSet*)recipientsSet;





@end

@interface _RecipientType (CoreDataGeneratedAccessors)

- (void)addFields:(NSSet*)value_;
- (void)removeFields:(NSSet*)value_;
- (void)addFieldsObject:(RecipientTypeField*)value_;
- (void)removeFieldsObject:(RecipientTypeField*)value_;

- (void)addRecipients:(NSSet*)value_;
- (void)removeRecipients:(NSSet*)value_;
- (void)addRecipientsObject:(Recipient*)value_;
- (void)removeRecipientsObject:(Recipient*)value_;

@end

@interface _RecipientType (CoreDataGeneratedPrimitiveAccessors)



- (NSMutableSet*)primitiveFields;
- (void)setPrimitiveFields:(NSMutableSet*)value;



- (NSMutableSet*)primitiveRecipients;
- (void)setPrimitiveRecipients:(NSMutableSet*)value;


@end
