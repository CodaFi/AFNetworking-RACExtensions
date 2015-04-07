//
// NSError+AFNetworking.m
//
// Copyright (c) 2015 Dal Rupnik (https://github.com/legoless)
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
