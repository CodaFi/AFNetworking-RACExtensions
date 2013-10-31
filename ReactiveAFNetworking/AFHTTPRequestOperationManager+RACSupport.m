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

- (RACSignal *)rac_enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)requestOperation
{
	RACSignal* signal = [requestOperation rac_overrideHTTPCompletionBlock];
	[self.operationQueue addOperation:requestOperation];
	return signal;
}

//- (RACSignal *)rac_enqueueBatchOfHTTPRequestOperations:(NSArray *)requestOperations
//{
//	RACSignal *signal = [RACSignal merge:[requestOperations.rac_sequence map:^RACStream *(AFHTTPRequestOperation *request) {
//		return [request rac_overrideHTTPCompletionBlock];
//	}]];
//	
//	[self enqueueBatchOfHTTPRequestOperations:requestOperations progressBlock:NULL completionBlock:NULL];
//	
//	return signal; 
//}

- (RACSignal *)rac_GET:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self
		rac_requestPath:path parameters:parameters method:@"GET"]
		setNameWithFormat:@"<%@: %p> -rac_getPath: %@, parameters: %@", self.class, self, path, parameters];

}

- (RACSignal *)rac_POST:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self
		rac_requestPath:path parameters:parameters method:@"POST"]
		setNameWithFormat:@"<%@: %p> -rac_postPath: %@, parameters: %@", self.class, self, path, parameters];

}

- (RACSignal *)rac_PUT:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self
		rac_requestPath:path parameters:parameters method:@"PUT"]
		setNameWithFormat:@"<%@: %p> -rac_putPath: %@, parameters: %@", self.class, self, path, parameters];

}

- (RACSignal *)rac_DELETE:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self
		rac_requestPath:path parameters:parameters method:@"DELETE"]
		setNameWithFormat:@"<%@: %p> -rac_deletePath: %@, parameters: %@", self.class, self, path, parameters];
}

- (RACSignal *)rac_PATCH:(NSString *)path parameters:(NSDictionary *)parameters {
	return [[self
		rac_requestPath:path parameters:parameters method:@"PATCH"]
		setNameWithFormat:@"<%@: %p> -rac_patchPath: %@, parameters: %@", self.class, self, path, parameters];
}

- (RACSignal *)rac_requestPath:(NSString *)path parameters:(NSDictionary *)parameters method:(NSString *)method {
	return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
		NSURLRequest *request = [self.requestSerializer requestWithMethod:method URLString:[[NSURL URLWithString:path relativeToURL:self.baseURL] absoluteString] parameters:parameters];
		
		AFHTTPRequestOperation *operation = [self HTTPRequestOperationWithRequest:request success:nil failure:nil];
		RACSignal* signal = [operation rac_overrideHTTPCompletionBlock];
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
