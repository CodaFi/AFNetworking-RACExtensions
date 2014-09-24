//
//  AFHTTPRequestOperationManager+RACSupport.h
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "AFHTTPRequestOperationManager.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

/// User info key for accessing the AFHTTPRequestOperation on which the error occured.
extern NSString *const RAFNetworkingOperationErrorKey;

@interface AFHTTPRequestOperationManager (RACSupport)

#ifdef _SYSTEMCONFIGURATION_H

/// Returns a cold signal of the Network's current reachability status.
///
/// Sample Usage:
///
///	[self.httpClient.networkReachabilityStatusSignal subscribeNext:^(NSNumber *status) {
///		AFNetworkReachabilityStatus networkStatus = [status intValue];
///		switch (networkStatus) {
///			case AFNetworkReachabilityStatusUnknown:
///			case AFNetworkReachabilityStatusNotReachable:
///				[self cancelTheShow];
///				break;
///			case AFNetworkReachabilityStatusReachableViaWWAN:
///			case AFNetworkReachabilityStatusReachableViaWiFi:
///				if (self.theShowMustGoOn)
///				[self letTheShowGoOn];
///				break;
///		}
///	}];
////
- (RACSignal *)networkReachabilityStatusSignal;

#endif

/// The Reactive version of AFHTTPClient's -enqueueHTTPRequestOperation:.  The enqueued request may
/// be started immediately, and is eagerly evaluated by NSOperationQueue, so it is highly recommended
/// that you subscribe immediately.
/// 
/// In order to deliver the proper events to subscribers, RAC will overwrite any completion blocks
/// you may have set.  If you would like to preserve them, and have the extension call them when
/// processing finishes, #define RAFN_MAINTAIN_COMPLETION_BLOCKS somewhere where the extensions can
/// see it.
- (RACSignal *)rac_enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)requestOperation;

/// A convenience around -GET:parameters:success:failure: that returns a cold signal of the
/// resulting JSON object or error.
- (RACSignal *)rac_GET:(NSString *)path parameters:(id)parameters;

/// A convenience around -POST:parameters:success:failure: that returns a cold signal of the
/// resulting JSON object or error.
- (RACSignal *)rac_POST:(NSString *)path parameters:(id)parameters;

/// A convenience around -PUT:parameters:success:failure: that returns a cold signal of the
/// resulting JSON object or error.
- (RACSignal *)rac_PUT:(NSString *)path parameters:(id)parameters;

/// A convenience around -DELETE:parameters:success:failure: that returns a cold signal of the
/// resulting JSON object or error.
- (RACSignal *)rac_DELETE:(NSString *)path parameters:(id)parameters;

/// A convenience around -PATCH:parameters:success:failure: that returns a cold signal of the
/// resulting JSON object or error.
- (RACSignal *)rac_PATCH:(NSString *)path parameters:(id)parameters;

@end

@interface AFHTTPRequestOperationManager (RACSupportDeprecated)

- (RACSignal *)rac_enqueueBatchOfHTTPRequestOperations:(NSArray *)requestOperations DEPRECATED_ATTRIBUTE;

@end
