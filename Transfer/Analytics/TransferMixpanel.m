//
//  TransferMixpanel.m
//  Transfer
//
//  Created by Jaanus Siim on 26/03/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Mixpanel/Mixpanel.h>
#import "TransferMixpanel.h"
#import "Credentials.h"

@implementation TransferMixpanel

- (void)startScreenShown {
    [self sendPageView:@"Start screen"];
}

- (void)markLoggedIn {
    NSString *isRegistered = @"NO";
    if ([Credentials userLoggedIn]) {
        isRegistered = @"YES";
    }

    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel registerSuperProperties:@{@"IsRegistered" : isRegistered}];
}

- (void)confirmPaymentScreenShown {
    [self sendPageView:@"Confirmation"];
}

- (void)didCreatePayment:(NSDictionary *)paymentDetails {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:@"Transfer created" properties:paymentDetails];
}

- (void)paymentPersonalProfileScreenShown {
    [self sendPageView:@"Your details"];
}

- (void)paymentRecipientProfileScreenShown {
    [self sendPageView:@"Recipient details"];
}

- (void)refundDetailsScreenShown {
    //NO OP
}

- (void)refundRecipientAdded {
    //NO OP
}

- (void)sendPageView:(NSString *)page {
    Mixpanel *mixpanel = [Mixpanel sharedInstance];
    [mixpanel track:[NSString stringWithFormat:@"Page View - %@", page]];
}

@end
