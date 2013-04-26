//
//  TransferwiseOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TransferwiseOperation.h"
#import "Constants.h"
#import "AFHTTPClient.h"
#import "AFHTTPRequestOperation.h"
#import "TransferwiseOperation+Private.h"
#import "NSDictionary+SensibleData.h"
#import "Credentials.h"
#import "TransferwiseClient.h"
#import "NSString+Validation.h"
#import "NetworkErrorCodes.h"

NSString *const TRWErrorDomain = @"TRWErrorDomain";
NSString *const kAPIPathBase = @"/api/v1/";

@interface TransferwiseOperation ()

@property (nonatomic, copy) TRWOperationSuccessBlock operationSuccessHandler;
@property (nonatomic, copy) TRWOperationErrorBlock operationErrorHandler;

@end

@implementation TransferwiseOperation

- (void)execute {
    ABSTRACT_METHOD;
}

- (void)postData:(NSDictionary *)data toPath:(NSString *)postPath {
    MCLog(@"Post %@ to %@", [data sensibleDataHidden], postPath);
    [self executeOperationWithMethod:@"POST" path:postPath parameters:data];
}

- (void)getDataFromPath:(NSString *)path {
    [self getDataFromPath:path params:nil];
}

- (void)getDataFromPath:(NSString *)path params:(NSDictionary *)params {
    NSString *accessToken = [Credentials accessToken];
    MCLog(@"Get data from:%@", [path stringByReplacingOccurrencesOfString:(accessToken ? accessToken : @"" ) withString:@"**********"]);
    [self executeOperationWithMethod:@"GET" path:path parameters:params];
}

- (void)executeOperationWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    AFHTTPClient *client = [TransferwiseClient sharedClient];
    NSMutableURLRequest *request = [client requestWithMethod:method path:path parameters:parameters];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setThreadPriority:0.1];
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, id responseObject) {
        NSInteger statusCode = op.response.statusCode;
        MCLog(@"Success:%d", statusCode);
        if (statusCode != 200) {
            NSError *error = [NSError errorWithDomain:TRWErrorDomain code:ResponseServerError userInfo:@{}];
            self.operationErrorHandler(error);
            return;
        }

        MCLog(@"Response:%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSError *jsonError = nil;

        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&jsonError];
        if (jsonError) {
            NSError *error = [NSError errorWithDomain:TRWErrorDomain code:ResponseFormatError userInfo:@{NSUnderlyingErrorKey : jsonError}];
            self.operationErrorHandler(error);
            return;
        }

        self.operationSuccessHandler(response);
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
        MCLog(@"Error:%@", error);
        NSString *recovery = [error localizedRecoverySuggestion];
        if ([recovery hasValue]) {
            [self createErrorAndNotifyFromResponse:recovery];
        } else {
            self.operationErrorHandler(error);
        }
    }];
    [operation start];
}

- (void)createErrorAndNotifyFromResponse:(NSString *)errorResponse {
    NSData *data = [errorResponse dataUsingEncoding:NSUTF8StringEncoding];
    NSError *jsonError = nil;
    NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
    if (jsonError) {
        NSLog(@"Erro JSON read error:%@", jsonError);
    }

    id errors = response[@"errors"];
    if ([errors isKindOfClass:[NSDictionary class]]) {
        errors = @[errors];
    }

    NSArray *handledErrors = errors;
    if ([self containsExpiredTokenError:handledErrors]) {
        //TODO jaanus: check this. Should maybe some error be also posted?
        self.operationErrorHandler(nil);
        [Credentials clearCredentials];
        [[NSNotificationCenter defaultCenter] postNotificationName:TRWLoggedOutNotification object:nil];
    }
}

- (BOOL)containsExpiredTokenError:(NSArray *)errors {
    for (NSDictionary *data in errors) {
        NSString *code = data[@"code"];
        if ([TRWNetworkErrorExpiredToken isEqualToString:code]) {
            return YES;
        }
    }

    return NO;
}

- (NSString *)addTokenToPath:(NSString *)path {
    return [NSString stringWithFormat:@"%@%@%@", kAPIPathBase, [Credentials accessToken], path];
}

@end
