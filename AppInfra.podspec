require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|
s.name         = "AppInfra"
s.version      = VersionCDP2Platform
s.summary      = "Framework which includes all the utility features like logging ,tagging,secure storage"
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
s.source_files  = 'Source/ail/Source/Library/AppInfra/**/*.{h,m,c,swift}'
s.public_header_files = ["Source/ail/Source/Library/AppInfra/Protocol/AppInfra.h","Source/ail/Source/Library/AppInfra/AIAppIdentityProtocol.h","Source/ail/Source/Library/AppInfra/AIServiceDiscoveryProtocol.h","Source/ail/Source/Library/AppInfra/AIAppInfra.h","Source/ail/Source/Library/AppInfra/Protocol/AILoggingProtocol.h","Source/ail/Source/Library/AppInfra/Protocol/AICloudLoggingProtocol.h","Source/ail/Source/Library/AppInfra/Protocol/AIAppTaggingProtocol.h","Source/ail/Source/Library/AppInfra/Protocol/AISecureStorageProtocol.h","Source/ail/Source/Library/AppInfra/Protocol/AIAppInfraProtocol.h","Source/ail/Source/Library/AppInfra/Protocol/AIAppIdentityProtocol.h","Source/ail/Source/Library/AppInfra/Protocol/AIServiceDiscoveryProtocol.h","Source/ail/Source/Library/AppInfra/AIAppInfraBuilder.h","Source/ail/Source/Library/AppInfra/Protocol/AITimeProtocol.h","Source/ail/Source/Library/AppInfra/Protocol/AIStorageProviderProtocol.h","Source/ail/Source/Library/AppInfra/Protocol/AIInternationalizationProtocol.h","Source/ail/Source/Library/AppInfra/Protocol/AIAppConfigurationProtocol.h","Source/ail/Source/Library/AppInfra/ServiceDiscovery/AISDService.h","Source/ail/Source/Library/AppInfra/Protocol/AIRESTClientProtocol.h","Source/ail/Source/Library/AppInfra/RestClient/AIRESTClientURLResponseSerialization.h","Source/ail/Source/Library/AppInfra/Protocol/AIABTestProtocol.h","Source/ail/Source/Library/AppInfra/Protocol/AIAPISigningProtocol.h","Source/ail/Source/Library/AppInfra/ApiSigning/AIClonableClient.h","Source/ail/Source/Library/AppInfra/Protocol/AIComponentVersionInfoProtocol.h","Source/ail/Source/Library/AppInfra/Protocol/AILanguagePackProtocol.h","Source/ail/Source/Library/AppInfra/Protocol/AIAppUpdateProtocol.h","Source/ail/Source/Library/AppInfra/Logging/AICloudApiSigner.h","Source/ail/Source/Library/AppInfra/AppTagging/AITaggingError.h","Source/ail/Source/Library/AppInfra/Utility/AIUtility.h","Source/ail/Source/Library/AppInfra/Utility/AIInternalTaggingUtility.h","Source/ail/Source/Library/AppInfra/Utility/AIInternalLogger.h","Source/ail/Source/Library/AppInfra/Logging/AILogMetaData.h","Source/ail/Source/Library/AppInfra/Logging/AICloudLogMetadata.h", "Source/ail/Source/Library/AppInfra/Logging/AILogUtilities.h","Source/ail/Source/Library/AppInfra/Logging/AICloudLogger.h"]

s.resources = [
'Source/ail/Source/Library/AppInfra/Resources/ailLocalizableStrings/**/*.strings',
'Source/ail/Source/Library/AppInfra/Resources/AILogging.xcdatamodeld'
]
end

s.subspec 'Binary' do |binary|
binary.ios.vendored_frameworks = 'Framework/AppInfra.framework'
end

s.dependency 'AdobeMobileSDK', '4.19.3'
s.dependency 'CocoaLumberjack', '3.6.1'
s.dependency 'AFNetworking', '4.0.1'
s.dependency 'TrueTime', '5.0.3'
s.dependency 'PlatformInterfaces', DependencyCDP2Platform
s.ios.deployment_target  = '11.0'
s.requires_arc = true
s.swift_version = '5.1'

end
