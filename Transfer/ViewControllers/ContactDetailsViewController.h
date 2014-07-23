//
//  ContactDetailsViewController.h
//  Transfer
//
//  Created by Mats Trovik on 17/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Recipient.h"

@interface ContactDetailsViewController : UIViewController

@property (nonatomic, strong) Recipient *recipient;

@end
