//
//  TextContainerView.m
//  Transfer
//
//  Created by Jaanus Siim on 9/20/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TextContainerView.h"

@interface TextContainerView ()

@property (nonatomic, strong) IBOutlet UILabel *textLabel;

@end

@implementation TextContainerView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self.textLabel setTextColor:[UIColor DarkFontColor]];
}


- (void)adjustHeight {
    CGRect textFrame = self.textLabel.frame;
    CGFloat perfectHeight = [self.textLabel sizeThatFits:CGSizeMake(CGRectGetWidth(textFrame), CGFLOAT_MAX)].height;
    CGFloat heightChange = perfectHeight - CGRectGetHeight(textFrame);
    textFrame.size.height += heightChange;
    [self.textLabel setFrame:textFrame];

    CGRect myFrame = self.frame;
    myFrame.size.height += heightChange;
    [self setFrame:myFrame];
}

- (void)setText:(NSString *)text {
    [self.textLabel setText:text];
}

@end
