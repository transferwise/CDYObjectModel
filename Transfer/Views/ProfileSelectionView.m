//
//  ProfileSelectionView.m
//  Transfer
//
//  Created by Jaanus Siim on 6/14/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <OHAttributedLabel/OHAttributedLabel.h>
#import "ProfileSelectionView.h"
#import "ProfileSource.h"
#import "PersonalProfileSource.h"
#import "Constants.h"
#import "BusinessProfileSource.h"

@interface ProfileSelectionView ()

@property (nonatomic, strong) IBOutlet OHAttributedLabel *label;
@property (nonatomic, strong) ProfileSource *presentedSource;
@property (nonatomic, strong) PersonalProfileSource *personalSource;
@property (nonatomic, strong) BusinessProfileSource *businessSource;

@end

@implementation ProfileSelectionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setPersonalSource:[[PersonalProfileSource alloc] init]];
    [self setBusinessSource:[[BusinessProfileSource alloc] init]];
    [self setPresentedSource:self.personalSource];
    [self updatePresentationForSource];

    UITapGestureRecognizer *tapGestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapped)];
    [tapGestureRecognizer setNumberOfTapsRequired:1];
    [tapGestureRecognizer setNumberOfTouchesRequired:1];
    [self addGestureRecognizer:tapGestureRecognizer];
}

- (void)tapped {
    MCLog(@"tapped");
    if (self.presentedSource == self.personalSource) {
        [self setPresentedSource:self.businessSource];
    } else {
        [self setPresentedSource:self.personalSource];
    }

    self.selectionHandler(self.presentedSource);
    [self updatePresentationForSource];
}

- (void)updatePresentationForSource {
    if (self.presentedSource == self.personalSource) {
        [self presentString:NSLocalizedString(@"profile.selection.text.business.profile", nil)];
    } else {
        [self presentString:NSLocalizedString(@"profile.selection.text.personal.profile", nil)];
    }
}

- (void)presentString:(NSString *)presented {
    NSString *txt = [NSString stringWithFormat:NSLocalizedString(@"profile.selection.text.base", nil), presented];
    NSMutableAttributedString *attrStr = [NSMutableAttributedString attributedStringWithString:txt];

    OHParagraphStyle *paragraphStyle = [OHParagraphStyle defaultParagraphStyle];
    paragraphStyle.textAlignment = kCTTextAlignmentCenter;
    paragraphStyle.lineBreakMode = kCTLineBreakByWordWrapping;
    [attrStr setParagraphStyle:paragraphStyle];
    [attrStr setFont:[UIFont boldSystemFontOfSize:14]];
    [attrStr setTextColor:[UIColor blackColor]];
    [attrStr addAttribute:(NSString*)kCTUnderlineStyleAttributeName  value:[NSNumber numberWithInt:kCTUnderlineStyleSingle]  range:[txt rangeOfString:presented]];

    [self.label setAttributedText:attrStr];
}

@end
