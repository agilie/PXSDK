#
# Be sure to run `pod lib lint PXSDK.podspec' to ensure this is a
# valid spec and remove all comments before submitting the spec.
#
# Any lines starting with a # are optional, but encouraged
#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = "PXSDK"
  s.version          = "0.1.0"
  s.summary          = "PXSDK is IOS SDK for game analytic platform"
  s.description      = <<-DESC
                       PXSDK is IOS SDK for game analytic platform

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/agilie/PXSDK"
  # s.screenshots     = "www.example.com/screenshots_1", "www.example.com/screenshots_2"
  s.license          = 'MIT'
  s.author           = { "Ankudinov Alexander" => "sasha@ankudinov.org.ua" }
  s.source           = { :git => "https://github.com/agilie/PXSDK.git", :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/ankudinovsky'

  s.platform     = :ios, '7.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'


  s.public_header_files = 'Pod/Classes/**/GITracker.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
