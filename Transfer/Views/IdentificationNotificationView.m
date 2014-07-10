//
//  IdentificationNotificationView.m
//  Transfer
//
//  Created by Jaanus Siim on 9/18/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "IdentificationNotificationView.h"
#import "OHAttributedLabel.h"
#import "UIColor+Theme.h"

@interface IdentificationNotificationView ()

@property (nonatomic, strong) IBOutlet UILabel *messageLabel;
@property (nonatomic, strong) IBOutlet OHAttributedLabel *linkLabel;
@property (nonatomic, strong) IBOutlet UIView *bottomBackground;

@end

@implementation IdentificationNotificationView

- (id)initWithFrame:(CGRect)frame {
	self = [super initWithFrame:frame];
	if (self) {
		// Initialization code
	}
	return self;
}

- (void)awakeFromNib {
	[super awakeFromNib];

	[self.messageLabel setText:NSLocalizedString(@"transactions.identification.notification.message", nil)];
	[self.messageLabel setTextColor:[UIColor DarkFontColor]];

	[self.bottomBackground setBackgroundColor:[UIColor controllerBackgroundColor]];

	NSString *txt = NSLocalizedString(@"transactions.identification.upload.message", nil);
	NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:txt];

	OHParagraphStyle *paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
	paragraphStyle.textAlignment = kCTTextAlignmentCenter;
	paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
	[attrStr setParagraphStyle:paragraphStyle];
	[attrStr setFont:[UIFont boldSystemFontOfSize:13]];
	[attrStr setTextColor:[UIColor blackColor]];
	[attrStr addAttribute:(NSString*)kCTUnderlineStyleAttributeName  value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]  range:NSMakeRange(0, [txt length])];
	[self.linkLabel setAttributedText:attrStr];

	UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
	[tapGestureRecognizer setNumberOfTapsRequired:1];
	[tapGestureRecognizer setNumberOfTouchesRequired:1];
	[self.bottomBackground addGestureRecognizer:tapGestureRecognizer];
}

- (void)tapped {
	self.tapHandler();
}

@end
