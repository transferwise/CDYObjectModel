//
//  PresentationCell.m
//  Transfer
//
//  Created by Mats Trovik on 28/01/2015.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "PresentationCell.h"


@implementation PresentationCell

- (void)setTitles:(NSString*)title,...
{
    NSMutableArray* titles = [NSMutableArray array];
    if(title)
    {
        [titles addObject:title];
    }
    va_list args;
    va_start(args, title);
    NSString* arg = nil;
    while ((arg = va_arg(args,NSString*))) {
        [titles addObject:arg];
    }
    va_end(args);
    
    [self setTexts:titles onLabels:self.titleLabels];
}


- (void)setValues:(NSString*)value,...
{
    NSMutableArray* values = [NSMutableArray array];
    if(value)
    {
        [values addObject:value];
    }
    va_list args;
    va_start(args, value);
    NSString* arg = nil;
    while ((arg = va_arg(args,NSString*))) {
        [values addObject:arg];
    }
    va_end(args);
    
    [self setTexts:values onLabels:self.valueLabels];
}


-(void)setTexts:(NSArray*)texts onLabels:(NSArray*)labels
{
    NSUInteger labelCount = [labels count];
    NSUInteger textCount = [texts count];
    
    for(int i = 0; i < labelCount; i++)
    {
        ((UILabel*)labels[i]).text = i < textCount?texts[i]:@"";
    }
}

@end
