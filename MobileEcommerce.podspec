#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|

    s.name             = 'MobileEcommerce'
    s.authors          = 'Koninklijke Philips N.V.'
    s.version          = VersionCDP2Platform
    s.summary          = 'Philips e-Commerce'
    s.homepage         = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'

    s.license          = { :type => 'Philips', :text => <<-LICENSE
                            © Koninklijke Philips N.V., 2019. All rights reserved.
                            LICENSE
                         }
    s.platform         = :ios, "11.0"
	  s.module_name      = 'MobileEcommerce'

    s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/mec_#commithash#.zip' }

    s.swift_version = '5.1'
    s.requires_arc = true
    s.ios.deployment_target  = '11.0'
    
    s.default_subspec = 'Source'

    s.subspec 'Source' do |source|

        source.source_files  = "Source/mec/Source/Library/MobileEcommerce/MobileEcommerce/**/*.{swift}"
        source.resources     = [ "Source/mec/Source/Library/MobileEcommerce/MobileEcommerce/**/*.{storyboard,xib,xcassets,lproj,ttf,json}", 
            "Source/mec/Source/Library/MobileEcommerce/MobileEcommerce/Resources/**/*.{plist}" ]
    end
    
    s.dependency 'PhilipsRegistration', DependencyCDP2Platform
    s.dependency 'PhilipsEcommerceSDK', DependencyCDP2Platform
    s.dependency 'BVSDK/BVConversations', '8.2.2'
    s.dependency 'libPhoneNumber-iOS', '0.9.15'
    s.dependency 'PhilipsPRXClient', DependencyCDP2Platform
    s.dependency 'AFNetworking', '4.0.1'
end

