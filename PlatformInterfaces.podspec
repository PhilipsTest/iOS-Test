require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|
  s.name     = 'PlatformInterfaces'
  s.module_name = 'PlatformInterfaces'
  s.authors  = { :type => 'Philips', :text => <<-LICENSE
                    © Koninklijke Philips N.V., 2017. All rights reserved.
                    LICENSE
                    }
  s.version  = VersionCDP2Platform
  s.homepage = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'
  s.summary  = 'Platform Interfaces contains the interfaces to get acces to the different platform components'
  s.platform = :ios, "11.0"
  s.license  = { :type => 'Philips', :text => <<-LICENSE
                    © Koninklijke Philips N.V., 2017. All rights reserved.
                    LICENSE
               }
  
  s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/pif_#commithash#.zip' }

  s.requires_arc = true
  s.default_subspec = 'Source'
  s.swift_version = '5.1'
  s.ios.deployment_target  = '11.0'
  s.subspec 'Source' do |source|
    source.source_files = [ 'Source/pif/PlatformInterfaces/PlatformInterfaces/**/*.{h,swift}' ]
    source.public_header_files = [ 'Source/pif/PlatformInterfaces/PlatformInterfaces/PlatformInterfaces.h' ]
  end

 end
