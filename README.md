##AFNetworking-RACExtensions

[![Build Status](https://travis-ci.org/CodaFi/AFNetworking-RACExtensions.svg?branch=master)](https://travis-ci.org/CodaFi/AFNetworking-RACExtensions)

AFNetworking+RACExtensions is a delightful extension to the AFNetworking
networking library for iOS and Mac OS X.  It's built on top of
[ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa),
[AFNetworking](https://github.com/AFNetworking/AFNetworking), extending the
powerful high-level networking abstractions built into AFNetorking by lifting
them into the Reactive world.  It has a modular architecture with well-designed,
feature-rich APIs that are a joy to use.

##Getting Started

Request signals work in much the same way you would expect them to.  Any request
that is subscribed to is automatically enqueued and the results, be they errors
or JSON, are sent back to you the subscriber.  For example

```Objective-C
AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc]
initWithBaseURL:url];
manager.requestSerializer = [AFJSONRequestSerializer serializer];
manager.responseSerializer = [AFJSONResponseSerializer serializer];

[[manager rac_GET:path parameters:params] subscribeNext:^(id JSON) {
    //Voila, magical JSON…
}];
```

##Requirements

AFNetworking 1.0 and higher requires either [iOS 5.0](http://developer.apple.com/library/ios/#releasenotes/General/WhatsNewIniPhoneOS/Articles/iPhoneOS4.html) and above, or [Mac OS 10.8](http://developer.apple.com/library/mac/#releasenotes/MacOSX/WhatsNewInOSX/Articles/MacOSX10_6.html#//apple_ref/doc/uid/TP40008898-SW7) ([64-bit with modern Cocoa runtime](https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtVersionsPlatforms.html)) and above.

##Contact

[Robert Widmann](https://github.com/CodaFi)  
[@CodaFi_](https://twitter.com/CodaFi_)

##License

AFNetworking+RACExtensions is available free of change under the Open Source license, along with the MIT license that AFNetworking uses.  Use it at your own risk.

