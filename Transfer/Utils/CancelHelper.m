//
//  CancelHelper.m
//  Transfer
//
//  Created by Mats Trovik on 16/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "CancelHelper.h"
#import "Recipient.h"
#import "PaymentCancelOperation.h"
#import <objc/runtime.h>
#import "TRWProgressHUD.h"

@interface CancelHelper ()

@property (nonatomic,copy)TRWActionBlock dontCancelBlock;
@property (nonatomic,copy)CancelPaymentResultBlock cancelBlock;
@property (nonatomic, strong)PaymentCancelOperation *cancelOperation;
@property (nonatomic, weak) UIViewController* host;

@end

@implementation CancelHelper

+ (void)cancelPayment:(Payment *)payment host:(UIViewController*)host objectModel:(ObjectModel*)model
		  cancelBlock:(CancelPaymentResultBlock)cancelBlock
	  dontCancelBlock:(TRWActionBlock)dontCancelBlock
{
    CancelHelper *cancelHelper = [[CancelHelper alloc] init];
    cancelHelper.cancelBlock = cancelBlock;
    cancelHelper.dontCancelBlock = dontCancelBlock;
    [cancelHelper attachToHost:host];
	TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"transactions.cancel.confirmation.title", nil)
													   message:[NSString stringWithFormat:NSLocalizedString(@"transactions.cancel.confirmation.message", nil), [payment.recipient name]]];
	[alertView setLeftButtonTitle:NSLocalizedString(@"button.title.no", nil) rightButtonTitle:NSLocalizedString(@"button.title.yes", nil)];
	
	[alertView setRightButtonAction:^{
		if(cancelHelper.cancelBlock)
		{
			[cancelHelper cancelPayment:payment objectModel:model];
		}
	}];
	[alertView setLeftButtonAction:^{
		if (cancelHelper.dontCancelBlock)
		{
			cancelHelper.dontCancelBlock();
            [cancelHelper detachFromHost];
		}
	}];
	
	[alertView show];
}

-(void)cancelPayment:(Payment *)payment objectModel:(ObjectModel*)model
{
    UIViewController* hudHost = self.host.navigationController?:self.host;
    TRWProgressHUD *hud = [TRWProgressHUD showHUDOnView:hudHost.view];
    [hud setMessage:NSLocalizedString(@"transactions.cancel.progress.title", nil)];
	PaymentCancelOperation* cancelOperation = [PaymentCancelOperation operationWithPayment:payment];
    cancelOperation.objectModel = model;\
    __weak typeof(self) weakSelf = self;
    cancelOperation.responseHandler = ^(NSError* error){
        [hud hide];
        if(error)
        {
            TRWAlertView *alertView = [TRWAlertView alertViewWithTitle:NSLocalizedString(@"transactions.cancel.fail.title", nil)
                                                               message:[NSString stringWithFormat:NSLocalizedString(@"transactions.cancel.fail.message", nil), [payment.recipient name]]];
            [alertView setConfirmButtonTitle:NSLocalizedString(@"button.title.ok",nil)];
            [alertView show];
        }
        else
        {
            payment = PaymentStatusCancelled;
        }
        if(weakSelf.cancelBlock)
        {
            weakSelf.cancelBlock(error);
        }
        [weakSelf detachFromHost];
    };
    self.cancelOperation = cancelOperation;
    [cancelOperation execute];
}

-(void)attachToHost:(id)host
{
    objc_setAssociatedObject(host, @selector(attachToHost:), self, OBJC_ASSOCIATION_RETAIN);
    self.host = host;
}

-(void)detachFromHost
{
    if(self.host)
    {
        objc_setAssociatedObject(self.host, @selector(attachToHost:), nil, OBJC_ASSOCIATION_RETAIN);
        self.host = nil;
    }
}

@end
