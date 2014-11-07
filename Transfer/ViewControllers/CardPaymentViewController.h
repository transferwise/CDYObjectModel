//
//  CardPaymentViewController.h
//  Transfer
//
//  Created by Jaanus Siim on 9/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Payment;
@class ObjectModel;

typedef void (^CardPaymentResultBlock)(BOOL success);

typedef enum
{
    URLActionContinueLoad,
    URLActionAbortLoad,
    URLActionAbortAndReportSuccess,
    URLActionAbortAndReportFailure
} URLAction;

typedef URLAction (^ShouldLoadURLBlock)(NSURL *url);
typedef void (^LoadRequestBlock)(NSURLRequest *request);
typedef void (^InitialRequestBlock)(LoadRequestBlock callback);

@interface CardPaymentViewController : UIViewController

@property (nonatomic, copy) CardPaymentResultBlock resultHandler;
@property (nonatomic, strong) Payment *payment;
@property (nonatomic, strong) ObjectModel *objectModel;

/**
 *  called to check whether a URL should be loaded or not. Implement logic for detecting success/ failure etc. in here.
 */
@property (nonatomic, copy) ShouldLoadURLBlock loadURLBlock;

/**
 *  Block that is called to request a NSURLRequest to load as the first screen of the debit card process. 
 *
 *  The provided callback LoadRequestBlock allows for the request to be supplied directly, or after an initial asynchronous operation.
 */
@property (nonatomic, copy) InitialRequestBlock initialRequestProvider;

- (void)loadCardView;

@end
