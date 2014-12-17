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
    ResponseLocalError = -1,
    ResponseCumulativeError = 0,
    ResponseFormatError = 1,
    ResponseServerError = 2,
    ResponseCallGoneError = 3
};

@interface TransferwiseOperation : NSObject

@property (nonatomic, strong) ObjectModel *objectModel;
@property (nonatomic, strong, readonly) ObjectModel *workModel;


- (NSString*)apiVersion;
- (void)execute;
- (NSString *)addTokenToPath:(NSString *)path;
- (void)handleErrorResponseData:(NSDictionary *)errorData;
- (void)cancel;

+ (void)provideAuthenticationHeaders:(NSMutableURLRequest *)request;
+ (NSURLRequest*)getRequestForApiPath:(NSString*)path parameters:(NSDictionary*)params;

@end
