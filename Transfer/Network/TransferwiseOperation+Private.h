//
//  TransferwiseOperation+Private.h
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^TRWOperationSuccessBlock)(NSDictionary *response);
typedef void (^TRWOperationErrorBlock)(NSError *error);

@interface TransferwiseOperation (Private)

- (void)setOperationSuccessHandler:(TRWOperationSuccessBlock)handler;
- (void)setOperationErrorHandler:(TRWOperationErrorBlock)handler;
- (void)postData:(NSDictionary *)data toPath:(NSString *)postPath;
- (void)getDataFromPath:(NSString *)path;

@end
