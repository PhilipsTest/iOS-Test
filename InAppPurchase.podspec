#
# Be sure to run `pod lib lint InAppPurchase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|

    s.name             = 'InAppPurchase'
    s.authors          = 'Koninklijke Philips N.V.'
    s.version          = VersionCDP2Platform
    s.summary          = 'Philips In-App Purchasing Framework'
    s.homepage         = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'

    s.license          = { :type => 'Philips', :text => <<-LICENSE
                            © Koninklijke Philips N.V., 2015. All rights reserved.
                            LICENSE
                         }
    s.platform         = :ios, "11.0"
	s.module_name      = 'InAppPurchase'

    s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/iap_#commithash#.zip' }

    s.dependency 'PhilipsPRXClient', DependencyCDP2Platform
    s.swift_version = '5.1'
    s.requires_arc = true
    s.default_subspec = 'Source'

    s.subspec 'Source' do |source|

        source.source_files  = "Source/iap/Source/Library/InAppPurchase/InAppPurchase/**/*.{swift}"
        source.resources     = [ 'Source/iap/Source/Library/InAppPurchase/InAppPurchase/**/*.{storyboard,xib,xcassets,lproj,json}' ]
        source.dependency 'PhilipsRegistration', DependencyCDP2Platform
        source.dependency 'AFNetworking', '4.0.1'
    end
    
    s.subspec 'Pim' do |source|

        source.source_files  = "Source/iap/Source/Library/InAppPurchase/InAppPurchase/**/*.{swift}"
        source.resources     = [ 'Source/iap/Source/Library/InAppPurchase/InAppPurchase/**/*.{storyboard,xib,xcassets,lproj,json}' ]
        source.dependency 'PIM', DependencyCDP2Platform

    end


    s.subspec 'Binary' do |binary|

        binary.dependency 'PhilipsRegistration/Binary', DependencyCDP2Platform
        binary.ios.vendored_frameworks = 'Source/iap/InAppPurchase\ Binary/InAppPurchaseLib/Framework/InAppPurchase.framework'

    end
    s.ios.deployment_target  = '11.0'
end

