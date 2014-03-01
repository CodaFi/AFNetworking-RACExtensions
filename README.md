<snark>

AFNetworking-RACExtensions is a delightful extension to the AFNetworking classes for iOS and Mac OS X. It's built on top of [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa), [AFNetworking](https://github.com/AFNetworking/AFNetworking), and other familiar foundation technologies. It provides an extension to the underlying modular architecture with well-designed, wrapper APIs that are… (easy?) to use. For example, here's how easy it is to get JSON from a URL:

``` Objective-C
AFHTTPRequestOperationManager *manager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:url];
manager.requestSerializer = [AFJSONRequestSerializer serializer];
manager.responseSerializer = [AFJSONResponseSerializer serializer];

[[manager rac_GET:path parameters:params] subscribeNext:^(RACTuple *JSONTuple) {
	//Voila, magical JSON… well, maybe call `JSONTuple.first`, first.
}];
```

Perhaps the most important feature of all, however, is the amazing community of developers who use and contribute to AFNetworking and ReactiveCocoa every day. AFNetworking powers some of the most popular and critically-acclaimed apps on the iPhone, iPad, and Mac, and AFNetworking+RACExtensions powers the little sample app in this thing… so yeah. 

Choose AFNetworking, then choose AFNetworking+RACExtensions, for your next project, or migrate over your existing projects—you'll feel a shift in [die Weltanschauung](http://en.wikipedia.org/wiki/World_view) because of it!

## How To Get Started

- [Download AFNetworking](https://github.com/AFNetworking/AFNetworking/zipball/master) and try out the included Mac and iPhone example apps
- Read the ["Getting Started" guide](https://github.com/AFNetworking/AFNetworking/wiki/Getting-Started-with-AFNetworking), [FAQ](https://github.com/AFNetworking/AFNetworking/wiki/AFNetworking-FAQ), or [other articles in the wiki](https://github.com/AFNetworking/AFNetworking/wiki)
- Check out the [complete documentation](http://afnetworking.github.com/AFNetworking/) for a comprehensive look at the APIs available in AFNetworking
- Watch the [NSScreencast episode about AFNetworking](http://nsscreencast.com/episodes/6-afnetworking) for a quick introduction to how to use it in your application
- Questions? [Stack Overflow](http://stackoverflow.com/questions/tagged/afnetworking) is the best place to find answers
- [Download AFNetworking+RACExtensions](https://github.com/CodaFi/AFNetworking-RACExtensions/archive/master.zip) and try out the included iPhone sample app.
- Integrate it with your project (don't forget to run a `git submodule update -i --recursive`).
- Or integrate with [CocoaPods](https://github.com/CocoaPods/CocoaPods): ```pod 'AFNetworking-RACExtensions', '~>0.0.1'```
- Profit immensely.

## Overview

Read the headers. Honestly, they have some really good explanations of how to use things.

## Requirements

AFNetworking 1.0 and higher requires either [iOS 5.0](http://developer.apple.com/library/ios/#releasenotes/General/WhatsNewIniPhoneOS/Articles/iPhoneOS4.html) and above, or [Mac OS 10.8](http://developer.apple.com/library/mac/#releasenotes/MacOSX/WhatsNewInOSX/Articles/MacOSX10_6.html#//apple_ref/doc/uid/TP40008898-SW7) ([64-bit with modern Cocoa runtime](https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtVersionsPlatforms.html)) and above.

### ARC

AFNetworking(+RACExtensions) uses ARC as of its 1.0 release.
ReactiveCocoa has used ARC since its initial commit.

If you are using AFNetworking(+RACExtensions) 1.0 in your non-arc project, you will need to set a `-fobjc-arc` compiler flag on all of the AFNetworking(+RACExtensions) source files. Conversely, if you are adding a pre-1.0 version of AFNetworking, you will need to set a `-fno-objc-arc` compiler flag, but still use the `-fobjc-arc` flag with RAC and the Extensions.

To set a compiler flag in Xcode, go to your active target and select the "Build Phases" tab. Now select all AFNetworking source files, press Enter, insert `-fobjc-arc` or `-fno-objc-arc` and then "Done" to enable or disable ARC for AFNetworking.

## Credits

ReactiveCocoa was created by [Justin Spahr-Summers](https://github.com/jspahrsummers) and [Josh Abernathy](https://github.com/joshaber) in the pursuit of some kind of LINQ-ish - ELM - C# - Haskell something or other… It's cool, deal with it.

AFNetworking was created by [Scott Raymond](https://github.com/sco/) and [Mattt Thompson](https://github.com/mattt/) in the development of [Gowalla for iPhone](http://en.wikipedia.org/wiki/Gowalla).

AFNetworking's logo was designed by [Alan Defibaugh](http://www.alandefibaugh.com/).

And most of all, thanks to AFNetworking's [growing list of contributors](https://github.com/AFNetworking/AFNetworking/contributors).

## Contact

Follow AFNetworking on Twitter ([@AFNetworking](https://twitter.com/AFNetworking))
Don't Follow AFNetworking+RACExtensions on Twitter (404).

### ~~Creators~~ Creator

[Robert Widmann](https://github.com/CodaFi)  
[@CodaFi_](https://twitter.com/CodaFi_)

## License

AFNetworking+RACExtensions is available free of change under the Open Source license, along with the MIT license that AFNetworking uses.  Use it at your own risk.

</snark>