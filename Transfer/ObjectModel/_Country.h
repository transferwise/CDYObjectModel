// DO NOT EDIT. This file is machine-generated and constantly overwritten.
// Make changes to Country.h instead.

#import <CoreData/CoreData.h>

extern const struct CountryAttributes {
	__unsafe_unretained NSString *iso2Code;
	__unsafe_unretained NSString *iso3Code;
	__unsafe_unretained NSString *name;
} CountryAttributes;

@interface CountryID : NSManagedObjectID {}
@end

@interface _Country : NSManagedObject {}
+ (id)insertInManagedObjectContext:(NSManagedObjectContext*)moc_;
+ (NSString*)entityName;
+ (NSEntityDescription*)entityInManagedObjectContext:(NSManagedObjectContext*)moc_;
@property (nonatomic, readonly, strong) CountryID* objectID;

@property (nonatomic, strong) NSString* iso2Code;

//- (BOOL)validateIso2Code:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* iso3Code;

//- (BOOL)validateIso3Code:(id*)value_ error:(NSError**)error_;

@property (nonatomic, strong) NSString* name;

//- (BOOL)validateName:(id*)value_ error:(NSError**)error_;

@end

@interface _Country (CoreDataGeneratedPrimitiveAccessors)

- (NSString*)primitiveIso2Code;
- (void)setPrimitiveIso2Code:(NSString*)value;

- (NSString*)primitiveIso3Code;
- (void)setPrimitiveIso3Code:(NSString*)value;

- (NSString*)primitiveName;
- (void)setPrimitiveName:(NSString*)value;

@end
