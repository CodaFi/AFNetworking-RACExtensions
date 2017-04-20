//
// NSError+RACAFNetworking.m
//
// Copyright (c) 2015 Dal Rupnik (https://github.com/legoless)
//

#import "NSError+RACAFNetworking.h"
#import "AFURLRequestSerialization.h"
#import "AFURLResponseSerialization.h"

@implementation NSError (RACAFNetworking)

- (NSInteger)rac_networkStatusCode {
    NSURLResponse *response = [self rac_response];
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]])
    {
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        
        return urlResponse.statusCode;
    }
    
    return 0;
}

- (NSURLRequest *)rac_request {
    return [self rac_objectInUserInfo:AFNetworkingOperationFailingURLRequestErrorKey withError:self];
}

- (NSURLResponse *)rac_response {
    return [self rac_objectInUserInfo:AFNetworkingOperationFailingURLResponseErrorKey withError:self];
}

- (NSData *)rac_responseData {
    return [self rac_objectInUserInfo:AFNetworkingOperationFailingURLResponseDataErrorKey withError:self];
}

- (NSString *)rac_responseString {
    return [[NSString alloc] initWithData:[self rac_objectInUserInfo:AFNetworkingOperationFailingURLResponseDataErrorKey withError:self] encoding:NSUTF8StringEncoding];
}

- (NSString *)rac_requestURL {
    NSURLResponse *response = [self rac_response];
    
    if ([response isKindOfClass:[NSHTTPURLResponse class]]) {
        NSHTTPURLResponse *urlResponse = (NSHTTPURLResponse *)response;
        
        return urlResponse.URL.absoluteString;
    }
    else {
        return (self.userInfo[NSURLErrorFailingURLStringErrorKey]) ? self.userInfo[NSURLErrorFailingURLStringErrorKey] : nil;
    }
}

#pragma mark - Private methods

- (id)rac_objectInUserInfo:(NSString *)key withError:(NSError *)error {
    
    //
    // Check for underlying error
    //
    
    NSError *underlyingError = error.userInfo[NSUnderlyingErrorKey];
    
    return error.userInfo[key] ?: underlyingError.userInfo[key];
}

@end
