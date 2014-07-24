//
//  DoublePasswordEntryCellTableViewCell.h
//  Transfer
//
//  Created by Juhan Hion on 24.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DoublePasswordEntryCellTableViewCell : UITableViewCell

@property (nonatomic, readonly) NSString* value;
@property (nonatomic) BOOL showDouble;
@property (nonatomic, readonly) BOOL areMatching;
@property (nonatomic) BOOL useDummyPassword;

- (void)setDummyPassword;

@end
