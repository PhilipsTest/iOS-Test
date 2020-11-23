require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|

  s.name = 'PhilipsProductSelection'
  s.authors = 'Koninklijke Philips N.V.'
  s.license = 'proprietary'
  s.version = VersionCDP2Platform
  s.platform = :ios, "11.0"
  s.ios.deployment_target = '11.0'
  s.swift_version = '5.1'
  s.homepage     = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'
  s.summary = 'Philips Product Selection - Horizontal Component'
  s.module_name = 'PhilipsProductSelection'
  
  s.dependency 'PhilipsUIKitDLS', PhilipsUIKitDLSVersion
  s.dependency 'AppInfra', DependencyCDP2Platform
  s.dependency  'PhilipsPRXClient', DependencyCDP2Platform

  s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/pse_#commithash#.zip' }

  s.public_header_files = ["Source/pse/Source/PhilipsProductSelection/PhilipsProductSelection/Common/PSHandler.h",
                           "Source/pse/Source/PhilipsProductSelection/PhilipsProductSelection/Common/PSHardcodedProductList.h",
                           "Source/pse/Source/PhilipsProductSelection/PhilipsProductSelection/Common/PSProductModelSelectionType.h"]

  s.source_files = '{Source/pse/Source/PhilipsProductSelection/PhilipsProductSelection}/**/*.{h,m}'
  s.resource = 'Source/pse/Source/PhilipsProductSelection/PhilipsProductSelection/**/*.{storyboard,xib,xcassets,lproj,json}'

end
