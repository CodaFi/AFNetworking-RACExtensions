<snark>

AFNetworking-RACExtensions is a delightful extension to the AFNetworking classes for iOS and Mac OS X. It's built on top of [ReactiveCocoa](https://github.com/ReactiveCocoa/ReactiveCocoa), [AFNetworking](https://github.com/AFNetworking/AFNetworking), and other familiar foundation technologies. It provides an extension to the underlying modular architecture with well-designed, wrapper APIs that are… (easy?) to use. For example, here's how easy it is to get JSON from a URL:

``` objective-c
NSURL *url = [NSURL URLWithString:@"https://alpha-api.app.net/stream/0/posts/stream/global"];
NSURLRequest *request = [NSURLRequest requestWithURL:url];
AFJSONRequestOperation *operation = [[AFJSONRequestOperation rac_startJSONRequestOperationWithRequest:request]subscribeNext:^(RACTuple *JSONTuple) {
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

_BEGIN_HTML_DECLS

Read the headers. Honestly, they have some really good explanations of how to use things.

_END_HTML_DECLS

## Example Usage

### XML Request

``` objective-c
NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://api.flickr.com/services/rest/?method=flickr.groups.browse&api_key=b6300e17ad3c506e706cb0072175d047&cat_id=34427469792%40N01&format=rest"]];
AFXMLRequestOperation *operation = [[AFXMLRequestOperation rac_startXMLParserRequestOperationWithRequest:request]subscribeNext:^(RACTuple *res) {
  NSXMLParser *XMLParser = res.first;
  XMLParser.delegate = self;
  [XMLParser parse];
}];
```

### Image Request

``` objective-c
UIImageView *imageView = [[UIImageView alloc] initWithFrame:CGRectMake(0.0f, 0.0f, 100.0f, 100.0f)];
[imageView setImageWithURL:[NSURL URLWithString:@"http://i.imgur.com/r4uwx.jpg"] placeholderImage:[UIImage imageNamed:@"placeholder-avatar"]];
```

OK, even I feel short-changed by that one.  Here's how to do it using only Reactive APIs:

### (Real) Image Request

``` objective-c
RACSubject *imageSubject = [RACSubject subject];
[self.afLogoImageView rac_liftSelector:@selector(setImage:) withObjects:imageSubject];
NSURLRequest *imageRequest = [NSURLRequest requestWithURL:[NSURL URLWithString:@"https://raw.github.com/AFNetworking/AFNetworking/gh-pages/afnetworking-logo.png"]];

[[[AFImageRequestOperation rac_startImageRequestOperationWithRequest:imageRequest]map:^id(RACTuple *values) {
  return [values first];
}]subscribeNext:^(UIImage *image) {
  [imageSubject sendNext:image];
}];
```

### API Client Request

``` objective-c
// AFAppDotNetAPIClient is a subclass of AFHTTPClient, which defines the base URL and default HTTP headers for NSURLRequests it creates
[[[AFAppDotNetAPIClient sharedClient] rac_getPath:@"stream/0/posts/stream/global" parameters:nil]subscribeNext:^(RACTuple *next) {
    NSLog(@"App.net Global Stream: %@", next.first);
}];
```

### File Upload with Progress Callback

``` objective-c
NSURL *url = [NSURL URLWithString:@"http://api-base-url.com"];
AFHTTPClient *httpClient = [[AFHTTPClient alloc] initWithBaseURL:url];
NSData *imageData = UIImageJPEGRepresentation([UIImage imageNamed:@"avatar.jpg"], 0.5);
NSMutableURLRequest *request = [httpClient multipartFormRequestWithMethod:@"POST" path:@"/upload" parameters:nil constructingBodyWithBlock: ^(id <AFMultipartFormData>formData) {
    [formData appendPartWithFileData:imageData name:@"avatar" fileName:@"avatar.jpg" mimeType:@"image/jpeg"];
}];

AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
[operation setUploadProgressBlock:^(NSUInteger bytesWritten, long long totalBytesWritten, long long totalBytesExpectedToWrite) {
    NSLog(@"Sent %lld of %lld bytes", totalBytesWritten, totalBytesExpectedToWrite);
}];
[[httpClient rac_enqueueHTTPRequestOperation:operation]subscribeCompleted:^{
  //We're Done here
}];
```

### Streaming Request

``` objective-c
NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:@"http://localhost:8080/encode"]];

AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
operation.inputStream = [NSInputStream inputStreamWithFileAtPath:[[NSBundle mainBundle] pathForResource:@"large-image" ofType:@"tiff"]];
operation.outputStream = [NSOutputStream outputStreamToMemory];
[[operation rac_start]subscribeCompleted^{

}];
```

## Requirements

AFNetworking 1.0 and higher requires either [iOS 5.0](http://developer.apple.com/library/ios/#releasenotes/General/WhatsNewIniPhoneOS/Articles/iPhoneOS4.html) and above, or [Mac OS 10.7](http://developer.apple.com/library/mac/#releasenotes/MacOSX/WhatsNewInOSX/Articles/MacOSX10_6.html#//apple_ref/doc/uid/TP40008898-SW7) ([64-bit with modern Cocoa runtime](https://developer.apple.com/library/mac/#documentation/Cocoa/Conceptual/ObjCRuntimeGuide/Articles/ocrtVersionsPlatforms.html)) and above.

For compatibility with iOS 4.3, use the latest 0.10.x release of AFNetworking.  In theory, ReactiveCocoa could work across most iOS versions, but you'd be wise to support only 4.0+ when using the extensions.

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