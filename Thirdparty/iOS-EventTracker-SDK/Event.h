//
//  Event.h
//
//  Created by Tyler Thomas on 1/10/13.
//  Copyright (c) 2013 Impact Radius. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

@property (nonatomic, strong) NSMutableArray *itemArray;

- (NSMutableDictionary*) getEventParamTable;

- (id)init:(NSString *)eventName;

- (void) setActionTrackerId:(NSString *) actionTrackerId;
- (void) setCurrency:(NSString*) currency;
- (void) setClickId:(NSString*) clickId;
- (void) setCustomerId:(NSString*) customerId;
- (void) setCustomerStatus:(NSString*)status;
- (void) setDisposition:(NSString*) disp;
- (void) setExchangeRate:(NSString*) exchangeRate;
- (void) setEvent:(NSString*) event;
- (void) setMargin:(NSString*) margin;
- (void) setNote:(NSString*) note;
- (void) setPostalCode:(NSString*) postalCode;
- (void) setPromoCode:(NSString*)promoCode;
- (void) setStatus:(NSString*) status;
- (void) setUserAgent:(NSString*) userAgent;
- (void) setRebate:(NSString*)rebate;
- (void) setSubTotal:(NSString*)subTotal;
- (void) setSharedId:(NSString*)sharedId;
- (void) setString1:(NSString*)str1;
- (void) setString2:(NSString*)str2;
- (void) setDate1:(NSString*)date1;
- (void) setDate2:(NSString*)date2;
- (void) setLatitude:(NSString*)lat;
- (void) setLongitude:(NSString*)lon;
- (void) setDisplayDense:(NSString*)displayDense;
- (void) setConnType:(NSString*) connType;
- (void) setSdk:(NSString*) sdk;
- (void) setSdkVer:(NSString*) sdkVer;
- (void) setPayable:(BOOL) payable;
- (void) setIpAddressCarrier:(NSString*) ipAddressCarrier;
- (void) setIpAddressWifi:(NSString*) ipAddressWifi;
- (void) setArmAbi:(NSString*) armAbi;
- (void) setCountryCode:(NSString*) countryCode;


@end
