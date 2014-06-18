//
//  DataEntryDefaultHeader.m
//  Transfer
//
//  Created by Mats Trovik on 18/06/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "DataEntryDefaultHeader.h"

@interface DataEntryDefaultHeader ()


@end

@implementation DataEntryDefaultHeader

+(instancetype)instance
{
    return [[NSBundle mainBundle] loadNibNamed:@"DataEntryDefaultHeader" owner:nil options:nil][0];
}



@end
