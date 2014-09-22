// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Setting.h instead.

#import <CoreData/CoreData.h>


extern const struct SettingAttributes {
	__unsafe_unretained NSString *key;
	__unsafe_unretained NSString *value;
} SettingAttributes;

extern const struct SettingRelationships {
} SettingRelationships;

extern const struct SettingFetchedProperties {
} SettingFetchedProperties;





@interface SettingID : NSManagedObjectID {}
@end

@interface _Setting : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
- (SettingID*)objectID;





@property (nonatomic, strong) NSNumber* key;



@property int16_t keyValue;
- (int16_t)keyValue;
- (void)setKeyValue:(int16_t)value_;

//- (BOOL)validateKey:(id*)value_ error:(NSError**)error_;





@property (nonatomic, strong) NSString* value;



//- (BOOL)validateValue:(id*)value_ error:(NSError**)error_;






@end

@interface _Setting (CoreDataGeneratedAccessors)

@end

@interface _Setting (CoreDataGeneratedPrimitiveAccessors)


- (NSNumber*)primitiveKey;
- (void)setPrimitiveKey:(NSNumber*)value;

- (int16_t)primitiveKeyValue;
- (void)setPrimitiveKeyValue:(int16_t)value_;




- (NSString*)primitiveValue;
- (void)setPrimitiveValue:(NSString*)value;




@end
