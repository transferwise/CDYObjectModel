//
//  RecipientSectionHeaderView.h
//  Transfer
//
//  Created by Jaanus Siim on 5/6/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class RecipientType;

typedef void (^RecipientTypeChangedBlock)(RecipientType *type);

@interface RecipientSectionHeaderView : UIView

@property (nonatomic, copy) RecipientTypeChangedBlock selectionChangeHandler;

- (void)setText:(NSString *)text;
- (void)setSelectedType:(RecipientType *)selected allTypes:(NSArray *)allTypes;
- (void)changeSelectedTypeTo:(RecipientType *)tappedOn;

@end
