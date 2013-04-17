// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Recipient.h instead.

#import <CoreData/CoreData.h>


extern const struct RecipientAttributes {
	__unsafe_unretained NSString *name;
	__unsafe_unretained NSString *recipientID;
} RecipientAttributes;

extern const struct RecipientRelationships {
} RecipientRelationships;

extern const struct RecipientFetchedProperties {
} RecipientFetchedProperties;





@interface RecipientID : NSManagedObjectID {}
@end

@interface _Recipient : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (RecipientID*)objectID;





@property (nonatomic, strong) NSString* name;



//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSNumber* recipientID;



@property int32_t recipientIDValue;
- (int32_t)recipientIDValue;
- (void)setRecipientIDValue:(int32_t)value_;

//- (BOOL)validateRecipientID:(id*)value_ error:(NSError**)error_;






@end

@interface _Recipient (CoreDataGeneratedAccessors)

@end

@interface _Recipient (CoreDataGeneratedPrimitiveAccessors)


- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;




- (NSNumber*)primitiveRecipientID;
- (void)setPrimitiveRecipientID:(NSNumber*)value;

- (int32_t)primitiveRecipientIDValue;
- (void)setPrimitiveRecipientIDValue:(int32_t)value_;




@end
