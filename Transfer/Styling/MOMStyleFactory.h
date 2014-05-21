//
//  MOMStyleFactory
//
//  Created by Mats Trovik on 15/11/2013.
//  Copyright (c) 2014 Matsomatic Limited All rights reserved.
//

@class MOMStyle;
@class MOMCompoundStyle;

#define defaultStyleSheetName @"Styles"

@interface MOMStyleFactory : NSObject

/**
*  method for instantiating MBStyle subclasses by identifier or a chain of styles separated by '.'-characters.
*
*  @param identifier '.'-separated concatenation of identifier names .
*
*  @return a configured and ready to use MBStyle object.
*/
+(MOMStyle*)getStyleForIdentifier:(NSString*)identifier;

/**
 *  Get a compound style
 *
 *  A compound style is a wrapper for several styles intended to allow setting common background colors and fonts in one go.
 *
 *  @param identifier compound style name. concatenation not allowed.
 *
 *  @return A compound style ready to use.
 */
+(MOMCompoundStyle*)compoundStyleForIdentifier:(NSString*)identifier;

/**
 *  Set dictionary containing style definitions. 
 *
 *  If not called a defaultStyleSheetName.plist file is loaded if present in the main bundle.
 *
 *  @param newStyleData dictionary of style definitions.
 */
+(void)setStyleData:(NSDictionary*)newStyleData;

@end
