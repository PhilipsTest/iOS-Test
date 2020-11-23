require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|
  s.name         = "PIM"
  s.module_name  = 'PIM'
  s.version      = VersionCDP2Platform
  s.homepage     = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'
  s.summary      = "Philips Identity Management framework."
  s.platform     = :ios, "11.0"
  s.author       = 'Philips Connected Digital Propositions'
  s.license      = { :type => 'Philips', :text => <<-LICENSE
                    © Koninklijke Philips N.V., 2015. All rights reserved.
                    LICENSE
                    }

  s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/pim_#commithash#.zip' }

  s.requires_arc = true
  s.swift_version = '5.1'
  s.default_subspec = 'Source'
  s.ios.deployment_target  = '11.0'
  s.dependency 'UAPPFramework', DependencyCDP2Platform
  s.dependency 'PhilipsUIKitDLS', PhilipsUIKitDLSVersion
  s.dependency 'AppAuth', '1.4.0'
  s.dependency 'SFHFKeychainUtils', '1.0.0'

  s.subspec 'Source' do |source|
      source.source_files  = [
          'Source/pim/Source/Library/PIM/**/*.{h,m,swift}' ]
          s.resources = ['Source/pim/Source/Library/PIM/**/*.{storyboard,xcassets,lproj}' ]
  end

end
