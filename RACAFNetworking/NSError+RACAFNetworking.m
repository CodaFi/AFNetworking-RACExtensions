//
// NSError+RACAFNetworking.m
//
// The MIT License (MIT)
//
// Copyright (c) 2015 Dal Rupnik (https://github.com/legoless)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "NSError+RACAFNetworking.h"
#import "AFURLRequestSerialization.h"

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
        return (self.originalError.userInfo[NSURLErrorFailingURLStringErrorKey]) ? self.originalError.userInfo[NSURLErrorFailingURLStringErrorKey] : nil;
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
