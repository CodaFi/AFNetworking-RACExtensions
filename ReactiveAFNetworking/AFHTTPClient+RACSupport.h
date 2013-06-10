//
//  AFHTTPClient+RACSupport.h
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "AFHTTPClient.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

/*!
 * User info key for accessing the AFHTTPRequestOperation on which the error occured.
 */
extern NSString * const RAFNetworkingOperationErrorKey;

@interface AFHTTPClient (RACSupport)

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
 * The Reactive version of AFHTTPClient's -enqueueHTTPRequestOperation:.  The enqueued requests will
 * be automatically -merge:'d into one large signal.  Unfortunately, the option to subscribe to the
 * progress of batch signals is unavailable at this time due to API difficulties.  The majority of 
 * the work to do such progress sending is defined in RACSubscriber+AFProgressCallbacks, however
 * it is strongly advised that that section of the extensions not be used.  
 *
 * In order to deliver the proper events to subscribers, RAC will overwrite any completion blocks
 * you may have set.  If you would like to preserve them, and have the extension call them when
 * processing finishes, #define RAFN_MAINTAIN_COMPLETION_BLOCKS somewhere where the extensions can
 * see it.
 */
- (RACSignal *)rac_enqueueBatchOfHTTPRequestOperations:(NSArray *)requestOperations;

/*!
 * A convenience around -getPath:parameters:success:failure: that returns a cold signal of the 
 * result.
 */
- (RACSignal *)rac_getPath:(NSString *)path parameters:(NSDictionary *)parameters;

/*!
 * A convenience around -postPath:parameters:success:failure: that returns a cold signal of the
 * result.
 */
- (RACSignal *)rac_postPath:(NSString *)path parameters:(NSDictionary *)parameters;

/*!
 * A convenience around -putPath:parameters:success:failure: that returns a cold signal of the
 * result.
 */
- (RACSignal *)rac_putPath:(NSString *)path parameters:(NSDictionary *)parameters;

/*!
 * A convenience around -deletePath:parameters:success:failure: that returns a cold signal of the
 * result.
 */
- (RACSignal *)rac_deletePath:(NSString *)path parameters:(NSDictionary *)parameters;

/*!
 * A convenience around -patchPath:parameters:success:failure: that returns a cold signal of the
 * result.
 */
- (RACSignal *)rac_patchPath:(NSString *)path parameters:(NSDictionary *)parameters;

@end
