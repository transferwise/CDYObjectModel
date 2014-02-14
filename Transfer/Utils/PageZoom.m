//
//  PageZoom.m
//  Transfer
//
//  Created by Jaanus Siim on 07/02/14.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "PageZoom.h"
#import "Constants.h"

static NSArray *__existingZooms;

@interface PageZoom ()

@property (nonatomic, copy) NSString *page;
@property (nonatomic, assign) CGRect zoom;

@end

@implementation PageZoom

+ (void)initialize {
    NSString *path = [[NSBundle mainBundle] pathForResource:@"page_zoom" ofType:@"json"];
    NSData *data = [NSData dataWithContentsOfFile:path];
    MCAssert(data);
    NSError *error = nil;
    NSDictionary *zoomData = [NSJSONSerialization JSONObjectWithData:data options:0 error:&error];
    if (error) {
        MCLog(@"JSON error:%@", error);
    }
    MCAssert(!error);
    NSArray *zooms = zoomData[@"zooms"];
    MCAssert(zooms);

    NSMutableArray *result = [NSMutableArray arrayWithCapacity:[zooms count]];
    for (NSDictionary *zoom in zooms) {
        [result addObject:[PageZoom zoomWithData:zoom]];
    }

    __existingZooms = [NSArray arrayWithArray:result];
}

+ (PageZoom *)zoomWithData:(NSDictionary *)data {
    PageZoom *zoom = [[PageZoom alloc] init];
    [zoom setPage:data[@"page"]];
    NSDictionary *box = data[@"zoom"];
    NSNumber *x = box[@"x"];
    NSNumber *y = box[@"y"];
    NSNumber *w = box[@"w"];
    NSNumber *h = box[@"h"];
    [zoom setZoom:CGRectMake([x floatValue], [y floatValue], [w floatValue], [h floatValue])];
    return zoom;
}

+ (PageZoom *)zoomForURL:(NSURL *)URL {
    NSString *path = URL.absoluteString;
    for (PageZoom *zoom in __existingZooms) {
        if ([path rangeOfString:zoom.page].location == 0) {
            return zoom;
        }
    }

    return nil;
}

@end
