//
//  TransferDevWebViewHelper.m
//  Transfer
//
//  Created by Mats Trovik on 17/11/2014.
//  Copyright (c) 2014 Mooncascade OÜ. All rights reserved.
//

#import "TransferDevWebTools.h"
#import "Constants.h"



#if DEV_VERSION

@implementation NSURLRequest (NSURLRequestWithIgnoreSSL)

+ (BOOL)allowsAnyHTTPSCertificateForHost:(NSString *)host
{
    return YES;
}

@end


@interface DebugURLProtocol () <NSURLConnectionDelegate>
{
    NSMutableURLRequest *_customRequest;
    NSURLConnection *_connection;
}
@end

@implementation DebugURLProtocol

static NSString *AUTHORIZED_REQUEST_HEADER = @"Authorization";

static NSString *basicAuth;

+(BOOL) canInitWithRequest:(NSMutableURLRequest *)request
{
    
    NSString *currentAuth = [request allHTTPHeaderFields][AUTHORIZED_REQUEST_HEADER];
    if(currentAuth && !basicAuth)
    {
        basicAuth = currentAuth;
    }

    BOOL canInit = (![request.URL.scheme isEqualToString:@"file"] && [request valueForHTTPHeaderField:AUTHORIZED_REQUEST_HEADER] == nil);
    return canInit;

}

-(id) initWithRequest:(NSURLRequest *)request cachedResponse:(NSCachedURLResponse *)cachedResponse client:(id<NSURLProtocolClient>)client
{
    _customRequest = [request mutableCopy];
    
    [_customRequest setValue:@"" forHTTPHeaderField:AUTHORIZED_REQUEST_HEADER ];
    
    self = [super initWithRequest:_customRequest cachedResponse:cachedResponse client:client];
    
    return self;
}

+(NSURLRequest *) canonicalRequestForRequest:(NSURLRequest *)request
{
    //We rely on an initial URL request with correct authorisation being requested first so we can cache it.
    NSMutableURLRequest *customRequest = [request mutableCopy];
   
    [customRequest setValue:@"" forHTTPHeaderField:AUTHORIZED_REQUEST_HEADER];
    
    
    [customRequest setValue:basicAuth forHTTPHeaderField:@"Authorization"];

    return customRequest;
}

- (void) startLoading
{
    [_customRequest setValue:basicAuth forHTTPHeaderField:@"Authorization"];
    
    _connection = [NSURLConnection connectionWithRequest:_customRequest delegate:self];
}

- (void) stopLoading
{
    [_connection cancel];
}

#pragma mark - NSURLConnectionDelegate

-(void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    // This protocol forgets to store cookies, so do it manually
    if([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:[NSHTTPCookie cookiesWithResponseHeaderFields:[(NSHTTPURLResponse*)response allHeaderFields] forURL:[response URL]] forURL:[response URL] mainDocumentURL:[[response URL] baseURL]];
    }
    
    [[self client] URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    [[self client] URLProtocol:self didLoadData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    [[self client] URLProtocol:self didFailWithError:error];
}

-(void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [[self client] URLProtocolDidFinishLoading:self];
}

-(NSURLRequest *) connection:(NSURLConnection *)connection willSendRequest:(NSURLRequest *)request redirectResponse:(NSURLResponse *)redirectResponse
{
    // This protocol forgets to store cookies, so do it manually
    if([redirectResponse isKindOfClass:[NSHTTPURLResponse class]])
    {
        [[NSHTTPCookieStorage sharedHTTPCookieStorage] setCookies:[NSHTTPCookie cookiesWithResponseHeaderFields:[(NSHTTPURLResponse*)redirectResponse allHeaderFields] forURL:[redirectResponse URL]] forURL:[redirectResponse URL] mainDocumentURL:[request mainDocumentURL]];
    }
    
    // copy all headers to the new request
    NSMutableURLRequest *redirect = [request mutableCopy];
    for (NSString *header in [request allHTTPHeaderFields])
    {
        [redirect setValue:[[request allHTTPHeaderFields] objectForKey:header] forHTTPHeaderField:header];
    }
    
    return redirect;
}

@end

#endif

