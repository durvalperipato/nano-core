#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint nano_core.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'nano_core'
  s.version          = '1.0.2'
  s.summary          = 'Nano Core macOS Plugin'
  s.description      = <<-DESC
A lightweight reactive architecture framework and design system toolkit for Flutter multiplatform applications.
                       DESC
  s.homepage         = 'https://nanodevs.com.br'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'NanoDevs' => 'contato@nanodevs.com.br' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'FlutterMacOS'
  s.platform = :osx, '10.14'

  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES' }
  s.swift_version = '5.0'
end
