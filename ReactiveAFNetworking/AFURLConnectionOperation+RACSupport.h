//
//  AFHTTPRequestOperation+RACSupport.h
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "AFURLConnectionOperation.h"
#import "AFImageRequestOperation.h"
#import "AFJSONRequestOperation.h"
#import "AFPropertyListRequestOperation.h"
#import "AFXMLRequestOperation.h"
#import <ReactiveCocoa/ReactiveCocoa.h>

@interface AFHTTPRequestOperation (RACSupport)

/*!
 * Used to internally overwrite the completion and failure blocks of any AFHTTPRequestOperation and
 * RAC'ify them to return a signal.
 */
- (RACSignal*)rac_overrideHTTPCompletionBlock;

/*!
 * Overwrites the internal completion and failure blocks for any subclass of AFHTTPRequestOperation,
 * then -start's it.  For all other subclasses of AFURLConnectionOperation, it just sends -start
 * and returns an unusable subject and starts the operation.
 * Sample usage:
 *
 * [[[AFHTTPRequestOperation alloc]init]rac_start]subscribeCompleted:^{
 *    //Request Finished
 * }];
 *
 * Alternatively:
 *
 * [[[[AFHTTPRequestOperation alloc]init]rac_start]subscribeNext:(RACTuple *results)^{
 *    id responseObject = [results first];
 *    //Process
 * }];
 */
- (RACSignal*)rac_start;

@end

@interface AFImageRequestOperation (RACSupport)

/*!
 * A convience for AFImageRequestOperation's +imageRequestOperationWithRequest:success:.
 * Subscribers are sent a RACTuple upon completion that contains the given image in the first slot
 * and the response object in the second.  
 *
 * If you would like to simulate the image block present in the class, -map the returned tuple and
 * process the image like so:
 *
 * [[[AFImageRequestOperation rac_startImageRequestOperationWithRequest:imageRequest
 * ]map:^id(RACTuple *value) {
 *    UIImage *img = [value first];
 *    //Process the image
 *    return img;
 * }]subscribeNext:^(UIImage *image) {
 *    //Do some stuff with the newly processed image.
 * }];
 *
 * To keep image processing off the main thread, call -deliverOn: before -map'ing the sent value.
 */
+ (RACSignal *)rac_startImageRequestOperationWithRequest:(NSURLRequest *)urlRequest;

@end

@interface AFJSONRequestOperation (RACSupport)

/*!
 * A convenience around AFJSONRequestOperation's +JSONRequestOperationWithRequest:success:failure:
 * that returns a tuple with the resulting JSON container as its first element and the response
 * object as its second element.
 */
+ (RACSignal *)rac_startJSONRequestOperationWithRequest:(NSURLRequest *)urlRequest;

@end

@interface AFPropertyListRequestOperation (RACSupport)

/*!
 * A convenience around AFPropertyListRequestOperation's 
 * +propertyListRequestOperationWithRequest:success:failure: that returns a tuple with the resulting 
 * Plist as its first element and the repsonse object as its second element.
 */
+ (RACSignal *)rac_startPropertyListRequestOperationWithRequest:(NSURLRequest *)urlRequest;

@end

@interface AFXMLRequestOperation (RACSupport)

/*!
 * A convenience around AFXMLRequestOperation's 
 * +XMLParserRequestOperationWithRequest:success:failure: that returns a tuple with the resulting
 * XMLParser as its first element and the repsonse object as its second element.
 */
+ (RACSignal *)rac_startXMLParserRequestOperationWithRequest:(NSURLRequest *)urlRequest;


#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED

/*!
 * A convenience around AFXMLRequestOperation's
 * +XMLDocumentRequestOperationWithRequest:success:failure: that returns a tuple with the resulting
 * XMLDocument as its first element and the repsonse object as its second element.
 */
+ (instancetype)rac_startXMLDocumentRequestOperationWithRequest:(NSURLRequest *)urlRequest;
#endif

@end

