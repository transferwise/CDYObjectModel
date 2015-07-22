
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
#import "NetworkErrorCodes.h"
#import "ObjectModel.h"
#import "AFNetworkActivityIndicatorManager.h"
#import "GAI.h"
#import "GoogleAnalytics.h"
#import "GAIFields.h"
#import "AuthenticationHelper.h"
#import "LocationHelper.h"
#import <Crashlytics/Crashlytics.h>

static int instanceCount = 0;

@interface TransferwiseOperation ()

@property (nonatomic, copy) TRWOperationSuccessBlock operationSuccessHandler;
@property (nonatomic, copy) TRWOperationErrorBlock operationErrorHandler;
@property (nonatomic, copy) TRWUploadOperationProgressBlock uploadProgressHandler;
@property (nonatomic, strong) ObjectModel *workModel;
@property (nonatomic) BOOL isAnonymous;
@property (nonatomic) BOOL hasBeenCancelled;
@property (atomic) int instanceNumber;

@end

@implementation TransferwiseOperation

#pragma mark - Init
- (instancetype)init
{
	self = [super init];
	if (self)
	{
		self.isAnonymous = NO;
        self.instanceNumber = instanceCount;
        instanceCount++;
	}
	return self;
}

#pragma mark - Abstract Methods
- (void)execute {
    ABSTRACT_METHOD;
}


/**
 *  Add seom logging to the destructor
 */

- (void) dealloc
{
    [self logState: @"Dealloced"];
}

#pragma mark - Post and Get Data
- (void)postData:(NSDictionary *)data
		  toPath:(NSString *)postPath
{
    [self postData:data
			toPath:postPath
		   timeOut:-1];
}

- (void)postData:(NSDictionary *)data
		  toPath:(NSString *)postPath
		 timeOut:(NSTimeInterval) timeOut
{
    NSString *accessToken = [Credentials accessToken];
    MCLog(@"Post %@ to %@", [data sensibleDataHidden], [postPath stringByReplacingOccurrencesOfString:(accessToken ? accessToken : @"" ) withString:@"**********"]);
	
    [self executeOperationWithMethod:@"POST"
								path:postPath
						  parameters:data
							 timeOut:timeOut];
}

- (void)getDataFromPath:(NSString *)path
{
    [self getDataFromPath:path
				   params:nil];
}

- (void)getDataFromPath:(NSString *)path
				 params:(NSDictionary *)params
{
    NSString *accessToken = [Credentials accessToken];
    MCLog(@"Server: %@", TRWServerAddress);
    MCLog(@"Get data from:%@", [path stringByReplacingOccurrencesOfString:(accessToken ? accessToken : @"" ) withString:@"**********"]);
	
    MCLog(@"Params:%@", [params sensibleDataHidden]);
    [self executeOperationWithMethod:@"GET"
								path:path
						  parameters:params];
}

- (void)postBinaryDataFromFile:(NSString *)filePath
					  withName:(NSString *)fileName
				   usingParams:(NSDictionary *)params
						toPath:(NSString *)postPath
{
    MCLog(@"Post binary. Params:%@", [params sensibleDataHidden]);
	NSMutableURLRequest *request = [[TransferwiseClient sharedClient] multipartFormRequestWithMethod:@"POST"
																								path:postPath
																						  parameters:params
																		   constructingBodyWithBlock: ^(id <AFMultipartFormData> formData) {
																			   [formData appendPartWithFileURL:[NSURL fileURLWithPath:filePath] name:fileName error:nil];
																		   }];

    [self executeRequest:request];
}

- (void)executeOperationWithMethod:(NSString *)method
							  path:(NSString *)path
						parameters:(NSDictionary *)parameters
{
    [self executeOperationWithMethod:method
								path:path
						  parameters:parameters
							 timeOut:-1];
}
    
- (void)executeOperationWithMethod:(NSString *)method
							  path:(NSString *)path
						parameters:(NSDictionary *)parameters
						   timeOut:(NSTimeInterval)timeout
{
	NSMutableURLRequest *request = [[TransferwiseClient sharedClient] requestWithMethod:method
																				   path:path
																			 parameters:parameters];
    if(timeout >0)
    {
        request.timeoutInterval = timeout;
    }
    [self executeRequest:request];
}

