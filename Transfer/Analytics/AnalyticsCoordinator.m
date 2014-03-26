//
//  AnalyticsCoordinator.m
//  Transfer
//
//  Created by Jaanus Siim on 26/03/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "AnalyticsCoordinator.h"
#import "Constants.h"

@interface AnalyticsCoordinator ()

@property (nonatomic, strong) NSMutableArray *services;

@end

@implementation AnalyticsCoordinator

+ (AnalyticsCoordinator *)sharedInstance {
    DEFINE_SHARED_INSTANCE_USING_BLOCK(^{
        return [[self alloc] initSingleton];
    });
}

- (id)initSingleton {
    self = [super init];
    if (self) {
        _services = [NSMutableArray array];
    }

    return self;
}

- (id)init {
    @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                   reason:[NSString stringWithFormat:@"You must use [%@ %@] instead",
                                                                     NSStringFromClass([self class]),
                                                                     NSStringFromSelector(@selector(sharedClient))]
                                 userInfo:nil];
    return nil;
}

- (void)addAnalyticsService:(id <TransferAnalytics>)service {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.services addObject:service];
    });
}

- (void)startScreenShown {
    [self sendMessageToServices:_cmd];
}

- (void)markLoggedIn {
    [self sendMessageToServices:_cmd];
}

- (void)confirmPaymentScreenShown {
    [self sendMessageToServices:_cmd];
}

- (void)didCreateTransferWithProceeds:(NSDecimalNumber *)proceeds currency:(NSString *)currencyCode {
    [self sendMessageToServices:_cmd withArguments:@[proceeds, currencyCode]];
}

- (void)paymentPersonalProfileScreenShown {
    [self sendMessageToServices:_cmd];
}

- (void)paymentRecipientProfileScreenShown {
    [self sendMessageToServices:_cmd];
}

- (void)sendMessageToServices:(SEL)message {
    [self sendMessageToServices:message withArguments:@[]];
}

- (void)sendMessageToServices:(SEL)message withArguments:(NSArray *)arguments {
    dispatch_async(dispatch_get_main_queue(), ^{
        NSInvocation *invocation = [[NSInvocation alloc] init];
        [invocation setSelector:message];
        for (NSUInteger index = 0; index < arguments.count; index++) {
            id argument = arguments[index];
            [invocation setArgument:&argument atIndex:index];
        }

        for (id<TransferAnalytics> service in self.services) {
            [invocation invokeWithTarget:service];
        }
    });
}

@end
