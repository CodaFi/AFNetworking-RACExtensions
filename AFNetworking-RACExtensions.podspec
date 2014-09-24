Pod::Spec.new do |s|
  s.name         = "AFNetworking-RACExtensions"
  s.version      = "0.1.3"
  s.summary      = "AFNetworking-RACExtensions is a delightful extension to the AFNetworking classes for iOS and Mac OS X."
  s.homepage     = "https://github.com/CodaFi/AFNetworking-RACExtensions"
  s.license      = { :type => 'MIT', :file => 'LICENSE' }
  s.author       = { "Robert Widmann" => "devteam.codafi@gmail.com" }
  s.source       = { :git => "https://github.com/CodaFi/AFNetworking-RACExtensions.git", :tag => "#{s.version}" }
  s.ios.deployment_target = '6.0'
  s.osx.deployment_target = '10.8'
  s.source_files = 'RACAFNetworking'
  s.requires_arc = true
  s.dependency 'AFNetworking', '~> 2.0'
  s.dependency 'ReactiveCocoa', '~> 2.0'
end
