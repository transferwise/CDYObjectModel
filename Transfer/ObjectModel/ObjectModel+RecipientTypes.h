//
//  ObjectModel+RecipientTypes.h
//  Transfer
//
//  Created by Jaanus Siim on 7/11/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "ObjectModel.h"

@class RecipientType;
@class RecipientTypeField;

@interface ObjectModel (RecipientTypes)

- (RecipientType *)recipientTypeWithCode:(NSString *)code;
- (NSArray *)recipientTypesWithCodes:(NSArray *)codes;
- (BOOL)haveRecipientTypeWithCode:(NSString *)code;
- (void)createOrUpdateRecipientTypeWithData:(NSDictionary *)data;
- (NSFetchedResultsController *)fetchedControllerForAllowedValuesOnField:(RecipientTypeField *)field;

@end
