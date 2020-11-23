require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|
s.name         = "AppInfraMicroApp"
s.version      = VersionCDP2Platform
s.summary      = "Framework which includes Demo of features like logging ,tagging,secure storage"
s.author       = 'Koninklijke Philips N.V'
s.homepage     = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'
s.license	     = { :type => 'Philips', :text => <<-LICENSE
Philips, 2016. All rights reserved.
LICENSE
}
s.platform     = :ios, '11.0'

  s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/ail_#commithash#.zip' }


s.default_subspec = 'Source'

s.subspec 'Source' do |source|
s.source_files  = 'Source/ail/Source/DemoUApp/AppInfraMicroApp/**/*.{h,m,swift}'
s.ios.deployment_target  = '11.0'

s.resources = [
'Source/ail/Source/DemoUApp/AppInfraMicroApp/Resources/*'
]

end

s.subspec 'Binary' do |binary|
binary.ios.vendored_frameworks = 'Framework/AppInfraMicroApp.framework'
end

s.dependency 'UAPPFramework', DependencyCDP2Platform
s.dependency 'PhilipsUIKitDLS', PhilipsUIKitDLSVersion

s.swift_version = '5.1'
s.ios.deployment_target  = '11.0'
s.requires_arc = true

end
