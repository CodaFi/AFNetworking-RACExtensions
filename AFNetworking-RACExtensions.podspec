# Copied from:
#   https://github.com/CocoaPods/Specs/blob/master/AFNetworking-RACExtensions/0.1.2/AFNetworking-RACExtensions.podspec
#

Pod::Spec.new do |s|
  s.name         = "AFNetworking-RACExtensions"
  s.version      = "0.1.3"
  s.summary      = "AFNetworking-RACExtensions is a delightful extension to the AFNetworking classes for iOS and Mac OS X."
  s.homepage     = "https://github.com/CodaFi/AFNetworking-RACExtensions"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Robert Widmann" => "devteam.codafi@gmail.com" }
  s.source       = { :git => "https://github.com/CodaFi/AFNetworking-RACExtensions.git", :tag => "0.1.3" }
  s.ios.deployment_target = '5.0'
  s.osx.deployment_target = '10.7'
  s.source_files = 'ReactiveAFNetworking'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 1.0'
  s.dependency 'ReactiveCocoa', '~> 2.1'
end
