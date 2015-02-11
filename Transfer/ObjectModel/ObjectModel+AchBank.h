//
//  ObjectModel+AchBank.h
//  Transfer
//
//  Created by Juhan Hion on 24.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@class AchBank;

@interface ObjectModel (AchBank)

- (AchBank *)bankWithTitle:(NSString *)title
				 fieldType:(NSString *)fieldType;
- (void)createOrUpdateAchBankWithData:(NSDictionary *)data
							bankTitle:(NSString *)bankTitle
							   formId:(NSString *)formId
							fieldType:(NSString *)fieldType
							   itemId:(NSString *)itemId;

@end
