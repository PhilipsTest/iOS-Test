require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|
  s.name         = 'PhilipsRegistrationMicroApp'
  s.version      = VersionCDP2Platform
  s.homepage     = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'
  s.summary      = 'PhilipsRegistrationMicroApp.'
  s.platform     = :ios, "11.0"
  s.author       = 'Philips Connected Digital Propositions'
  s.license      = { :type => 'Philips', :text => <<-LICENSE
                    © Koninklijke Philips N.V., 2015. All rights reserved.
                    LICENSE
                    }
  s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/usr_#commithash#.zip' }
  s.requires_arc = true
 # s.default_subspec = 'Source'

  s.subspec 'Source' do |source|
      source.source_files  = [
          'Source/usr/Source/Library/RegistrationIOS/DemoGenderDOBViewController.{h,m}',
          'Source/usr/Source/Library/RegistrationIOS/TestAppViewController.{h,m}',
          'Source/usr/Source/Library/RegistrationIOS/ServiceDiscoveryMocked.{h,m}',
          'Source/usr/Source/Library/RegistrationIOS/Exception Handling/GTM/GTMStackTrace.{h,m}',
          'Source/usr/Source/Library/RegistrationIOS/Exception Handling/URExceptionHandler.{h,m}',
          'Source/usr/Source/DemoUApp/USRDemoUApp/**/*.{h,m,swift}',
          'Source/usr/Source/Library/RegistrationIOS/**/*.{swift}',
      ]
      source.resources = ['Source/usr/Source/Library/RegistrationIOS/Registration.{storyboard}',
          'Source/usr/Source/Library/RegistrationIOS/.{json}',
          'Source/usr/Source/Library/RegistrationIOS/Assets.xcassets'
      ]
  end

 s.dependency 'PhilipsRegistration', DependencyCDP2Platform
 s.ios.deployment_target  = '11.0'
 s.swift_version = '5.1'
end
