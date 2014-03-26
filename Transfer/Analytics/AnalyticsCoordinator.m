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
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<TransferAnalytics> service in self.services) {
            [service didCreateTransferWithProceeds:proceeds currency:currencyCode];
        }
    });
}

- (void)paymentPersonalProfileScreenShown {
    [self sendMessageToServices:_cmd];
}

- (void)paymentRecipientProfileScreenShown {
    [self sendMessageToServices:_cmd];
}

- (void)sendMessageToServices:(SEL)message {
    dispatch_async(dispatch_get_main_queue(), ^{
        for (id<TransferAnalytics> service in self.services) {
            [service performSelector:message];
        }
    });
}

@end
