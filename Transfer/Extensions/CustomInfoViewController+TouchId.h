//
//  CustomInfoViewController+TouchId.h
//  Transfer
//
//  Created by Mats Trovik on 14/04/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "CustomInfoViewController.h"

@interface CustomInfoViewController (TouchId)

+(instancetype)touchIdCustomInfoWithUsername:(NSString*)username password:(NSString*)password completionBlock:(void(^)(void))completionBlock;


@end
