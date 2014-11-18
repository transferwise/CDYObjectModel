#import "_PayInMethod.h"

@interface PayInMethod : _PayInMethod {}

/**
 *  Get a list of pay in methods supported by this app verison.
 *
 *  Update when new pay in methods are supported.
 *
 *  @return List of accepted pay in method type names.
 */
+(NSDictionary*)supportedPayInMethods;

@end
