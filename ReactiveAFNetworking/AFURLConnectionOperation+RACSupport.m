//
//  AFHTTPRequestOperation+RACSupport.m
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "AFURLConnectionOperation+RACSupport.h"

NSString * const RAFNetworkingOperationErrorKey = @"AFHTTPRequestOperation";

@implementation AFHTTPRequestOperation (RACSupport)

- (RACSignal*)rac_start {
	RACSignal* signal = [self rac_overrideHTTPCompletionBlock];
	[self start];
	return signal;
}

- (RACSignal*)rac_overrideHTTPCompletionBlock {
	
	return [RACSignal createSignal:^(id<RACSubscriber> subscriber) {
		
#ifdef RAFN_MAINTAIN_COMPLETION_BLOCKS
		void (^oldCompBlock)() = self.completionBlock;
#endif
		[self setCompletionBlockWithSuccess:^(id operation, id result) {
			[subscriber sendNext:RACTuplePack(operation, result)];
			[subscriber sendCompleted];
#ifdef RAFN_MAINTAIN_COMPLETION_BLOCKS
			if (oldCompBlock) {
				oldCompBlock();
			}
#endif
		} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
			NSMutableDictionary *userInfo = [error.userInfo mutableCopy] ?: [NSMutableDictionary dictionary];
			userInfo[RAFNetworkingOperationErrorKey] = operation;
			[subscriber sendError:[NSError errorWithDomain:error.domain code:error.code userInfo:userInfo]];
#ifdef RAFN_MAINTAIN_COMPLETION_BLOCKS
			if (oldCompBlock) {
				oldCompBlock();
			}
#endif
		}];
		
		return [RACDisposable disposableWithBlock:^{
			[self cancel];
		}];
	}];
	
}


@end

