//
//  AFURLConnectionOperation+RACSupport.h
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "AFHTTPRequestOperation.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface AFHTTPRequestOperation (RACSupport)


/// Used to internally overwrite the completion and failure blocks of any AFHTTPRequestOperation and
/// RAC'ify them to return a signal.
- (RACSignal *)rac_overrideHTTPCompletionBlock;


/// Overwrites the internal completion and failure blocks for any subclass of AFHTTPRequestOperation,
/// then -start's it.  For all other subclasses of AFURLConnectionOperation, it just sends -start
/// and returns an unusable subject and starts the operation.
/// Sample usage:
///
///		[[[AFHTTPRequestOperation alloc] init] rac_start] subscribeCompleted:^{
///			//Request Finished
///		}];
///
/// Alternatively:
///
///		[[[[AFHTTPRequestOperation alloc] init] rac_start] subscribeNext:(id JSON)^{
///			//Process
///		}];
///
- (RACSignal *)rac_start;

@end
