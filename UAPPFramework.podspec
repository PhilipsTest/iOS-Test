require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|
s.name         = "UAPPFramework"
s.version      = VersionCDP2Platform
s.homepage     = 'https://dev.azure.com/PhilipsAgile/8.0%20DC%20Innovations%20(IET)/_git/mobile-plf-ios'
s.summary      = "A framework to guide all other CoCo for Common Interface "
s.platform     = :ios, "11.0"
s.author       = 'Philips Connected Digital Propositions'
s.license      = { :type => 'Philips', :text => <<-LICENSE
© Koninklijke Philips N.V., 2018. All rights reserved.
LICENSE
}
s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/ufw_#commithash#.zip' }

s.requires_arc = true
s.swift_version = '5.1'
s.default_subspec = 'Source'

s.subspec 'Source' do |source|
source.source_files  = ['Source/ufw/Source/Library/UAPPFramework/**/*.{h,m,swift}','Source/ufw/Source/Library/FlowManager/**/*.{h,m,swift}','Source/Library/DataInterface/*.{h,m,swift}']
end

s.subspec 'Binary' do |binary|
binary.ios.vendored_frameworks = 'Source/ufw/Source/ufw/Binary/UAPPFramework/Framework/UAPPFramework.framework'
end

s.dependency 'AppInfra', DependencyCDP2Platform
s.ios.deployment_target  = '11.0'
end

