//
//  RAFNMainViewController.m
//  Reactive AFNetworking Example
//
//  Created by Robert Widmann on 3/28/13.
//  Copyright (c) 2013 CodaFi. All rights reserved.
//

#import "RAFNMainViewController.h"
#import "RACAFNetworking.h"
#import <ReactiveCocoa/UIControl+RACSignalSupport.h>
#import "AFURLConnectionOperation+RACSupport.h"
#import <AFNetworking/AFURLResponseSerialization.h>

//Preserve double completion blocks for testing
#define RAFN_MAINTAIN_COMPLETION_BLOCKS

@interface RAFNMainViewController () 

@property (nonatomic, strong) UITextView *statusTextView;
@property (nonatomic, strong) UIImageView *afLogoImageView;
@property (nonatomic, strong) UIButton *startTestingButton;
@property (nonatomic, strong) AFHTTPRequestOperationManager *httpClient;
@property (nonatomic, assign) BOOL isTesting;

@property (nonatomic, strong) RACDisposable *currentDisposable;
@property (nonatomic, strong) RACSubject *statusSignal;

@end

@implementation RAFNMainViewController 

- (id)init
{
	self = [super init];
	if (self) {
		//Signal for the textview's text
		_statusSignal = [RACSubject subject];
	}
	return self;
}

- (void)viewDidLoad
{
	// Do any additional setup after loading the view.
	CGRect slice, remainder;
	CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMaxYEdge);

	self.statusTextView = [[UITextView alloc]initWithFrame:remainder];
	self.statusTextView.editable = NO;
	self.statusTextView.font = [UIFont fontWithName:@"Helvetica" size:20.0f];
	[self.statusTextView setTextAlignment:NSTextAlignmentCenter];
	[self.statusTextView rac_liftSelector:@selector(setText:) withSignals:self.statusSignal, nil];
	
	self.afLogoImageView = [[UIImageView alloc]initWithFrame:CGRectOffset(remainder, 0, CGRectGetHeight(UIScreen.mainScreen.bounds))];
	self.startTestingButton = [UIButton buttonWithType:UIButtonTypeRoundedRect];
	[self.startTestingButton setTitle:@"Start Testing" forState:UIControlStateNormal];
	self.startTestingButton.frame = self.view.bounds;
	
	[[self.startTestingButton rac_signalForControlEvents:UIControlEventTouchUpInside]subscribeNext:^(UIButton *testingButton) {
		self.isTesting = !self.isTesting;
		[testingButton setTitle:(self.isTesting ? @"Cancel Testing..." : @"Start Testing") forState:UIControlStateNormal];
		[UIView animateWithDuration:0.5 animations:^{
			[testingButton setFrame:(self.isTesting ? slice : self.view.bounds)];
		}];
		if (self.isTesting) {
			[self testImageFetch];
		} else {
			[self cancelTheShow];
			
		}
	}];
	
	[self.view addSubview:self.statusTextView];
	[self.view addSubview:self.afLogoImageView];
	[self.view addSubview:self.startTestingButton];
	
	//Get network status
	self.httpClient = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:[NSURL URLWithString:@"https://www.google.com"]];
	
	[self.httpClient.networkReachabilityStatusSignal subscribeNext:^(NSNumber *status) {
		AFNetworkReachabilityStatus networkStatus = [status intValue];
		switch (networkStatus) {
			case AFNetworkReachabilityStatusUnknown:
			case AFNetworkReachabilityStatusNotReachable:
				[self.statusSignal sendNext:@"Cannot Reach Host"];
				[self cancelTheShow];
				break;
			case AFNetworkReachabilityStatusReachableViaWWAN:
			case AFNetworkReachabilityStatusReachableViaWiFi:
				break;
		}
		
	}];
	
	[super viewDidLoad];
}

- (void)testImageFetch {
	//Fetch the image.  WHen fetched, animate the logo image up, then down and start the next test.
	[self.statusSignal sendNext:@"Fetching AFNetworking Logo..."];
	
	RACSubject *imageSubject = [RACSubject subject];
	[self.afLogoImageView rac_liftSelector:@selector(setImage:) withSignals:imageSubject, nil];
	
	NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://twimg0-a.akamaihd.net/profile_images/2331579964/jrqzn4q29vwy4mors75s.png"]];

	AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc]initWithRequest:imageRequest];
	operation.responseSerializer = [AFImageResponseSerializer serializer];
	
	_currentDisposable = [[[operation rac_start]map:^id(RACTuple *value) {
		return [value second];
	}]subscribeNext:^(UIImage *image) {
		[imageSubject sendNext:image];
		CGRect slice, remainder;
		CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMaxYEdge);
		[UIView animateWithDuration:0.5 animations:^{
			[self.afLogoImageView setFrame:remainder];
		} completion:^(BOOL finished) {
			[UIView animateWithDuration:0.5 delay:1 options:0 animations:^{
				[self.afLogoImageView setFrame:CGRectOffset(remainder, 0, CGRectGetHeight(UIScreen.mainScreen.bounds))];
			} completion:^(BOOL finished) {
				[self testXMLFetch];
			}];
		}];
	}];
}

