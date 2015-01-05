//
//  EmailValidation.h
//  Transfer
//
//  Created by Juhan Hion on 15.12.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^EmailValidationResultBlock)(BOOL available, NSError *error);

@protocol EmailValidation <NSObject>

- (void)verifyEmail:(NSString *)email
	withResultBlock:(EmailValidationResultBlock)resultBlock;

@end
