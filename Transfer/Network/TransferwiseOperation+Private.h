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
typedef void (^TRWUploadOperationProgressBlock)(NSUInteger bytes, long long totalBytes, long long totalBytesExpected);

@interface TransferwiseOperation (Private)

- (void)setOperationSuccessHandler:(TRWOperationSuccessBlock)handler;
- (void)setOperationErrorHandler:(TRWOperationErrorBlock)handler;
- (void)setUploadProgressHandler:(TRWUploadOperationProgressBlock)handler;
- (void)postData:(NSDictionary *)data
		  toPath:(NSString *)postPath;
- (void)getDataFromPath:(NSString *)path;
- (void)getDataFromPath:(NSString *)path
				 params:(NSDictionary *)params;
- (void)postBinaryDataFromFile:(NSString *)filePath
					  withName:(NSString *)fileName
				   usingParams:(NSDictionary *)params
						toPath:(NSString *)postPath;
/**
 *	set this to YES if you are using a public API call that doesn't require users token
 */
- (void)setIsAnonymous:(BOOL)value;

/**
 *  BEWARE! HERE BE DRAGONS! Only intended to be used with the long time-out ACH request.
 *
 *  Use of
 *  - (void)postData:(NSDictionary *)data toPath:(NSString *)postPath
 *  encouraged
 *
 *  @param data     post data
 *  @param postPath api path
 *  @param timeOut  custom request timeout. negative means default is used.
 */
- (void)postData:(NSDictionary *)data toPath:(NSString *)postPath timeOut:(NSTimeInterval)timeOut;

@end
