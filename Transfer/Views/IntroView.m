//
//  IntroView.m
//  Transfer
//
//  Created by Jaanus Siim on 9/20/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "IntroView.h"
#import "MOMStyle.h"
#import "Constants.h"


#define flagFactor 0.24337f
#define tagLineFactor 0.125f
#define messageFactor 0.04f

@interface IntroView ()

@property (nonatomic, strong) IBOutlet UIImageView *introImage;
@property (nonatomic, strong) IBOutlet UILabel *taglineLabel;
@property (nonatomic, strong) IBOutlet UILabel *messageLabel;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *flagCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tagLineCenterConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *messageLabelCenterConstraint;

@property (nonatomic, assign) CGFloat flagOffsetFactor;
@property (nonatomic, assign) CGFloat tagLineOffsetFactor;
@property (nonatomic, assign) CGFloat messageOffsetFactor;
@end

@implementation IntroView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)setUpWithDictionary:(NSDictionary*)dictionary {
    [self.introImage setImage:[UIImage imageNamed:dictionary[@"imageName"]]];
    NSMutableParagraphStyle *style = [[NSMutableParagraphStyle alloc] init];
    [style setLineSpacing:IPAD?12:7];
    [style setAlignment:NSTextAlignmentCenter];
    NSAttributedString *adjustedLineHeightTitle = [[NSAttributedString alloc] initWithString:NSLocalizedString(dictionary[@"titleRef"],nil) attributes:@{NSParagraphStyleAttributeName:style}];
    [self.taglineLabel setAttributedText:adjustedLineHeightTitle];
    [self.messageLabel setText:NSLocalizedString(dictionary[@"textRef"],nil)];

    self.backgroundColor = dictionary[@"bgStyleColor"];
    self.taglineLabel.font = dictionary[@"titleFontStyleFont"];
    self.taglineLabel.textColor = dictionary[@"titleFontStyleColor"];
    self.messageLabel.font = dictionary[@"textFontStyleFont"];
    self.messageLabel.textColor = dictionary[@"textFontStyleColor"];
    
    self.flagOffsetFactor = (IPAD?2.0f:1.0f) * flagFactor;
    self.tagLineOffsetFactor = (IPAD?2.0f:1.0f) * tagLineFactor;
    self.messageOffsetFactor = (IPAD?2.0f:1.0f) * messageFactor;
    
}

- (void)shiftCenter:(CGFloat)relativeOffset
{
    short direction = relativeOffset > 0.0f ? 1 : -1 ;
    CGFloat offset = ABS(sinf(relativeOffset * M_PI) * self.bounds.size.width) * direction;
    self.flagCenterConstraint.constant = offset * self.flagOffsetFactor;
    self.tagLineCenterConstraint.constant = offset * self.tagLineOffsetFactor;
    self.messageLabelCenterConstraint.constant = offset * self.messageOffsetFactor;
}

@end
