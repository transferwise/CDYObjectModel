//
//  CustomInfoViewController.h
//  Transfer
//
//  Created by Mats Trovik on 09/09/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransparentModalViewController.h"

typedef void(^ActionButtonBlock)(void);

@interface CustomInfoViewController : TransparentModalViewController

@property (nonatomic, copy) NSString *titleText;
@property (nonatomic, copy) NSString *infoText;
@property (nonatomic, strong) UIImage *infoImage;

/**
 *  Array of action buttons. Must be assigned in code or in xib.
 */
@property (nonatomic, strong) IBOutletCollection(UIButton)NSArray *actionButtons;

/**
 *  Array of titles to assign to the action buttons. Object must be NSString or title is set empty.
 */
@property (nonatomic, copy) NSArray *actionButtonTitles;

/**
 *  Set to override the behaviour when the action buttons are tapped. Order should match order of buttons in actionButtons. 
 *  Objects in array *MUST* be of type ActionButtonBlock or NSNull. NSNull automatically dismisses.
 */
@property (nonatomic,copy) NSArray *actionButtonBlocks;

/**
 *  set to the index of an action button to make the close button invoke the associated actionButtonBlock rather than just dismiss.
 */
@property (nonatomic,assign) NSUInteger mapCloseButtonToActionIndex;

/**
 *  Invokes the actionButtonBlock for an action button.
 */
-(IBAction)actionButtonTapped:(UIButton*)target;

/**
 *  convenince method for getting an instance with a green tick and mapCloseToAction set to YES.
 *
 *  @param messageKey message. An attempt will be made to get the localised version.
 *
 *  @return green tick screen with your message
 */
+(instancetype)successScreenWithMessage:(NSString*)messageKey;

/**
 *  convenince method for getting an instance with a red cross and mapCloseToAction set to YES.
 *
 *  @param messageKey message. An attempt will be made to get the localised version.
 *
 *  @return red cross screen with your message
 */
+(instancetype)failScreenWithMessage:(NSString*)messageKey;
@end
