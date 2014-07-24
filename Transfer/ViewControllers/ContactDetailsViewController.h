//
//  ContactDetailsViewController.h
//  Transfer
//
//  Created by Mats Trovik on 17/07/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ContactDetailsViewController;
@class Recipient;

@protocol ContactDetailsDeleteDelegate <NSObject>

-(void)contactDetailsController:(ContactDetailsViewController*)controller didDeleteContact:(Recipient*)deletedRecipient;

@end

@class ObjectModel;

@interface ContactDetailsViewController : UIViewController

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong) Recipient *recipient;

@property (nonatomic, weak) id<ContactDetailsDeleteDelegate>deletionDelegate;

@end
