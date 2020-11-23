require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|
s.name         = 'ConsumerCareMicroApp'
s.version      = VersionCDP2Platform
s.homepage     = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'
s.summary      = 'PhilipsConsumerCare'
s.platform     = :ios, "11.0"
s.dependency 'PhilipsConsumerCare', DependencyCDP2Platform
s.author       = 'Koninklijke Philips N.V.'
s.license      = { :type => 'Philips', :text => <<-LICENSE
© Koninklijke Philips N.V., 2015. All rights reserved.
LICENSE
}
  s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/dcc_#commithash#.zip' }

s.requires_arc = true
s.swift_version = '5.1'
s.ios.deployment_target  = '11.0'
s.default_subspec = 'Source'

s.subspec 'Source' do |source|
s.dependency 'PhilipsConsumerCare', DependencyCDP2Platform
s.dependency 'PhilipsProductSelection', DependencyCDP2Platform

source.source_files = ["Source/dcc/Source/DemoUApp/ConsumerCareMicroApp/**/*.{h,m}",
	                   "Source/dcc/Source/Library/DCCountrySelectionViewController.{h,m}",
                       "Source/dcc/Source/Library/PhilipsConsumerCareDemo/DCDemoViewController.{h,m}",
                       "Source/dcc/Source/Library/PhilipsConsumerCareDemo/DLSTheme/*.{swift}" ]
s.resources = [ "Source/dcc/Source/DemoUApp/ConsumerCareMicroApp/Resources/images/*.{png}","Source/dcc/Source/DemoUApp/ConsumerCareMicroApp/*.{storyboard}","Source/dcc/Source/DemoUApp/ConsumerCareMicroApp/Resources/Plist/*.{plist}","Source/dcc/Source/DemoUApp/ConsumerCareMicroApp/Resources/*.{strings}"]
end

end
