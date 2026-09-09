#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint nano_core.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'nano_core'
  s.version          = '1.0.3'
  s.summary          = 'Nano Core Flutter Plugin'
  s.description      = <<-DESC
A lightweight reactive architecture framework and design system toolkit for Flutter multiplatform applications.
                       DESC
  s.homepage         = 'https://nanodevs.com.br'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'NanoDevs' => 'contato@nanodevs.com.br' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*', 'nano_core/Sources/nano_core/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '12.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
