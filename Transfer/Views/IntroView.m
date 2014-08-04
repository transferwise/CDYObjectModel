//
//  IntroView.m
//  Transfer
//
//  Created by Jaanus Siim on 9/20/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "IntroView.h"
#import "MOMStyle.h"


@interface IntroView ()

@property (nonatomic, strong) IBOutlet UIImageView *introImage;
@property (nonatomic, strong) IBOutlet UILabel *taglineLabel;
@property (nonatomic, strong) IBOutlet UILabel *messageLabel;

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
    [self.taglineLabel setText:NSLocalizedString(dictionary[@"titleRef"],nil)];
    [self.messageLabel setText:NSLocalizedString(dictionary[@"textRef"],nil)];
    self.bgStyle = dictionary[@"bgStyle"];
    self.taglineLabel.fontStyle = dictionary[@"titleFontStyle"];
    self.messageLabel.fontStyle = dictionary[@"textFontStyle"];
}

@end
