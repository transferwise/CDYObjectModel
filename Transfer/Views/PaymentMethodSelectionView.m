//
//  PaymentMethodSelectionView.m
//  Transfer
//
//  Created by Jaanus Siim on 9/13/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import "PaymentMethodSelectionView.h"
#import "UIColor+Theme.h"

@interface PaymentMethodSelectionView ()

@property (nonatomic, strong) IBOutlet UISegmentedControl *segmentControl;

- (IBAction)segmentValueChanged;

@end

@implementation PaymentMethodSelectionView

- (id)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
    }
    return self;
}

- (void)awakeFromNib {
    [super awakeFromNib];

    [self setBackgroundColor:[UIColor controllerBackgroundColor]];

    [self.segmentControl setTintColor:[UIColor transferWiseBlue]];

    CGFloat segmentHeight = CGRectGetHeight(self.segmentControl.frame);
    CGRect myFrame = self.frame;
    myFrame.size.height = CGRectGetMinY(self.segmentControl.frame) * 2 + segmentHeight;
    [self setFrame:myFrame];
}

- (IBAction)segmentValueChanged {
    self.segmentChangeHandler([self.segmentControl selectedSegmentIndex]);
}

- (void)setTitles:(NSArray *)titles {
    [self.segmentControl removeAllSegments];
    NSUInteger index = 0;
    for (NSString *title in titles) {
        [self.segmentControl insertSegmentWithTitle:title atIndex:index animated:NO];
        index++;
    }
    [self.segmentControl setSelectedSegmentIndex:0];
}

@end
