//
//  DataEntryDefaultHeader.h
//  Transfer
//
//  Created by Mats Trovik on 18/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DataEntryDefaultHeader : UIView

@property (weak, nonatomic) IBOutlet UILabel *titleLabel;

+(instancetype)instance;

@end
