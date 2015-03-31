//
// NSError+AFNetworking.m
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

#import <Foundation/Foundation.h>

@interface NSError (RACAFNetworking)

/// HTTP Status Code that was returned from network
@property (nonatomic, readonly) NSInteger rac_networkStatusCode;

/// Response data that was returned from network
@property (nonatomic, readonly) NSData *rac_responseData;

/// Response string allocated from response data in UTF8 format
@property (nonatomic, readonly) NSString *rac_responseString;

/// Request URL
@property (nonatomic, readonly) NSString *rac_requestURL;

/// NSURLResponse object with response details
@property (nonatomic, readonly) NSURLResponse *rac_response;

/// NSURLRequest object with request information
@property (nonatomic, readonly) NSURLRequest *rac_request;

@end
