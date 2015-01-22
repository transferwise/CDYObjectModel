//
//  TransferWaitingViewController.h
//  Transfer
//
//  Created by Juhan Hion on 13.06.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferDetailsViewController.h"
@class ObjectModel;

@interface TransferWaitingViewController : TransferDetailsViewController

/**
 *  Convenience method for getting an instance of this screen for use in the payment flow
 *
 *  @param payment     the payment to display
 *  @param objectModel the object model the payment comes from
 *
 *  @return configured instance ready to show
 */
+(instancetype)endOfFlowInstanceForPayment:(Payment*)payment objectModel:(ObjectModel*)objectModel;

@end
