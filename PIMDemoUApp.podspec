require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|
  s.name         = "PIMDemoUApp"
  s.version      = VersionCDP2Platform
  s.homepage     = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'
  s.summary      = "Demo micro app of PIM"
  s.platform     = :ios, "11.0"
  s.author       = 'Philips Connected Digital Propositions'
  s.license      = { :type => 'Philips', :text => <<-LICENSE
                    © Koninklijke Philips N.V., 2015. All rights reserved.
                    LICENSE
                    }
  s.source  = { :http => 'https://artifactory-ehv.ta.philips.com:8082/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/pim_#commithash#.zip' }

  s.requires_arc = true
  s.swift_version = '5.1'

  s.dependency 'PIM'
  s.dependency 'PhilipsRegistration', DependencyCDP2Platform
  s.dependency 'PhilipsProductRegistrationUApp', DependencyCDP2Platform
  s.dependency 'ECSTestUApp', DependencyCDP2Platform
  s.dependency 'InAppPurchase', DependencyCDP2Platform
  s.dependency 'MobileEcommerceDemoUApp', DependencyCDP2Platform
  s.ios.deployment_target  = '11.0'

  s.subspec 'Source' do |source|
      source.source_files  = [
          'Source/pim/Source/DemoUApp/PIMDemoUApp/**/*.{h,swift}' ]
          source.resources = ['Source/pim/Source/DemoUApp/PIMDemoUApp/**/**/*.{storyboard,xcassets,lproj}' ]
  end

end
