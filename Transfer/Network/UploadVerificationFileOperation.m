//
//  UploadVerificationFileOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/30/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "UploadVerificationFileOperation.h"
#import "TransferwiseOperation+Private.h"

NSString *const kUploadPath = @"/verification/uploadFile";

@interface UploadVerificationFileOperation ()

@property (nonatomic, copy) NSString *verification;
@property (nonatomic, copy) NSString *filePath;

@end

@implementation UploadVerificationFileOperation

- (id)initWithVerification:(NSString *)verification filePath:(NSString *)filePath {
    if (self) {
        _verification = verification;
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

    [self setOperationSuccessHandler:^(NSDictionary *response) {
        weakSelf.completionHandler(nil);
    }];

    [self postBinaryDataFromFile:self.filePath withName:@"file" usingParams:@{@"verification" : self.verification} toPath:path];
}

+ (UploadVerificationFileOperation *)verifyOperationFor:(NSString *)verification filePath:(NSString *)filePath {
    return [[UploadVerificationFileOperation alloc] initWithVerification:verification filePath:filePath];
}

@end
