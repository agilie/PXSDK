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
  s.version          = "0.2.1"
  s.summary          = "PXSDK is iOS game analytics SDK"
  s.description      = <<-DESC
                       Here goes a very long description for PXSDK is iOS game analytics SDK

                       * Markdown format.
                       * Don't worry about the indent, we strip it!
                       DESC
  s.homepage         = "https://github.com/agilie/PXSDK"
  s.license          = 'GPLv2'
  s.author           = { "Sid sid99" => "dsid99@gmail.com" }
  s.source           = { :git => "https://github.com/agilie/PXSDK.git" }

  s.platform     = :ios, '8.0'
  s.requires_arc = true

  s.source_files = 'Pod/Classes/**/*'


  s.public_header_files = 'Pod/Classes/**/*.h'
end
