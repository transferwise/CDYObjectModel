//
//  ApplePayCell.h
//  Transfer
//
//  Created by Juhan Hion on 09/07/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ApplePayCell;

@protocol ApplePayCellDelegate <NSObject>

-(void)actionButtonTappedOnCell:(ApplePayCell*)cell;

@end

@interface ApplePayCell : UITableViewCell

@property (nonatomic, weak) id<ApplePayCellDelegate> applePayCellDelegate;

@end
