//
//  UploadVerificationFileOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 5/30/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TransferwiseOperation.h"

typedef void (^FileUploadBlock)(NSError *error);

@interface UploadVerificationFileOperation : TransferwiseOperation

@property (nonatomic, copy) FileUploadBlock completionHandler;

+ (id)verifyOperationFor:(NSString *)verification filePath:(NSString *)filePath;

@end
