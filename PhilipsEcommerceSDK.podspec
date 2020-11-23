#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|

    s.name             = 'PhilipsEcommerceSDK'
    s.authors          = 'Koninklijke Philips N.V.'
    s.version          = VersionCDP2Platform
    s.summary          = 'Philips e-Commerce SDK'
    s.homepage         = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'

    s.license          = { :type => 'Philips', :text => <<-LICENSE
                            © Koninklijke Philips N.V., 2019. All rights reserved.
                            LICENSE
                         }
    s.platform         = :ios, "11.0"
    s.module_name      = 'PhilipsEcommerceSDK'

    s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/ecs_#commithash#.zip' }

    s.requires_arc = true
    s.swift_version = '5.1'
    s.ios.deployment_target  = '11.0'
    s.dependency 'AppInfra', DependencyCDP2Platform
    s.dependency  'PhilipsPRXClient', DependencyCDP2Platform
    s.default_subspec = 'Source'

    s.subspec 'Source' do |source|

        source.source_files  = "Source/ecs/Source/Library/PhilipsEcommerceSDK/PhilipsEcommerceSDK/**/*.{swift}"
        source.resources     = [ "Source/ecs/Source/Library/PhilipsEcommerceSDK/PhilipsEcommerceSDK/**/*.{lproj}" ]
    end
end

