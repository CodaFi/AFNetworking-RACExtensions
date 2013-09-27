//
//  AFHTTPRequestOperation+RACSupport.m
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "AFURLConnectionOperation+RACSupport.h"
#import "AFHTTPRequestOperation.h"

@implementation AFURLConnectionOperation (RACSupport)

- (RACSignal*)rac_start {
	[self start];
	return [self rac_overrideHTTPCompletionBlock];
}

- (RACSignal*)rac_overrideHTTPCompletionBlock {
	RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
	[subject setNameWithFormat:@"-rac_start: %@", self.request.URL];
	
	if ([self respondsToSelector:@selector(setCompletionBlockWithSuccess:failure:)]) {
		
#ifdef RAFN_MAINTAIN_COMPLETION_BLOCKS
		void (^oldCompBlock)() = self.completionBlock;
#endif
		[(AFHTTPRequestOperation*)self setCompletionBlockWithSuccess:^(id operation, id responseObject) {
			[subject sendNext:responseObject];
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

@implementation AFImageRequestOperation (RACSupport)

+ (RACSignal *)rac_startImageRequestOperationWithRequest:(NSURLRequest *)urlRequest {
	
	RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
	
	[(AFURLConnectionOperation*)[self imageRequestOperationWithRequest:urlRequest imageProcessingBlock:NULL
															   success:^(NSURLRequest *request, NSHTTPURLResponse *response,
#if defined(__IPHONE_OS_VERSION_MIN_REQUIRED)
																		 UIImage *image
#elif defined(__MAC_OS_X_VERSION_MIN_REQUIRED)
																		 NSImage *image
#endif
																		 ) {
		[subject sendNext:RACTuplePack(image, response)];
		[subject sendCompleted];
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error) {
		[subject sendError:error];
	}]start];
	
	return subject;
}

@end

@implementation AFJSONRequestOperation (RACSupport)

+ (RACSignal *)rac_startJSONRequestOperationWithRequest:(NSURLRequest *)urlRequest {
	
	RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
	
	[(AFURLConnectionOperation*)[self JSONRequestOperationWithRequest:urlRequest
															  success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON) {
		[subject sendNext:RACTuplePack(JSON, response)];
		[subject sendCompleted];
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
		[subject sendError:error];
	}]start];
	
	return subject;
}

@end

@implementation AFPropertyListRequestOperation (RACSupport)

+ (RACSignal *)rac_startPropertyListRequestOperationWithRequest:(NSURLRequest *)urlRequest {
	
	RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];

	[(AFURLConnectionOperation*)[self propertyListRequestOperationWithRequest:urlRequest
																	  success:^(NSURLRequest *request, NSHTTPURLResponse *response, id propertyList) {
		[subject sendNext:RACTuplePack(propertyList, response)];
		[subject sendCompleted];
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id propertyList) {
		[subject sendError:error];
	}]start];
	
	return subject;
}

@end

@implementation AFXMLRequestOperation (RACSupport)

+ (RACSignal *)rac_startXMLParserRequestOperationWithRequest:(NSURLRequest *)urlRequest {
	RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
	
	[(AFURLConnectionOperation*)[self XMLParserRequestOperationWithRequest:urlRequest
																   success:^(NSURLRequest *request, NSHTTPURLResponse *response, id xmlEntity) {
		[subject sendNext:RACTuplePack(xmlEntity, response)];
		[subject sendCompleted];
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id xmlEntity) {
		[subject sendError:error];
	}]start];
	
	return subject;
}

#ifdef __MAC_OS_X_VERSION_MIN_REQUIRED
+ (instancetype)rac_startXMLDocumentRequestOperationWithRequest:(NSURLRequest *)urlRequest {
	RACReplaySubject *subject = [RACReplaySubject replaySubjectWithCapacity:1];
	
	[(AFURLConnectionOperation*)[self XMLDocumentRequestOperationWithRequest:urlRequest
																   success:^(NSURLRequest *request, NSHTTPURLResponse *response, id xmlEntity) {
	   [subject sendNext:RACTuplePack(xmlEntity, response)];
	   [subject sendCompleted];
	} failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id xmlEntity) {
	   [subject sendError:error];
   }]start];
	
	return subject;
}
#endif

@end

