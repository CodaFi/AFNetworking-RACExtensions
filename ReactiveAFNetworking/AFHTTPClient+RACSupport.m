//
//  AFHTTPClient+RACSupport.m
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "AFHTTPClient+RACSupport.h"
#import "AFURLConnectionOperation+RACSupport.h"
#import "AFHTTPRequestOperation.h"

NSString * const RAFNetworkingOperationErrorKey = @"AFHTTPRequestOperation";

@implementation AFHTTPClient (RACSupport)

- (RACSignal *)rac_enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)requestOperation
{
	[self enqueueHTTPRequestOperation:requestOperation];
	return [requestOperation rac_overrideHTTPCompletionBlock];
}

- (RACSignal *)rac_enqueueBatchOfHTTPRequestOperations:(NSArray *)requestOperations
{
	RACSignal *signal = [RACSignal merge:[requestOperations.rac_sequence map:^RACStream *(AFHTTPRequestOperation *request) {
		return [request rac_overrideHTTPCompletionBlock];
	}]];
	[self enqueueBatchOfHTTPRequestOperations:requestOperations progressBlock:NULL completionBlock:NULL];
	
	return signal; 
}

- (RACSignal *)rac_getPath:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self
		rac_requestPath:path parameters:parameters method:@"GET"]
		setNameWithFormat:@"<%@: %p> -rac_getPath: %@, parameters: %@", self.class, self, path, parameters];

}

- (RACSignal *)rac_postPath:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self
		rac_requestPath:path parameters:parameters method:@"POST"]
		setNameWithFormat:@"<%@: %p> -rac_postPath: %@, parameters: %@", self.class, self, path, parameters];

}

- (RACSignal *)rac_putPath:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self
		rac_requestPath:path parameters:parameters method:@"PUT"]
		setNameWithFormat:@"<%@: %p> -rac_putPath: %@, parameters: %@", self.class, self, path, parameters];

}

- (RACSignal *)rac_deletePath:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self
		rac_requestPath:path parameters:parameters method:@"DELETE"]
		setNameWithFormat:@"<%@: %p> -rac_deletePath: %@, parameters: %@", self.class, self, path, parameters];
}

- (RACSignal *)rac_patchPath:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self
		rac_requestPath:path parameters:parameters method:@"PATCH"]
		setNameWithFormat:@"<%@: %p> -rac_patchPath: %@, parameters: %@", self.class, self, path, parameters];
}

- (RACSignal *)rac_requestPath:(NSString *)path parameters:(NSDictionary *)parameters method:(NSString *)method {
	return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self requestWithMethod:method path:path parameters:parameters];
		AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:^(id operation, id result) {
			[subscriber sendNext:RACTuplePack(operation, result)];
			[subscriber sendCompleted];
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
			userInfo[RAFNetworkingOperationErrorKey] = operation;
			[subscriber sendError:[NSError errorWithDomain:error.domain code:error.code userInfo:userInfo]];
		}];

		[self enqueueHTTPRequestOperation:operation];

		return [RACDisposable disposableWithBlock:^{
			[operation cancel];
		}];
	}];
}

#ifdef _SYSTEMCONFIGURATION_H
- (RACSignal *)networkReachabilityStatusSignal {
	return RACObserve(self, networkReachabilityStatus);
}
#endif


@end
