#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|

    s.name             = 'ConversationalChatbotDemoUApp'
    s.authors          = 'Koninklijke Philips N.V.'
    s.version          = VersionCDP2Platform
    s.summary          = 'Philips Chatbot UApp Framework'
    s.homepage         = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'
    s.license          = { :type => 'Philips', :text => <<-LICENSE
                            © Koninklijke Philips N.V., 2019. All rights reserved.
                            LICENSE
                         }
    s.platform         = :ios, "11.0"
	s.module_name      = 'ConversationalChatbotDemoUApp'

    s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/ccb_#commithash#.zip' }

    s.swift_version = '5.1'
    s.requires_arc = true
    s.default_subspec = 'Source'

    s.subspec 'Source' do |source|

        source.source_files  = "Source/ccb/Source/DemoUApp/ConversationalChatbotDemoUApp/ConversationalChatbotDemoUApp/**/*.{swift}"
        source.resources = [ "Source/ccb/Source/DemoUApp/ConversationalChatbotDemoUApp/ConversationalChatbotDemoUApp/**/*.{storyboard}",
"Source/ccb/Source/DemoUApp/ConversationalChatbotDemoUApp/ConversationalChatbotDemoUApp/**/*.{xcassets}" ]
    end
    
    s.ios.deployment_target  = '11.0'
    s.dependency 'ConversationalChatbot', DependencyCDP2Platform
    s.dependency 'PhilipsUIKitDLS', PhilipsUIKitDLSVersion
end
