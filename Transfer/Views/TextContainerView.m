//
//  TextContainerView.m
//  Transfer
//
//  Created by Jaanus Siim on 9/20/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "TextContainerView.h"
#import "UIColor+Theme.h"

@interface TextContainerView ()

@property (nonatomic, strong) IBOutlet UITextView *textView;

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

    [self.textView setTextColor:[UIColor mainTextColor]];
}


- (void)adjustHeight {
    CGRect textFrame = self.textView.frame;
    CGFloat perfectHeight = [self.textView sizeThatFits:CGSizeMake(CGRectGetWidth(textFrame), CGFLOAT_MAX)].height;
    CGFloat heightChange = perfectHeight - CGRectGetHeight(textFrame);
    textFrame.size.height += heightChange;
    [self.textView setFrame:textFrame];

    CGRect myFrame = self.frame;
    myFrame.size.height += heightChange;
    [self setFrame:myFrame];
}

@end
