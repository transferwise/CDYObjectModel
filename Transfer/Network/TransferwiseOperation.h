//
//  TransferwiseOperation.h
//  Transfer
//
//  Created by Jaanus Siim on 4/16/13.
//  Copyright (c) 2013 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@class ObjectModel;

typedef NS_ENUM(short, TRWNetworkErrorCode) {
    ResponseFormatError,
    ResponseServerError
};

@interface TransferwiseOperation : NSObject

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong, readonly) ObjectModel *workModel;


- (void)execute;
- (NSString *)addTokenToPath:(NSString *)path;
+ (void)provideAuthenticationHeaders:(NSMutableURLRequest *)request;

@end
