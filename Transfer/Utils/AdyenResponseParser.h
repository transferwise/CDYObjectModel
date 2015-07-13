//
//  AdyenResponseParser.h
//  Transfer
//
//  Created by Juhan Hion on 13.07.15.
//  Copyright (c) 2015 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AdyenResponseParser : NSObject

- (id)init __attribute__((unavailable("init unavailable, this is a static class")));
+ (void)handleAdyenResponse:(NSError *)error
				   response:(NSDictionary *)response
			successHandler:(void (^)())successHandler
				failHandler:(void (^)(NSError *error, NSString *errorKeySuffix))failHandler;

@end
