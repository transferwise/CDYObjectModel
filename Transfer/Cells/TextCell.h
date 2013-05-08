//
//  TextCell.h
//  Transfer
//
//  Created by Henri Mägi on 08.05.13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

extern NSString *const TWTextCellIdentifier;

@interface TextCell : UITableViewCell
@property (strong, nonatomic) IBOutlet UILabel *titleLabel;
@property (strong, nonatomic) IBOutlet UILabel *textLabel;

- (void)configureWithTitle:(NSString *)title text:(NSString *)text;

@end
