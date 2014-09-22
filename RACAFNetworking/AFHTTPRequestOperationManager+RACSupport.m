//
//  AFHTTPClient+RACSupport.m
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "AFHTTPRequestOperationManager+RACSupport.h"
#import "AFURLConnectionOperation+RACSupport.h"
#import "AFHTTPRequestOperation.h"

@implementation AFHTTPRequestOperationManager (RACSupport)

- (RACSignal *)rac_enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)requestOperation {
	RACSignal* signal = [requestOperation rac_overrideHTTPCompletionBlock];
	[self.operationQueue addOperation:requestOperation];
	return signal;
}

- (RACSignal *)rac_enqueueBatchOfHTTPRequestOperations:(NSArray *)requestOperations {
	return nil;
}

- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"GET"]
			setNameWithFormat:@"%@ -rac_GET: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"POST"]
			setNameWithFormat:@"%@ -rac_POST: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"PUT"]
			setNameWithFormat:@"%@ -rac_PUT: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"DELETE"]
			setNameWithFormat:@"%@ -rac_DELETE: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id)parameters {
	return [[self rac_requestPath:path parameters:parameters method:@"PATCH"]
			setNameWithFormat:@"%@ -rac_PATCH: %@, parameters: %@", self.class, path, parameters];
}

- (RACSignal *)rac_requestPath:(NSString *)path parameters:(id)parameters method:(NSString *)method {
	return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString] parameters:parameters error:nil];
		
		AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:nil failure:nil];
		RACSignal *signal = [operation rac_overrideHTTPCompletionBlock];
		[self.operationQueue addOperation:operation];
		[signal subscribe:subscriber];
		return [RACDisposable disposableWithBlock:^{
			[operation cancel];
		}];
	}];
}

#ifdef _SYSTEMCONFIGURATION_H
- (RACSignal *)networkReachabilityStatusSignal {
	return RACObserve(self.reachabilityManager, networkReachabilityStatus);
}
#endif


@end