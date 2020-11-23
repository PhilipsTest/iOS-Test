require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|

  s.name = 'PhilipsRegistration'
  s.authors = 'Koninklijke Philips N.V.'
  s.license = 'proprietary'
  s.version = VersionCDP2Platform
  s.homepage     = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'
  s.summary = 'Philips User Registration - Horizontal Component'
  s.platform = :ios, "11.0"

  s.dependency 'PhilipsUIKitDLS', PhilipsUIKitDLSVersion
  s.dependency "UAPPFramework", DependencyCDP2Platform
  s.dependency "libPhoneNumber-iOS", '0.9.15'
  s.dependency 'AppInfra', DependencyCDP2Platform

  s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/usr_#commithash#.zip' }


  s.default_subspec = 'Source'
  s.module_name = 'PhilipsRegistration'
  s.subspec 'Source' do |source|

  s.source_files = [
  'Source/usr/Source/Library/Registration/**/*.{h,m}',
  'Source/usr/Source/Library/PhilipsRegistration/PhilipsRegistration.h'
  ]
  s.public_header_files = [
  'Source/usr/Source/Library/PhilipsRegistration/PhilipsRegistration.h',
  'Source/usr/Source/Library/Registration/DIUser.h',
  'Source/usr/Source/Library/Registration/DIUser+Authentication.h',
  'Source/usr/Source/Library/Registration/DIRegistrationConstants.h',
  'Source/usr/Source/Library/Registration/Janrain/DIConsumerInterest.h',
  'Source/usr/Source/Library/Registration/Coppa/DICOPPAExtension.h',
  'Source/usr/Source/Library/Registration/Coppa/DICoppaExtensionConstants.h',
  'Source/usr/Source/Library/Registration/RegistrationUI/Configuration/DIRegistrationFlowConfiguration.h',
  'Source/usr/Source/Library/Registration/RegistrationUI/Configuration/DIRegistrationContentConfiguration.h',
  'Source/usr/Source/Library/Registration/Utilities/DIRegistrationVersion.h',
  'Source/usr/Source/Library/Registration/URDependencies.h',
  'Source/usr/Source/Library/Registration/URInterface.h',
  'Source/usr/Source/Library/Registration/URLaunchInput.h',
  'Source/usr/Source/Library/Registration/URRegistrationProtocols.h',
  'Source/usr/Source/Library/Registration/DIUser+DataInterface.h',
  'Source/usr/Source/Library/Registration/GDPR/URConsentProvider.h',
  'Source/usr/Source/Library/Registration/GDPR/URMarketingConsentHandler.h'
  ]
  s.resources = [
    'Source/usr/Source/Library/Registration/Janrain/JanRain SDK/JREngage/Resources/**/*.xib',
    'Source/usr/Source/Library/Registration/**/*.{xcassets}',
    'Source/usr/Source/Library/Registration/Janrain/JanRain SDK/JREngage/JREngage-Info.plist',
    'Source/usr/Source/Library/Registration/**/*.{storyboard}',
    'Source/usr/Source/Library/RegistrationResorces/**/*.strings',
    'Source/usr/Source/Library/RegistrationResorces/**/*.{xcassets}',
    'Source/usr/Source/Library/Registration/**/*.strings',
    'Source/usr/Source/Library/Registration/Registration-Info.plist'
  ]

  end

  s.subspec 'Binary' do |binary|

    binary.ios.vendored_frameworks = 'Source/usr/Registration\ Binary/RegistrationLib/Framework/PhilipsRegistration.framework'

  end

  s.frameworks = 'Accounts','Social','MessageUI','SystemConfiguration'
  s.ios.deployment_target  = '11.0'
  s.swift_version = '5.1'

end
