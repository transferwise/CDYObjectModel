//
//  InsetRespectingButton.m
//  Transfer
//
//  Created by Mats Trovik on 28/05/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "InsetRespectingButton.h"

@implementation InsetRespectingButton

-(CGSize)intrinsicContentSize
{
    CGSize s = [super intrinsicContentSize];
    
    return CGSizeMake(s.width + self.titleEdgeInsets.left + self.titleEdgeInsets.right,
                      s.height + self.titleEdgeInsets.top + self.titleEdgeInsets.bottom);

}

@end
