//
//  RegisterOperation.m
//  Transfer
//
//  Created by Jaanus Siim on 5/17/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "RegisterOperation.h"
#import "TransferwiseOperation+Private.h"
#import "Credentials.h"
#import "ObjectModel+Users.h"
#import "Mixpanel+Customisation.h"
#import "Constants.h"

NSString *const kRegisterPath = @"/account/register";

@interface RegisterOperation ()

@property (nonatomic, copy) NSString *email;
@property (nonatomic, copy) NSString *password;

@end

@implementation RegisterOperation

- (id)initWithEmail:(NSString *)email password:(NSString *)password
{
    self = [super init];
    if (self)
	{
        _email = email;
        _password = password;
    }
    return self;
}

- (void)execute
{
    NSString *path = [self addTokenToPath:kRegisterPath];

    __block __weak RegisterOperation *weakSelf = self;

    [self setOperationErrorHandler:^(NSError *error) {
        weakSelf.completionHandler(error);
    }];
	
    [self setOperationSuccessHandler:^(NSDictionary *response) {
        [weakSelf.workModel performBlock:^{
            NSString *token = response[@"token"];
            if ([token isKindOfClass:[NSDictionary class]]) {
                token = response[@"token"][@"value"];
            }
            [Credentials setUserToken:token];
            [Credentials setUserSecret:response[@"secret"]];
            [Credentials setUserEmail:weakSelf.email];
			
            [weakSelf.workModel markAnonUserWithEmail:weakSelf.email];
            [weakSelf.workModel saveContext:^{
                weakSelf.completionHandler(nil);
            }];
        }];
        [[Mixpanel sharedInstance] track:MPUserregistered];
    }];

    NSMutableDictionary* parameters = [@{@"email" : self.email, @"password" : self.password} mutableCopy];
    NSUserDefaults* defaults = [NSUserDefaults standardUserDefaults];
    NSString* referrer = [defaults objectForKey:TRWReferralTokenKey];
    if(referrer)
    {
        parameters[TRWReferralTokenKey] = referrer;
    }
    NSString* source = [defaults objectForKey:TRWReferralSourceKey];
    if(source)
    {
        parameters[TRWReferralSourceKey] = source;
    }
    [self postData:parameters toPath:path];
}

+ (RegisterOperation *)operationWithEmail:(NSString *)email password:(NSString *)password
{
    return [[RegisterOperation alloc] initWithEmail:email password:password];
}

@end
