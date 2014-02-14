//
//  PageZoom.h
//  Transfer
//
//  Created by Jaanus Siim on 07/02/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PageZoom : NSObject

@property (nonatomic, assign, readonly) CGRect zoom;

+ (PageZoom *)zoomForURL:(NSURL *)URL;

@end
