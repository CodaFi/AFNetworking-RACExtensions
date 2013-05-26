//
//  RAFHTTPClientSpec.m
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 5/7/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "AFHTTPClient+RAFMocking.h"

SpecBegin(RAFHTTPClient)

__block AFHTTPClient *client = nil;

beforeEach(^{
	NSString *urlString = @"http://example.com/";
	client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:urlString]];
});

describe(@"-rac_getPath:parameters:", ^{
	it(@"should create an immutable signal", ^{
		RACSignal *getSignal = [client mock_getPath:@"http://www.example.com" parameters:nil];
		expect(getSignal).notTo.beNil();
		expect(^{
			[getSignal performSelector:@selector(sendNext:) withObject:NSNull.null];
		}).to.raise(NSInvalidArgumentException);
		expect(^{
			[getSignal performSelector:@selector(sendError:) withObject:NSNull.null];
		}).to.raise(NSInvalidArgumentException);
		expect(^{
			[getSignal performSelector:@selector(sendCompleted)];
		}).to.raise(NSInvalidArgumentException);
	});
	
	it(@"should GET a path", ^{
		[[client mock_getPath:@"http://www.example.com" parameters:nil]subscribeNext:^(id x) {
			expect(x).notTo.beNil();
			expect(x).to.equal(AFHTTPClientMockResponse);
		}];
	});
});

describe(@"-rac_putPath:parameters:", ^{
	it(@"should create an immutable signal", ^{
		RACSignal *putSignal = [client rac_postPath:@"http://www.example.com" parameters:nil];
		expect(putSignal).notTo.beNil();
		expect(^{
			[putSignal performSelector:@selector(sendNext:) withObject:NSNull.null];
		}).to.raise(NSInvalidArgumentException);
		expect(^{
			[putSignal performSelector:@selector(sendError:) withObject:NSNull.null];
		}).to.raise(NSInvalidArgumentException);
		expect(^{
			[putSignal performSelector:@selector(sendCompleted)];
		}).to.raise(NSInvalidArgumentException);
	});
	
	it(@"should GET a path", ^{
		[[client mock_putPath:@"http://www.example.com" parameters:nil]subscribeNext:^(id x) {
			expect(x).notTo.beNil();
			expect(x).to.equal(AFHTTPClientMockResponse);
		}];
	});
});

describe(@"-rac_postPath:parameters:", ^{
	it(@"should create an immutable signal", ^{
		RACSignal *postSignal = [client rac_postPath:@"http://www.example.com" parameters:nil];
		expect(postSignal).notTo.beNil();
		expect(^{
			[postSignal performSelector:@selector(sendNext:) withObject:NSNull.null];
		}).to.raise(NSInvalidArgumentException);
		expect(^{
			[postSignal performSelector:@selector(sendError:) withObject:NSNull.null];
		}).to.raise(NSInvalidArgumentException);
		expect(^{
			[postSignal performSelector:@selector(sendCompleted)];
		}).to.raise(NSInvalidArgumentException);
	});
	
	it(@"should GET a path", ^{
		[[client mock_postPath:@"http://www.example.com" parameters:nil]subscribeNext:^(id x) {
			expect(x).notTo.beNil();
			expect(x).to.equal(AFHTTPClientMockResponse);
		}];
	});
});

describe(@"-rac_deletePath:parameters:", ^{
	it(@"should create an immutable signal", ^{
		RACSignal *deleteSignal = [client rac_deletePath:@"http://www.example.com" parameters:nil];
		expect(deleteSignal).notTo.beNil();
		expect(^{
			[deleteSignal performSelector:@selector(sendNext:) withObject:NSNull.null];
		}).to.raise(NSInvalidArgumentException);
		expect(^{
			[deleteSignal performSelector:@selector(sendError:) withObject:NSNull.null];
		}).to.raise(NSInvalidArgumentException);
		expect(^{
			[deleteSignal performSelector:@selector(sendCompleted)];
		}).to.raise(NSInvalidArgumentException);
	});
	
	it(@"should GET a path", ^{
		[[client mock_deletePath:@"http://www.example.com" parameters:nil]subscribeNext:^(id x) {
			expect(x).notTo.beNil();
			expect(x).to.equal(AFHTTPClientMockResponse);
		}];
	});
});

describe(@"-rac_patchPath:parameters:", ^{
	it(@"should create an immutable signal", ^{
		RACSignal *patchSignal = [client rac_patchPath:@"http://www.example.com" parameters:nil];
		expect(patchSignal).notTo.beNil();
		expect(^{
			[patchSignal performSelector:@selector(sendNext:) withObject:NSNull.null];
		}).to.raise(NSInvalidArgumentException);
		expect(^{
			[patchSignal performSelector:@selector(sendError:) withObject:NSNull.null];
		}).to.raise(NSInvalidArgumentException);
		expect(^{
			[patchSignal performSelector:@selector(sendCompleted)];
		}).to.raise(NSInvalidArgumentException);
	});
	
	it(@"should GET a path", ^{
		[[client mock_patchPath:@"http://www.example.com" parameters:nil]subscribeNext:^(id x) {
			expect(x).notTo.beNil();
			expect(x).to.equal(AFHTTPClientMockResponse);
		}];
	});
});

SpecEnd