//
//  AFHTTPClient+RAFMocking.h
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 5/26/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

extern NSString *const AFHTTPClientMockResponse;

#import "AFHTTPClient.h"

@interface AFHTTPClient (RAFMocking)

- (RACSignal *)mock_getPath:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)mock_postPath:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)mock_putPath:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)mock_deletePath:(NSString *)path parameters:(NSDictionary *)parameters;
- (RACSignal *)mock_patchPath:(NSString *)path parameters:(NSDictionary *)parameters;

@end
