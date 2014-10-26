//
//  AFURLConnectionOperation+RACSupport.m
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "AFURLConnectionOperation+RACSupport.h"
#import "AFHTTPRequestOperation.h"

@implementation AFURLConnectionOperation (RACSupport)

- (RACSignal *)rac_start {
	[self start];
	return [self rac_overrideHTTPCompletionBlock];
}

- (RACSignal *)rac_overrideHTTPCompletionBlock {
	RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
	[subject setNameWithFormat:@"-rac_start: %@", self.request.URL];
	
	if ([self respondsToSelector:@selector(setCompletionBlockWithSuccess:failure:)]) {
		
#ifdef RAFN_MAINTAIN_COMPLETION_BLOCKS
		void (^oldCompBlock)() = self.completionBlock;
#endif
		[(AFHTTPRequestOperation *)self setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
			[subject sendNext:RACTuplePack(responseObject, operation.response)];
			[subject sendCompleted];
#ifdef RAFN_MAINTAIN_COMPLETION_BLOCKS
			if (oldCompBlock) {
				oldCompBlock();
			}
#endif
		} failure:^(id operation, NSError *error) {
			[subject sendError:error];
#ifdef RAFN_MAINTAIN_COMPLETION_BLOCKS
			if (oldCompBlock) {
				oldCompBlock();
			}
#endif
		}];
		
		return subject;
	}
	
	return subject;
}


@end
