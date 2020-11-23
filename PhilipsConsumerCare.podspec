require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|

s.name = 'PhilipsConsumerCare'
s.authors = 'Koninklijke Philips N.V.'
s.module_name = 'PhilipsConsumerCare'
s.license = 'proprietary'
s.version = VersionCDP2Platform
s.platform = :ios, "11.0"
s.homepage     = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'
s.summary = 'Philips Consumer Care - Horizontal Component'

s.dependency 'PhilipsProductSelection', DependencyCDP2Platform
s.dependency 'UAPPFramework', DependencyCDP2Platform
s.dependency 'PhilipsUIKitDLS', PhilipsUIKitDLSVersion
s.dependency 'AppInfra', DependencyCDP2Platform
s.dependency  'PhilipsPRXClient', DependencyCDP2Platform

s.ios.deployment_target  = '11.0'
s.swift_version = '5.1'

  s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/dcc_#commithash#.zip' }

 s.public_header_files = ["Source/dcc/Source/Library/PhilipsConsumerCare/CommonInterface/DCDependencies.h",
                          "Source/dcc/Source/Library/PhilipsConsumerCare/CommonInterface/DCInterface.h",
                          "Source/dcc/Source/Library/PhilipsConsumerCare/CommonInterface/DCLaunchInput.h",
                          "Source/dcc/Source/Library/PhilipsConsumerCare/DCProtocols/DCMainMenuProtocol.h",
                          "Source/dcc/Source/Library/PhilipsConsumerCare/DCProtocols/DCProductMenuProtocol.h",
                          "Source/dcc/Source/Library/PhilipsConsumerCare/DCUtilities/DCConsumerCareVersion.h",
                          "Source/dcc/Source/Library/PhilipsConsumerCare/DCProtocols/DCSocialMenuProtocol.h",
                      "Source/dcc/Source/Library/PhilipsConsumerCare/DCConfiguration/DCConfigModels/DCContentConfiguration.h"]


s.source_files = '{Source/dcc/Source/Library/PhilipsConsumerCare}/**/*.{h,m}'
s.resource = 'Source/dcc/Source/Library/PhilipsConsumerCare/**/*.{storyboard,xib,xcassets,lproj,json}'

s.frameworks = 'CoreLocation','MapKit','Accounts','SystemConfiguration'
end
