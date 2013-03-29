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
	RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];

	[self getPath:path parameters:parameters success:^(AFURLConnectionOperation *operation, id responseObject) {
		[subject sendNext:responseObject];
		[subject sendCompleted];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[subject sendError:error];
	}];
	
	return subject;
}

- (RACSignal *)rac_postPath:(NSString *)path parameters:(NSDictionary *)parameters {
	RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
	
	[self postPath:path parameters:parameters success:^(AFURLConnectionOperation *operation, id responseObject) {
		[subject sendNext:responseObject];
		[subject sendCompleted];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[subject sendError:error];
	}];
	
	return subject;
}

- (RACSignal *)rac_putPath:(NSString *)path parameters:(NSDictionary *)parameters {
	RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
	
	[self putPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[subject sendNext:responseObject];
		[subject sendCompleted];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[subject sendError:error];
	}];
	
	return subject;
}


- (RACSignal *)rac_deletePath:(NSString *)path parameters:(NSDictionary *)parameters {
	RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
	
	[self deletePath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[subject sendNext:responseObject];
		[subject sendCompleted];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[subject sendError:error];
	}];
	
	return subject;
}


- (RACSignal *)rac_patchPath:(NSString *)path parameters:(NSDictionary *)parameters {
	RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
	
	[self patchPath:path parameters:parameters success:^(AFHTTPRequestOperation *operation, id responseObject) {
		[subject sendNext:responseObject];
		[subject sendCompleted];
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		[subject sendError:error];
	}];
	
	return subject;
}

#ifdef _SYSTEMCONFIGURATION_H
- (RACSignal *)networkReachabilityStatusSignal {
	return RACAble(self.networkReachabilityStatus);
}
#endif


@end
