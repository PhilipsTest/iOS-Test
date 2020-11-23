#
# Be sure to run `pod lib lint InAppPurchase.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|

    s.name             = 'MobileEcommerceDemoUApp'
    s.authors          = 'Koninklijke Philips N.V.'
    s.version          = VersionCDP2Platform
    s.summary          = 'Philips ecommerce Framework'
    s.homepage         = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'

    s.license          = { :type => 'Philips', :text => <<-LICENSE
                            © Koninklijke Philips N.V., 2015. All rights reserved.
                            LICENSE
                         }
    s.platform         = :ios, "11.0"

    s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/mec_#commithash#.zip' }
    
    s.swift_version = '5.1'
    s.ios.deployment_target  = '11.0'
    s.dependency 'MobileEcommerce', DependencyCDP2Platform
    s.dependency 'PhilipsRegistration', DependencyCDP2Platform
    
    s.requires_arc = true

    s.default_subspec = 'Source'

    s.subspec 'Source' do |source|

        source.source_files  = "Source/mec/Source/DemoUApp/MobileEcommerceDemoUApp/MobileEcommerceDemoUApp/**/*.{swift,h}"
        source.resources     = [ 
                                'Source/mec/Source/DemoUApp/MobileEcommerceDemoUApp/MobileEcommerceDemoUApp/DemoUAppUI/*.xcassets',
                                 'Source/mec/Source/DemoUApp/MobileEcommerceDemoUApp/MobileEcommerceDemoUApp/DemoUAppUI/*.storyboard',
                                 'Source/mec/Source/DemoUApp/MobileEcommerceDemoUApp/MobileEcommerceDemoUApp/DemoUAppUI/*.xib',
                                 'Source/mec/Source/DemoUApp/MobileEcommerceDemoUApp/MobileEcommerceDemoUApp/DemoUAppUI/*.png'
                                ]

    end

end

