//
//  CustomInfoViewController+UpdatePaymentDetails.m
//  Transfer
//
//  Created by Mats Trovik on 10/07/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "CustomInfoViewController+UpdatePaymentDetails.h"
#import "TRWProgressHUD.h"
#import "TRWAlertView.h"
#import "PullPaymentDetailsOperation.h"
#import "TransferDetailsViewController.h"
#import <objc/runtime.h>
#import "Payment.h"
#import "ObjectModel.h"
#import "PushNotificationsHelper.h"

@implementation CustomInfoViewController (UpdatePaymentDetails)

+ (void) presentCustomInfoWithSuccess: (BOOL) success
                           controller: (UIViewController *) controller
                           messageKey: (NSString *) messageKey
                              payment: (Payment*) payment
                          objectModel: (ObjectModel*) objectModel
{
    CustomInfoViewController *customInfo;
    
    if (success)
    {
        customInfo = [CustomInfoViewController successScreenWithMessage: messageKey];
        __weak typeof(customInfo) weakCustomInfo = customInfo;
        __block BOOL shouldAutoDismiss = YES;
        __block BOOL paymentDetailsCompletedSuccessfully = NO;
        __block TRWProgressHUD *hud;
        
        ActionButtonBlock action = ^{
            shouldAutoDismiss = NO;
            if(objc_getAssociatedObject(controller, @selector(presentCustomInfoWithSuccess:controller:messageKey:)))
            {
                hud = [TRWProgressHUD showHUDOnView:weakCustomInfo.view];
            }
            else
            {
                [hud hide];
                if(paymentDetailsCompletedSuccessfully)
                {
                    TransferDetailsViewController *details = [[TransferDetailsViewController alloc] init];
                    details.payment = payment;
                    details.objectModel = objectModel;
                    details.showClose = YES;
                    details.promptForNotifications = [PushNotificationsHelper shouldPresentNotificationsPrompt];
                    details.showRateTheApp = YES;
                    
                    [controller.navigationController pushViewController:details animated:NO];
                }
                else
                {
                    [[NSNotificationCenter defaultCenter] postNotificationName:TRWMoveToPaymentsListNotification object:nil userInfo:@{@"paymentId":payment.remoteId}];
                }
                [weakCustomInfo dismiss];
            }
        };
        
        customInfo.actionButtonBlocks = @[action];
        
        PullPaymentDetailsOperation *operation = [PullPaymentDetailsOperation operationWithPaymentId:[payment remoteId]];
        objc_setAssociatedObject(controller, @selector(presentCustomInfoWithSuccess:controller:messageKey:), operation, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
        [operation setObjectModel:objectModel];
        [operation setResultHandler:^(NSError *error) {
            dispatch_async(dispatch_get_main_queue(), ^{
                objc_setAssociatedObject(controller, @selector(presentCustomInfoWithSuccess:controller:messageKey:), nil, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
                
                if (!error) {
                    paymentDetailsCompletedSuccessfully = YES;
                }
                BOOL preTimerShouldDismiss = shouldAutoDismiss;
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)((shouldAutoDismiss?5:0) * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    if(preTimerShouldDismiss == shouldAutoDismiss)
                    {
                        action();
                    }
                });
            });
        }];
        [operation execute];
        
    }
    else
    {
        customInfo = [CustomInfoViewController failScreenWithMessage: messageKey];
    }
    
    // Blurry overlay
    [customInfo presentOnViewController: controller.navigationController.parentViewController
                  withPresentationStyle: TransparentPresentationFade];
    
    
}


@end
