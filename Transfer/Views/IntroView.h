//
//  IntroView.h
//  Transfer
//
//  Created by Jaanus Siim on 9/20/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IntroView : UIView

@property (nonatomic, strong) IBOutlet UILabel *taglineLabel; //Exposed in order to be able to override title.

- (void)setUpWithDictionary:(NSDictionary*)dictionary;

- (void)shiftCenter:(CGFloat)relativeOffset;

@end
