//
//  RecipientUpdateOperation.h
//  Transfer
//
//  Created by Mats Trovik on 24/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
@class Recipient;
@class ObjectModel;

@interface RecipientUpdateOperation : TransferwiseOperation

@property (nonatomic, strong) Recipient* recipient;
@property (nonatomic, strong) ObjectModel* objectModel;
@property (nonatomic, copy) void(^completionHandler)(NSError* error);

+(instancetype)instanceWithRecipient:(Recipient*)recipient objectModel:(ObjectModel*)objectModel completionHandler:(void(^)(NSError* error))completionHandler;

@end
