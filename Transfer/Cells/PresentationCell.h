//
//  PresentationCell.h
//  Transfer
//
//  Created by Mats Trovik on 28/01/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface PresentationCell : UITableViewCell

@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *titleLabels;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *valueLabels;

- (void)setTitles:(NSString*)title,... NS_REQUIRES_NIL_TERMINATION;
- (void)setValues:(NSString*)value,... NS_REQUIRES_NIL_TERMINATION;


@end
