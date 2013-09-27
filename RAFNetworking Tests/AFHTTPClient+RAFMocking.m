//
//  AFHTTPClient+RAFMocking.m
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 5/26/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

NSString *const AFHTTPClientMockResponse = @"AFHTTPClientMockResponse";

#import "AFHTTPClient+RAFMocking.h"

@implementation AFHTTPClient (RAFMocking)

- (RACSignal *)mock_getPath:(NSString *)path parameters:(NSDictionary *)parameters {
	return [self mock_requestPath:path parameters:parameters method:@"GET"];
}

- (RACSignal *)mock_postPath:(NSString *)path parameters:(NSDictionary *)parameters {
	return [self mock_requestPath:path parameters:parameters method:@"POST"];
}

- (RACSignal *)mock_putPath:(NSString *)path parameters:(NSDictionary *)parameters {
	return [self mock_requestPath:path parameters:parameters method:@"PUT"];
}

- (RACSignal *)mock_deletePath:(NSString *)path parameters:(NSDictionary *)parameters {
	return [self mock_requestPath:path parameters:parameters method:@"DELETE"];
}

- (RACSignal *)mock_patchPath:(NSString *)path parameters:(NSDictionary *)parameters {
	return [self mock_requestPath:path parameters:parameters method:@"PATCH"];
}

- (RACSignal *)mock_requestPath:(NSString *)path parameters:(NSDictionary *)parameters method:(NSString *)method {
	return [RACSignal createSignal:^RACDisposable *(id<RACSubscriber> subscriber) {
		
		[subscriber sendNext:AFHTTPClientMockResponse];
		[subscriber sendCompleted];
		
		return nil;
	}];
}


@end
