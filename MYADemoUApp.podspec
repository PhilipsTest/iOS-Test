require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|
  s.name         = 'MYADemoUApp'
  s.version      = VersionCDP2Platform
  s.homepage     = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'
  s.summary      = 'Demo micro app for My Account'
  s.platform     = :ios, "11.0"
  s.author       = 'Philips Connected Digital Propositions'
  s.license      = { :type => 'Philips', :text => <<-LICENSE
                    © Koninklijke Philips N.V., 2017. All rights reserved.
                    LICENSE
                    }
  s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/mya_#commithash#.zip' }

  s.requires_arc = true

  s.dependency 'MyAccount'
  s.dependency "AppInfra", DependencyCDP2Platform
  s.dependency "UAPPFramework", DependencyCDP2Platform
  s.dependency 'PhilipsRegistration', DependencyCDP2Platform
  s.dependency 'ConsentWidgets'

  s.swift_version = '5.1'

  s.subspec 'Source' do |source|
      source.source_files  = [
          'Source/mya/Source/DemoUApp/Classes/**/*.{h,m,swift}' ]
          s.resources = ['Source/mya/Source/DemoUApp/Assets/*.{storyboard,xcassets,lproj,png,ttf}' ]

  end
  s.ios.deployment_target  = '11.0'
end
