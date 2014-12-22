//
//  AchLoginViewController.h
//  Transfer
//
//  Created by Juhan Hion on 24.11.14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "DataEntryMultiColumnViewController.h"
#import "AchFlow.h"

@class AchBank;
@class Payment;

@interface AchLoginViewController : DataEntryMultiColumnViewController

- (id)init __attribute__((unavailable("init unavailable, use initWithForm:payment:initiatePull:")));

- (instancetype)initWithForm:(AchBank *)form
					 payment:(Payment *)payment
				 objectModel:(ObjectModel *)objectModel
				initiatePull:(InitiatePullBlock)initiatePullBlock;


@end
