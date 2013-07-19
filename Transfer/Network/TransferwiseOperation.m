
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
#import "ObjectModel.h"

@interface TransferwiseOperation ()

@property (nonatomic, copy) TRWOperationSuccessBlock operationSuccessHandler;
@property (nonatomic, copy) TRWOperationErrorBlock operationErrorHandler;
@property (nonatomic, strong) ObjectModel *workModel;

@end

@implementation TransferwiseOperation

- (void)execute {
    ABSTRACT_METHOD;
}

- (void)postData:(NSDictionary *)data toPath:(NSString *)postPath {
    NSString *accessToken = [Credentials accessToken];
    MCLog(@"Post %@ to %@", [data sensibleDataHidden], [postPath stringByReplacingOccurrencesOfString:(accessToken ? accessToken : @"" ) withString:@"**********"]);
    [self executeOperationWithMethod:@"POST" path:postPath parameters:data];
}

- (void)getDataFromPath:(NSString *)path {
    [self getDataFromPath:path params:nil];
}

- (void)getDataFromPath:(NSString *)path params:(NSDictionary *)params {
    NSString *accessToken = [Credentials accessToken];
    MCLog(@"Get data from:%@", [path stringByReplacingOccurrencesOfString:(accessToken ? accessToken : @"" ) withString:@"**********"]);
    MCLog(@"Params:%@", [params sensibleDataHidden]);
    [self executeOperationWithMethod:@"GET" path:path parameters:params];
}

- (void)performDelete:(NSString *)path withParams:(NSDictionary *)params {
    [self executeOperationWithMethod:@"DELETE" path:path parameters:params];
}

- (void)putData:(NSDictionary *)data toPath:(NSString *)putPath {
    NSString *accessToken = [Credentials accessToken];
    MCLog(@"Put %@ to: %@", [data sensibleDataHidden], [putPath stringByReplacingOccurrencesOfString:(accessToken ? accessToken : @"" ) withString:@"**********"]);
    [self executeOperationWithMethod:@"PUT" path:putPath parameters:data];
}

- (void)postBinaryDataFromFile:(NSString *)filePath withName:(NSString *)fileName usingParams:(NSDictionary *)params toPath:(NSString *)postPath {
    NSMutableURLRequest *request = [[TransferwiseClient sharedClient] multipartFormRequestWithMethod:@"POST" path:postPath parameters:params constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
        [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:fileName error:nil];
    }];

    [self executeRequest:request];
}

- (void)executeOperationWithMethod:(NSString *)method path:(NSString *)path parameters:(NSDictionary *)parameters {
    NSMutableURLRequest *request = [[TransferwiseClient sharedClient] requestWithMethod:method path:path parameters:parameters];
    [self executeRequest:request];
}

- (void)executeRequest:(NSMutableURLRequest *)request {
    if ([Credentials userLoggedIn]) {
        [request setValue:[Credentials accessToken] forHTTPHeaderField:@"Authorization"];
    }

    [request setValue:@"ad8d836d18ec18fbd4ccc7bffd71eb54" forHTTPHeaderField:@"Authorization-key"];
    //TODO jaanus: Also client id (the one from google analytics) should be in header 'Customer-identifier'

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setThreadPriority:0.1];
    [operation setQueuePriority:NSOperationQueuePriorityLow];
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, id responseObject) {
        NSInteger statusCode = op.response.statusCode;
        MCLog(@"%@ - Success:%d", op.request.URL.path, statusCode);
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

        if (![recovery hasValue]) {
            MCLog(@"No recovery information");
            self.operationErrorHandler(error);
            return;
        }

        NSData *data = [recovery dataUsingEncoding:NSUTF8StringEncoding];
        NSError *jsonError = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:data options:0 error:&jsonError];
        if (jsonError) {
            NSLog(@"Error JSON read error:%@", jsonError);
            self.operationErrorHandler(error);
        } else {
            [self createErrorAndNotifyFromResponse:response];
        }
    }];
    [operation start];
}

- (void)createErrorAndNotifyFromResponse:(NSDictionary *)response {
    id errors = response[@"errors"];
    if ([errors isKindOfClass:[NSDictionary class]]) {
        errors = @[errors];
    }

    NSArray *handledErrors = errors;

    MCLog(@"Received %d errors", [handledErrors count]);

    NSError *cumulativeError = [self createCumulativeError:handledErrors];
    if ([self containsExpiredTokenError:handledErrors]) {
        MCLog(@"Expired token error");
        //TODO jaanus: Do other action also need given error?
        //This if is added here because most operations don't need this error. Screen where user was on
        //will be covered by login view controller.
        self.operationErrorHandler([self isCurrencyPairsOperation] ? cumulativeError : nil);

        dispatch_async(dispatch_get_main_queue(), ^{
            // Ensure notification posted only once. When multiple requests run at once and get expired token error,
            // then first request clears credentials and posts notification
            if (![Credentials userLoggedIn]) {
                return;
            }

            [Credentials clearCredentials];
            [[NSNotificationCenter defaultCenter] postNotificationName:TRWLoggedOutNotification object:nil];
        });
    } else {
        MCLog(@"Other errors");
        self.operationErrorHandler(cumulativeError);
    }
}

- (BOOL)isCurrencyPairsOperation {
    return [self isKindOfClass:[CurrencyPairsOperation class]];
}

- (NSError *)createCumulativeError:(NSArray *)errors {
    //TODO jaanus: maybe can improve this
    NSDictionary *userInfo = @{TRWErrors: errors};
    NSError *error = [[NSError alloc] initWithDomain:TRWErrorDomain code:0 userInfo:userInfo];
    return error;
}

- (BOOL)containsExpiredTokenError:(NSArray *)errors {
    for (NSDictionary *data in errors) {
        NSString *code = data[@"code"];
        if ([TRWNetworkErrorExpiredToken isEqualToString:code]) {
            return YES;
        } else if ([TRWNetworkErrorInvalidToken isEqualToString:code]) {
            return YES;
        }
    }

    return NO;
}

- (NSString *)addTokenToPath:(NSString *)path {
    return [[TransferwiseClient sharedClient] addTokenToPath:path];
}

- (ObjectModel *)workModel {
    if (!_workModel) {
        _workModel = [self.objectModel spawnBackgroundInstance];
    }
    return _workModel;
}

@end
