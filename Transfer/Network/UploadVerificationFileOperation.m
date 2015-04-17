//
//  UploadVerificationFileOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/30/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UploadVerificationFileOperation.h"
#import "TransferwiseOperation+Private.h"
#import "GoogleAnalytics.h"
#import "Constants.h"

NSString *const kUploadPath = @"/verification/uploadFile";

@interface UploadVerificationFileOperation ()

@property (nonatomic, copy) NSString *verification;
@property (nonatomic, copy) NSString *profile;
@property (nonatomic, copy) NSString *filePath;

@end

@implementation UploadVerificationFileOperation

- (id)initWithVerification:(NSString *)verification profile:(NSString *)profile filePath:(NSString *)filePath {
    if (self) {
        _verification = verification;
        _profile = profile;
        _filePath = filePath;
    }
    return self;
}

- (void)execute {
    NSString *path = [self addTokenToPath:kUploadPath];

    __block __weak UploadVerificationFileOperation *weakSelf = self;
    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.completionHandler(error);
    }];
    [self setUploadProgressHandler:^(NSUInteger bytes, long long totalBytes, long long totalBytesExpected) {
        float progress = 1.0f*totalBytes/totalBytesExpected;
        NSDictionary* userInfo = @{TRWUploadProgressKey:@(progress),TRWUploadFileKey:weakSelf.verification};
        [[NSNotificationCenter defaultCenter] postNotificationName:TRWUploadProgressNotification object:nil userInfo:userInfo];
    }];
    
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [[GoogleAnalytics sharedInstance] sendAppEvent:GAFileuploaded];
        weakSelf.completionHandler(nil);
    }];

    [self postBinaryDataFromFile:self.filePath withName:@"file" usingParams:@{@"verification" : self.verification, @"profile": self.profile} toPath:path];
}

+ (id)verifyOperationFor:(NSString *)verification profile:(NSString *)profile filePath:(NSString *)filePath {
    return [[UploadVerificationFileOperation alloc] initWithVerification:verification profile:profile filePath:filePath];
}

@end