- (void)testXMLFetch {
	//Fetch the Flickr feed for groups.
	[self.statusSignal sendNext:@"Fetching Flickr XML..."];

	NSURLRequest *flickrRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.flickr.com/services/rest/?method=flickr.groups.browse&api_key=b6300e17ad3c506e706cb0072175d047&cat_id=34427469792%40N01&format=rest"]];
	
	AFHTTPRequestOperation* operation = [[AFHTTPRequestOperation alloc]initWithRequest:flickrRequest];
	operation.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	_currentDisposable = [[[operation rac_start]map:^id(RACTuple *value) {
		return [value first];
	}]subscribeNext:^(AFHTTPRequestOperation *operation) {
		[self.statusSignal sendNext:operation.response.allHeaderFields.description];
		
		[self performSelector:@selector(testError) withObject:nil afterDelay:0.5];
	}];
}

- (void)testError
{
	[self.statusSignal sendNext:@"Sending Error-Prone Request..."];
	
	//Send an un-authorized request to show how error blocks work.
	NSString *urlStr = @"https://api.twitter.com/1.1/";
	NSURL *url = [NSURL URLWithString:urlStr];
	NSDictionary *params = [[NSDictionary alloc]initWithObjectsAndKeys:@"json", @"format", @"66854529@N00", @"user_id", @"1", @"nojsoncallback", nil];
	NSString *path = [[NSString alloc]initWithFormat:@"statuses/mentions_timeline"];
	
	AFHTTPRequestOperationManager *client = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:url];
	client.responseSerializer = [AFHTTPResponseSerializer serializer];

	NSMutableURLRequest *af_request = [client.requestSerializer requestWithMethod:@"GET" URLString:[[NSURL URLWithString:path relativeToURL:url] absoluteString] parameters:params];
	AFHTTPRequestOperation* operation = [client HTTPRequestOperationWithRequest:af_request success:Nil failure:nil];

	NSLog(@"Test error request %@",[af_request description]);
	NSLog(@"Test error request %@",af_request.allHTTPHeaderFields);
	NSURL* myUrl = af_request.URL;
	NSLog(@"Test error url %@",[myUrl description]);
	
	_currentDisposable = [[operation rac_start]subscribeError:^(NSError *error) {
		[self.statusSignal sendNext:[error localizedDescription]];
		
		[self performSelector:@selector(fetchRAC) withObject:nil afterDelay:1];
	}];
}

- (void)fetchRAC {
	//Double fetch completion blocks to show that RAC doesn't have to overwrite your completion
	//blocks
	[self.statusSignal sendNext:@"Fetching With Double Completion Blocks..."];
	
	NSURLRequest *flickrRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.flickr.com/services/rest/?method=flickr.groups.browse&api_key=b6300e17ad3c506e706cb0072175d047&cat_id=34427469792%40N01&format=rest"]];

	AFHTTPRequestOperation* reqOp = [[AFHTTPRequestOperation alloc]initWithRequest:flickrRequest];
	reqOp.responseSerializer = [AFXMLParserResponseSerializer serializer];
	
	[reqOp setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, NSXMLParser *XMLParser) {
		NSLog(@"Inner Comp");
	} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
		NSLog(@"Inner Error");
	}];

	_currentDisposable = [[reqOp rac_start]subscribeCompleted:^{
		NSLog(@"Outer Comp");
		
		[self performSelector:@selector(finish) withObject:nil afterDelay:0.5];
	}];
}

- (void)finish {
	[self.statusSignal sendNext:@"Finished!"];
	[self.startTestingButton setTitle:@"Restart Tests" forState:UIControlStateNormal];
	self.isTesting = !self.isTesting;
}

- (void)cancelTheShow {
	//Kills the current disposable and removes the image view.
	CGRect slice, remainder;
	CGRectDivide(self.view.bounds, &slice, &remainder, 44, CGRectMaxYEdge);
	
	[self.statusSignal sendNext:@""];
	[_currentDisposable dispose];
	
	[UIView animateWithDuration:0.5 animations:^{
		[self.afLogoImageView setFrame:CGRectOffset(remainder, 0, CGRectGetHeight(UIScreen.mainScreen.bounds))];
	}];
}


@end
