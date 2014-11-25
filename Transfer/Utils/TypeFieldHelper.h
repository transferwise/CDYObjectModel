//
//  TypeFieldParser.h
//  Transfer
//
//  Created by Juhan Hion on 21.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class RecipientTypeField;
@class AllowedTypeFieldValue;
@class ObjectModel;

typedef NSString *(^GetFieldNameBlock)();
typedef RecipientTypeField *(^GetRecipientTypeBlock)(NSString *name);
typedef AllowedTypeFieldValue *(^GetAllowedTypeFieldValueBlock)(RecipientTypeField* field, NSString *code);
typedef NSString *(^StringGetterBlock)(NSDictionary *data);
typedef NSOrderedSet *(^GetFieldsBlock)();

@interface TypeFieldHelper : NSObject

+ (RecipientTypeField *)getTypeWithData:(NSDictionary *)data
							 nameGetter:(GetFieldNameBlock)nameGetterBlock
							fieldGetter:(GetRecipientTypeBlock)fieldGetterBlock
							valueGetter:(GetAllowedTypeFieldValueBlock)valueGetterBlock
							titleGetter:(StringGetterBlock)titleGetterBlock;

+ (NSArray *)generateFieldsArray:(UITableView *)tableView
					fieldsGetter:(GetFieldsBlock)fieldsGetterBlock
					 objectModel:(ObjectModel *)objectModel;

@end
