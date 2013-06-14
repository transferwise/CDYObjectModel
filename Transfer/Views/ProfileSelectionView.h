//
//  ProfileSelectionView.h
//  Transfer
//
//  Created by Jaanus Siim on 6/14/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ProfileSource;

typedef void (^ProfileSelectionBlock)(ProfileSource *selected);

@interface ProfileSelectionView : UIView

@property (nonatomic, strong, readonly) ProfileSource *presentedSource;
@property (nonatomic, strong) ProfileSelectionBlock selectionHandler;

@end
