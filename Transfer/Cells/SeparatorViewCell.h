//
//  SeparatorViewCell.h
//  Transfer
//
//  Created by Juhan Hion on 26.08.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SeparatorViewCell : UITableViewCell

@property (nonatomic, strong) IBOutlet UIView *separatorLine;
@property (nonatomic, assign) BOOL showFullWidth;

@end
