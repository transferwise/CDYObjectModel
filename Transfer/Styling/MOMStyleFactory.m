//
//  MOMStyleFactory
//
//  Created by Mats Trovik on 15/11/2013.
//  Copyright (c) 2014 Matsomatic Limited All rights reserved.
//

#import "MOMStyleFactory.h"
#import "MOMBasicStyle.h"
#import "MOMCompoundStyle.h"

#define defaultStyleSheetName @"Styles"

@implementation MOMStyleFactory

+(NSCache*)styleLibrary
{
    static NSCache* styleLibrary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        styleLibrary = [[NSCache alloc] init];
    });
    return styleLibrary;
}

+(NSCache*)baseStyleLibrary
{
    static NSCache* baseStyleLibrary;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        baseStyleLibrary = [[NSCache alloc] init];
    });
    return baseStyleLibrary;
}

static NSDictionary* styleData;

+(NSDictionary*)styleDataDictionary
{
    if(!styleData)
    {
        [self setStyleData:[NSDictionary dictionaryWithContentsOfFile:[[NSBundle mainBundle] pathForResource:defaultStyleSheetName ofType:@"plist"]]];
    }
    
    return styleData;
}

+(void)setStyleData:(NSDictionary*)newStyleData
{
    styleData = newStyleData;
    [[self styleLibrary] removeAllObjects];
    [[self baseStyleLibrary] removeAllObjects];
}


+(MOMStyle *)getStyleForIdentifier:(NSString *)styleName
{
    styleName = [styleName lowercaseString];
    
    MOMStyle* result = [[self styleLibrary] objectForKey:styleName];
    
    if(!result)
    {
        NSArray* styles = [styleName componentsSeparatedByString:@"."];
        for (NSString* identifier in styles)
        {
            MOMStyle* currentStyle = [MOMStyleFactory getBaseStyleForIdentifier:identifier];
            if(currentStyle)
            {
                currentStyle = [currentStyle styleWrappedAsComposite];
                if(result)
                {
                    [result addStyle:currentStyle];
                }
                else
                {
                    result = currentStyle;
                }
            }
        }
        if(result)
        {
            [[self styleLibrary] setObject:result forKey:styleName];
        }
    }
    return result;
}

+(MOMStyle *)getBaseStyleForIdentifier:(NSString *)identifier
{
    identifier = [identifier lowercaseString];
    MOMStyle* result = [[self baseStyleLibrary] objectForKey:identifier];
    
    if(!result)
    {
        NSDictionary* styleDataDictionary =[self styleDataDictionary][@"base"];
        for(NSString* groupKey in [styleDataDictionary allKeys] )
        {
            NSDictionary* styleGroup = [styleDataDictionary valueForKey:groupKey];
            for (NSString* key in [styleGroup allKeys])
            {
                if ([key caseInsensitiveCompare:identifier]==NSOrderedSame)
                {
                    NSDictionary* styleData = styleGroup[key];
                    if([groupKey caseInsensitiveCompare:@"font"]==NSOrderedSame
                       ||
                       [groupKey caseInsensitiveCompare:@"color"]==NSOrderedSame
                       ||
                       [groupKey caseInsensitiveCompare:@"basic"]==NSOrderedSame)
                    {
                        MOMBasicStyle* fontStyle = [[MOMBasicStyle alloc] init];
                        fontStyle.fontName = styleData[@"fontName"];
                        fontStyle.fontSize = styleData[@"fontSize"];
                        [self setColorPropertiesFromData:styleData onColorStyle:fontStyle];
                        result = fontStyle;
                    }
                    else if ([groupKey caseInsensitiveCompare:@"appearance"]==NSOrderedSame)
                    {
                        Class class = NSClassFromString(styleData[@"class"]);
                        if(class && [class isSubclassOfClass:([MOMAppearanceStyle class])])
                        {
                            id appearanceStyle = [[class alloc] init];
                            if(appearanceStyle)
                            {
                                NSMutableDictionary* keyValues = [NSMutableDictionary dictionaryWithDictionary:styleData];
                                [keyValues removeObjectForKey:@"class"];
                                for(NSString *key in [keyValues allKeys])
                                {
                                    [appearanceStyle setValue:[keyValues objectForKey:key] forKey:key];
                                }
                                result = appearanceStyle;
                            }
                        }
                    }
                    if
                    (result)
                    {
                        [[self baseStyleLibrary] setObject:result forKey:identifier];
                        break;
                    }
                }
                if(result) break;
            }
            if(result) break;
        }
    }
    return result;
}

+(MOMCompoundStyle*)compoundStyleForIdentifier:(NSString*)identifier
{
    identifier = [identifier lowercaseString];
    MOMStyle* result = [[self styleLibrary] objectForKey:identifier];
    
    if(!result)
    {
        NSDictionary* compoundStyleDataDictionary =[self styleDataDictionary][@"compound"];
        for(NSString* groupKey in [compoundStyleDataDictionary allKeys])
        {
            if([groupKey caseInsensitiveCompare:identifier]==NSOrderedSame)
            {
                result = [[MOMCompoundStyle alloc] init];
                NSDictionary* compoundStyleDictionary = compoundStyleDataDictionary[groupKey];
                for (NSString* key in [compoundStyleDictionary allKeys])
                {
                    [result setValue:[MOMStyleFactory getStyleForIdentifier:compoundStyleDictionary[key]] forKey:key];
                }
                [[self styleLibrary] setObject:result forKey:identifier];
            }
            if (result) break;
        }
        
    }
    
    return ([result class]==[MOMCompoundStyle class])?(MOMCompoundStyle *)result:nil;
}

+(void)setColorPropertiesFromData:(NSDictionary *)data onColorStyle:(MOMBasicStyle*)style
{
    NSString *hexColor = data[@"color"];
    if(hexColor)
    {
        [style setColorWithHexString:hexColor];
    }
    else
    {
        style.red = data[@"red"];
        style.green = data[@"green"];
        style.blue = data[@"blue"];
    }

    NSNumber* alpha = data[@"alpha"];
    if(alpha)
    {
        style.alpha = alpha;
    }
    
    if([style isKindOfClass:([MOMBasicStyle class])])
    {
        MOMBasicStyle* fontStyle = (MOMBasicStyle*)style;
        hexColor = data[@"shadowColor"];
        if(hexColor)
        {
            [fontStyle setShadowColorWithHexString:hexColor];
        }
        else
        {
            fontStyle.shadowRed = data[@"shadowRed"];
            fontStyle.shadowGreen = data[@"shadowGreen"];
            fontStyle.shadowBlue = data[@"shadowBlue"];
        }
        
        alpha = data[@"shadowAlpha"];
        if(alpha)
        {
            fontStyle.shadowAlpha = alpha;
        }
        
        fontStyle.shadowOffsetX = data[@"shadowOffsetX"];
        fontStyle.shadowOffsetY = data[@"shadowOffsetY"];
        
        
    }
    
}



@end
