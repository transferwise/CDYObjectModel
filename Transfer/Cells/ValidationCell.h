//
//  ValidationCell.h
//  Transfer
//
//  Created by Mats Trovik on 12/08/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

#define ValidationCellIdentifier @"ValidationCell"

@class ValidationCell;

@protocol ValidationCellDelegate <NSObject>

@optional
-(void)actionTappedOnValidationCell:(ValidationCell*)cell;
-(void)deleteTappedOnValidationCell:(ValidationCell*)cell;

@end

@interface ValidationCell : UITableViewCell

@property (nonatomic,weak) id<ValidationCellDelegate>delegate;

-(void)configureWithButtonTitle:(NSString*)buttonTitle buttonImage:(UIImage*)image caption:(NSString*)caption selectedCaption:(NSString*)selectedCaption;

-(void)documentSelected:(BOOL)documentSelectedState;

-(CGFloat)requiredHeight;
@end
