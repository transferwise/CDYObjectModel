//
//  RecipientsOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 7/1/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"

typedef void (^ListRecipientsBlock)(NSError *error);

@interface RecipientsOperation : TransferwiseOperation

@property (nonatomic, copy) ListRecipientsBlock responseHandler;

- (void)persistRecipients:(NSDictionary *)response;

@end
