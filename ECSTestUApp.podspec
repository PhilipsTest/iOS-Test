require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|

    s.name             = 'ECSTestUApp'
    s.authors          = 'Koninklijke Philips N.V.'
    s.version          = VersionCDP2Platform
    s.summary          = 'Philips e-commerce TestUApp'
    s.homepage         = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'

    s.license          = { :type => 'Philips', :text => <<-LICENSE
                            © Koninklijke Philips N.V., 2019. All rights reserved.
                            LICENSE
                         }
    s.platform         = :ios, "11.0"

    s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/ecs_#commithash#.zip' }

    s.dependency 'PhilipsEcommerceSDK', DependencyCDP2Platform
    s.dependency 'PhilipsRegistration', DependencyCDP2Platform

    s.requires_arc = true
    s.swift_version = '5.1'
    s.ios.deployment_target  = '11.0'

    s.default_subspec = 'Source'
    s.subspec 'Source' do |source|

        source.source_files  =  "Source/ecs/Source/TestApp/ECSTestUApp/ECSTestUApp/**/*.{swift,h}"
        source.resources     = ['Source/ecs/Source/TestApp/ECSTestUApp/ECSTestUApp/**/*.xcassets',
                                'Source/ecs/Source/TestApp/ECSTestUApp/ECSTestUApp/**/*.storyboard',
                                'Source/ecs/Source/TestApp/ECSTestUApp/ECSTestUApp/Resources/*.plist',
                                'Source/ecs/Source/TestApp/ECSTestUApp/ECSTestUApp/**/*.json', 
                                'Source/ecs/Source/TestApp/ECSTestUApp/ECSTestUApp/**/*.lproj' ]
    end

end

