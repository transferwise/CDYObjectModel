//
//  RecipientsFooterView.h
//  Transfer
//
//  Created by Juhan Hion on 17.07.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "IntrinsicSizeUIView.h"

@protocol RecipientsFooterViewDelegate <NSObject>

- (void)inviteFriends;

@end

@interface RecipientsFooterView : IntrinsicSizeUIView

@property (weak, nonatomic) id<RecipientsFooterViewDelegate> delegate;

@end
