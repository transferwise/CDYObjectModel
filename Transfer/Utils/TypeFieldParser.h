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

typedef NSString *(^GetFieldNameBlock)();
typedef RecipientTypeField *(^GetRecipientTypeBlock)(NSString *name);
typedef AllowedTypeFieldValue *(^GetAllowedTypeFieldValueBlock)(RecipientTypeField* field, NSString *code);

@interface TypeFieldParser : NSObject

+ (RecipientTypeField *)getTypeWithData:(NSDictionary *)data
							 nameGetter:(GetFieldNameBlock)nameGetterBlock
							fieldGetter:(GetRecipientTypeBlock)fieldGetterBlock
							valueGetter:(GetAllowedTypeFieldValueBlock)valueGetterBlock;

@end
