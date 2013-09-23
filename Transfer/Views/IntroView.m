//
//  IntroView.m
//  Transfer
//
//  Created by Jaanus Siim on 9/20/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "IntroView.h"
#import "OHAttributedLabel.h"

@interface IntroView ()

@property (nonatomic, strong) IBOutlet UIImageView *introImage;
@property (nonatomic, strong) IBOutlet UILabel *taglineLabel;
@property (nonatomic, strong) IBOutlet OHAttributedLabel *messageLabel;

@end

@implementation IntroView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setImage:(UIImage *)image tagline:(NSString *)tagline message:(NSAttributedString *)message {
    [self.introImage setImage:image];
    [self.taglineLabel setText:tagline];
    [self.messageLabel setAttributedText:message];

    CGRect messageFrame = self.messageLabel.frame;
    CGFloat perfectMessageHeight = [self.messageLabel sizeThatFits:CGSizeMake(CGRectGetWidth(messageFrame), CGFLOAT_MAX)].height;
    messageFrame.size.height = perfectMessageHeight;
    [self.messageLabel setFrame:messageFrame];
}

@end
