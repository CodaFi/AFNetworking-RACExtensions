//
//  RAFHTTPClientSpec.m
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 5/7/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

SpecBegin(RAFHTTPClient)

__block AFHTTPClient *client = nil;

beforeEach(^{
	NSString *urlString = @"http://example.com/";
	client = [AFHTTPClient clientWithBaseURL:[NSURL URLWithString:urlString]];
});

describe(@"-rac_getPath:parameters:", ^{
	
	it(@"should create", ^{
client rac_getPath:<#(NSString *)#> parameters:<#(NSDictionary *)#>
	});
});

SpecEnd