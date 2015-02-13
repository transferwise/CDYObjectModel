//
//  CaptchaCell.m
//  Transfer
//
//  Created by Juhan Hion on 13.02.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import "CaptchaCell.h"
#import "RecipientTypeField.h"

NSString *const TWCaptchaCellIdentifier = @"TWCaptchaCellIdentifier";

@interface CaptchaCell ()

@property (strong, nonatomic) IBOutlet UIImageView *captchaView;

@end

@implementation CaptchaCell

- (void)setFieldType:(RecipientTypeField *)field
{
	[super setFieldType:field];
	
	NSURL* dataUrl = [NSURL URLWithString:field.image];
	NSData *imageData = [NSData dataWithContentsOfURL:dataUrl];
	self.captchaView.image = [[UIImage alloc] initWithData:imageData];
}

@end
