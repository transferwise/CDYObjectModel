//
//  TypeFieldParser.h
//  Transfer
//
//  Created by Juhan Hion on 21.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CDYObjectModel.h"

@class RecipientTypeField;
@class AllowedTypeFieldValue;
@class ObjectModel;
@class TextEntryCell;

typedef NSString *(^GetFieldNameBlock)();
typedef RecipientTypeField *(^GetRecipientTypeBlock)(NSString *name);
typedef AllowedTypeFieldValue *(^GetAllowedTypeFieldValueBlock)(RecipientTypeField* field, NSString *code);
typedef NSString *(^StringGetterBlock)(NSDictionary *data);
typedef NSOrderedSet *(^GetFieldsBlock)();
typedef NSString *(^GetImageBlock)(NSDictionary *data);

@interface TypeFieldHelper : NSObject

+ (RecipientTypeField *)getTypeWithData:(NSDictionary *)data
							 nameGetter:(GetFieldNameBlock)nameGetterBlock
							fieldGetter:(GetRecipientTypeBlock)fieldGetterBlock
							valueGetter:(GetAllowedTypeFieldValueBlock)valueGetterBlock
							titleGetter:(StringGetterBlock)titleGetterBlock
							 typeGetter:(StringGetterBlock)typeGetterBlock
							imageGetter:(GetImageBlock)imageGetterBlock;

+ (NSArray *)generateFieldsArray:(UITableView *)tableView
					fieldsGetter:(GetFieldsBlock)fieldsGetterBlock
					 objectModel:(ObjectModel *)objectModel;

+ (AllowedTypeFieldValue *)existingAllowedValueForField:(RecipientTypeField *)field
												   code:(NSString *)code
											objectModel:(CDYObjectModel *)objectModel;

@end
