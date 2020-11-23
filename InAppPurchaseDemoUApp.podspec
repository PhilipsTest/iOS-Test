#
# Be sure to run `pod lib lint InAppPurchase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|

    s.name             = 'InAppPurchaseDemoUApp'
    s.authors          = 'Koninklijke Philips N.V.'
    s.version          = VersionCDP2Platform
    s.summary          = 'Philips In-App Purchasing Framework'
    s.homepage         = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'

    s.license          = { :type => 'Philips', :text => <<-LICENSE
                            © Koninklijke Philips N.V., 2015. All rights reserved.
                            LICENSE
                         }
    s.platform         = :ios, "11.0"

    s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/iap_#commithash#.zip' }

    s.dependency 'InAppPurchase', DependencyCDP2Platform
    s.dependency 'PhilipsRegistration', DependencyCDP2Platform
    s.dependency 'PhilipsPRXClient', DependencyCDP2Platform

    s.requires_arc = true
    s.swift_version = '5.1'
    s.default_subspec = 'Source'

    s.subspec 'Source' do |source|

        source.source_files  = "Source/iap/Source/DemoUApp/InAppPurchaseDemoUApp/InAppPurchaseDemoUApp/**/*.{swift,h}"
        source.resources     = [ 'Source/iap/Source/DemoUApp/InAppPurchaseDemoUApp/InAppPurchaseDemoUApp/DemoUAppUI/*.xcassets',
                                 'Source/iap/Source/DemoUApp/InAppPurchaseDemoUApp/InAppPurchaseDemoUApp/DemoUAppUI/*.storyboard',
                                 'Source/iap/Source/DemoUApp/InAppPurchaseDemoUApp/InAppPurchaseDemoUApp/DemoUAppUI/*.xib',
                                 'Source/iap/Source/DemoUApp/InAppPurchaseDemoUApp/InAppPurchaseDemoUApp/MockData/*.json']

    end
    s.ios.deployment_target  = '11.0'

end