#pragma mark - Request Execution
- (void)executeRequest:(NSMutableURLRequest *)request
{
    [self logState: @"Executing"];
    
    [TransferwiseOperation provideAuthenticationHeaders:request
											isAnonymous:self.isAnonymous];
	[TransferwiseOperation provideLanguageHeader:request];

    [[AFNetworkActivityIndicatorManager sharedManager] setEnabled:YES];

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    [operation setThreadPriority:0.1];
    [operation setQueuePriority:NSOperationQueuePriorityLow];
	
#if DEV_VERSION
	//if you want to run app against localhost then it has invalid cert
	[operation setAllowsInvalidSSLCertificate:YES];
#endif
    __weak typeof(self) weakSelf = self;
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *op, id responseObject) {
        
        if (self.hasBeenCancelled) {
            
            [self logState: @"Cancelled"];
            return;
        }
        

        
        NSInteger statusCode = op.response.statusCode;
        MCLog(@"%@ - Success:%ld - %lu", op.request.URL.path, (long)statusCode, (unsigned long)[responseObject length]);
        if (statusCode != 200 || !responseObject) {
            [self logState: @"Failure (Not 200 or no response)"];
            
            NSError *error = [NSError errorWithDomain:TRWErrorDomain code:ResponseServerError userInfo:@{}];
            if (weakSelf.operationErrorHandler)
            {
                weakSelf.operationErrorHandler(error);
            }
            return;
        }

        MCLog(@"Response:%@", [[NSString alloc] initWithData:responseObject encoding:NSUTF8StringEncoding]);
        NSError *jsonError = nil;

        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseObject options:0 error:&jsonError];
        if (jsonError) {
            MCLog(@"Error:%@", jsonError);
            [self logState: @"Failure (Bad Reponse JSON)"];
            NSError *error = [NSError errorWithDomain:TRWErrorDomain code:ResponseFormatError userInfo:@{NSUnderlyingErrorKey : jsonError}];
            if (weakSelf.operationErrorHandler)
            {
                weakSelf.operationErrorHandler(error);
            }
            return;
        }
        if(weakSelf.operationSuccessHandler)
        {
            weakSelf.operationSuccessHandler(response);
        }
        
        [self logState: @"Success"];
    } failure:^(AFHTTPRequestOperation *op, NSError *error) {
     
		if (self.hasBeenCancelled) {
                    [self logState: @"Cancelled"];
			return;
		}
        
        MCLog(@"Error:%@", error);
        if (op.response.statusCode == 410) {
            
            [self logState: @"Failure (410)"];
            NSError *createdError = [NSError errorWithDomain:TRWErrorDomain code:ResponseCallGoneError userInfo:@{}];
            if (weakSelf.operationErrorHandler)
            {
                weakSelf.operationErrorHandler(createdError);
            }
            return;
        }
        
        NSData *responseData = [op responseData];
        
        if ([responseData length] == 0) {
            MCLog(@"No recovery information");
            [self logState: @"Failure (No data)"];
            if (weakSelf.operationErrorHandler)
            {
                weakSelf.operationErrorHandler(error);
            }
            return;
        }

        NSError *jsonError = nil;
        NSDictionary *response = [NSJSONSerialization JSONObjectWithData:responseData options:0 error:&jsonError];
        if (jsonError) {
            [self logState: @"Failure (Bad Error JSON)"];
            MCLog(@"Error JSON read error:%@", jsonError);
            if (weakSelf.operationErrorHandler)
            {
                weakSelf.operationErrorHandler(error);
            }
        } else {
            [self logState: @"Failure (Unknown)"];
            [weakSelf handleErrorResponseData:response];
        }
    }];
    if(self.uploadProgressHandler)
    {
        [operation setUploadProgressBlock:self.uploadProgressHandler];
    }
    [[TransferwiseClient sharedClient].operationQueue addOperation:operation];
}

