//
//  AFHTTPClient+RACSupport.h
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import <AFNetworking/AFHTTPRequestOperationManager.h>
#import <ReactiveCocoa/ReactiveCocoa.h>

/*!
 * User info key for accessing the AFHTTPRequestOperation on which the error occured.
 */
extern NSString * const RAFNetworkingOperationErrorKey;

@interface AFHTTPRequestOperationManager (RACSupport)

#ifdef _SYSTEMCONFIGURATION_H

/*!
 * A convenient getter for the Network Reachability Status getter in AFNetworking.  No need to 
 * subscribe to anymore notifications, just -subscribeNext: and let the network changes flow in!
 * As with the primitive reachability property, you must be linked against, and importing, 
 * SystemConfiguration.framework.
 *
 * Sample Usage:
 *
 * [self.httpClient.networkReachabilityStatusSignal subscribeNext:^(NSNumber *status) {
 *     AFNetworkReachabilityStatus networkStatus = [status intValue];
 *     switch (networkStatus) {
 *		 	case AFNetworkReachabilityStatusUnknown:
 *      	case AFNetworkReachabilityStatusNotReachable:
 *      	     [self cancelTheShow];
 *				 break;
 *       	case AFNetworkReachabilityStatusReachableViaWWAN:
 *      	case AFNetworkReachabilityStatusReachableViaWiFi:
 *           	if (self.theShowMustGoOn)
 *               	[self letTheShowGoOn];
 *           	 break;
 *      }
 * }];
 */
- (RACSignal *)networkReachabilityStatusSignal;
#endif

/*!
 * The Reactive version of AFHTTPClient's -enqueueHTTPRequestOperation:.  The enqueued request may 
 * be started immediately, and is eagerly evaluated by NSOperationQueue, so it is highly recommended
 * that you subscribe immediately.
 * 
 * In order to deliver the proper events to subscribers, RAC will overwrite any completion blocks 
 * you may have set.  If you would like to preserve them, and have the extension call them when 
 * processing finishes, #define RAFN_MAINTAIN_COMPLETION_BLOCKS somewhere where the extensions can 
 * see it.
 */
- (RACSignal *)rac_enqueueHTTPRequestOperation:(AFHTTPRequestOperation *)requestOperation;

/*!
 * A convenience around -getPath:parameters:success:failure: that returns a cold signal of the 
 * result.
 */
- (RACSignal *)rac_GET:(NSString *)path parameters:(NSDictionary *)parameters;

/*!
 * A convenience around -postPath:parameters:success:failure: that returns a cold signal of the
 * result.
 */
- (RACSignal *)rac_POST:(NSString *)path parameters:(NSDictionary *)parameters;

/*!
 * A convenience around -putPath:parameters:success:failure: that returns a cold signal of the
 * result.
 */
- (RACSignal *)rac_PUT:(NSString *)path parameters:(NSDictionary *)parameters;

/*!
 * A convenience around -deletePath:parameters:success:failure: that returns a cold signal of the
 * result.
 */
- (RACSignal *)rac_DELETE:(NSString *)path parameters:(NSDictionary *)parameters;

/*!
 * A convenience around -patchPath:parameters:success:failure: that returns a cold signal of the
 * result.
 */
- (RACSignal *)rac_PATCH:(NSString *)path parameters:(NSDictionary *)parameters;

@end
