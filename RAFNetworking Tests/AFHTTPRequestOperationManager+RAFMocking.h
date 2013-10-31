//
//  AFHTTPClient+RAFMocking.h
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 5/26/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

extern NSString *const AFHTTPClientMockResponse;

#import <AFHTTPRequestOperationManager.h>
#import <ReactiveCocoa.h>

@interface AFHTTPRequestOperationManager (RAFMocking)

- (RACSignal *)mock_GET:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)mock_POST:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)mock_PUT:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)mock_DELETE:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)mock_PATCH:(NSString *)path parameters:(NSDictionary *)parameters;

@end
