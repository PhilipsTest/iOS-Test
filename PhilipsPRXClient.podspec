require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|

  s.name = 'PhilipsPRXClient'
  s.authors = 'Koninklijke Philips N.V.'
  s.license = 'proprietary'
  s.version = VersionCDP2Platform
  s.platform = :ios, "11.0"
  s.homepage = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'
  s.summary = 'Philips PRX Client - Horizontal Component'
  s.dependency 'AppInfra', DependencyCDP2Platform
  s.swift_version = '5.1'
  s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/prx_#commithash#.zip' }

  s.source_files = ["Source/prx/Source/Library/PRXClient/PRXClient/**/*.{h,m}"]
  s.ios.deployment_target  = '11.0'
end