- (void)handleErrorResponseData:(NSDictionary *)errorData {
    id errors = errorData[@"errors"];
    if ([errors isKindOfClass:[NSDictionary class]]) {
        errors = @[errors];
    } else if (!errors) {
        errors = @[errorData];
    }

    NSArray *handledErrors = errors;

    MCLog(@"Received %lu errors", (unsigned long)[handledErrors count]);

    NSError *cumulativeError = [self createCumulativeError:handledErrors];
    if ([self containsExpiredTokenError:handledErrors]) {
        MCLog(@"Expired token error");
        //TODO jaanus: Do other action also need given error?
        //This if is added here because most operations don't need this error. Screen where user was on
        //will be covered by login view controller.
        self.operationErrorHandler([self isCurrencyPairsOperation] ? cumulativeError : nil);
        
        //Cancel all outstanding operations if the token is expired
        [[TransferwiseClient sharedClient].operationQueue cancelAllOperations];

        dispatch_async(dispatch_get_main_queue(), ^{
            [AuthenticationHelper logOutWithObjectModel:self.objectModel tokenNeedsClearing:NO completionBlock:^{
                }];
        });
        } else {
        MCLog(@"Other errors");
        self.operationErrorHandler(cumulativeError);
    }
}

#pragma mark - Helpers
+ (void)provideAuthenticationHeaders:(NSMutableURLRequest *)request
						 isAnonymous:(BOOL)isAnonymous
{
    if (!isAnonymous && [Credentials userLoggedIn])
	{
        [request setValue:[Credentials accessToken]
	   forHTTPHeaderField:@"X-Authorization-token"];
    }

    [request setValue:TRWApplicationKey
   forHTTPHeaderField:@"X-Authorization-key"];
    [request setValue:[[[GAI sharedInstance] defaultTracker] get:kGAIClientId]
   forHTTPHeaderField:@"Customer-identifier"];
}

+ (void)provideLanguageHeader:(NSMutableURLRequest *)request
{
	[request setValue:[LocationHelper getLanguage]
   forHTTPHeaderField:@"X-language"];
}

- (BOOL)isCurrencyPairsOperation
{
    return [self isKindOfClass:[CurrencyPairsOperation class]];
}

- (NSError *)createCumulativeError:(NSArray *)errors
{
    //TODO jaanus: maybe can improve this
    NSDictionary *userInfo = @{TRWErrors: errors};
    NSError *error = [[NSError alloc] initWithDomain:TRWErrorDomain code:ResponseCumulativeError userInfo:userInfo];
    return error;
}

- (BOOL)containsExpiredTokenError:(NSArray *)errors
{
    for (NSDictionary *data in errors)
	{
        NSString *code = data[@"code"];
        if ([TRWNetworkErrorExpiredToken isEqualToString:code])
		{
            return YES;
        }
		else if ([TRWNetworkErrorInvalidToken isEqualToString:code])
		{
            return YES;
        }
		else if ([TRWNetworkErrorNoToken isEqualToString:code])
		{
            return YES;
        }
    }

    return NO;
}

- (NSString *)addTokenToPath:(NSString *)path
{
    path = [NSString stringWithFormat:@"/%@%@",[self apiVersion],path];
    return [[TransferwiseClient sharedClient] addTokenToPath:path];
}

- (ObjectModel *)workModel
{
    MCAssert(self.objectModel);

    if (!_workModel)
	{
        _workModel = [self.objectModel spawnBackgroundInstance];
    }
    return _workModel;
}

+ (NSURLRequest*)getRequestForApiPath:(NSString*)path
						   parameters:(NSDictionary*)params
{
    NSString *tokenizedPath = [[TransferwiseClient sharedClient] addTokenToPath:path];
    NSMutableURLRequest *request = [[TransferwiseClient sharedClient] requestWithMethod:@"GET"
																				   path:tokenizedPath
																			 parameters:params];
    [TransferwiseOperation provideAuthenticationHeaders:request
											isAnonymous:NO];
    return request;
}

- (NSString*)apiVersion
{
    return @"v1";
}

- (void)cancel
{
	self.hasBeenCancelled = YES;
}

#pragma mark - Logging

- (void) logState: (NSString *) state
{
    NSString *currentClassName = NSStringFromClass([self class]);
    CLSLog(@"NetOp(%d): %@ %@", self.instanceNumber, currentClassName, state);
}

@end
