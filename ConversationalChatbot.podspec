#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#
require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|

    s.name             = 'ConversationalChatbot'
    s.authors          = 'Koninklijke Philips N.V.'
    s.version          = VersionCDP2Platform
    s.summary          = 'Philips Chatbot'
    s.homepage         = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'

    s.license          = { :type => 'Philips', :text => <<-LICENSE
                            © Koninklijke Philips N.V., 2019. All rights reserved.
                            LICENSE
                         }
    s.platform         = :ios, "11.0"
	s.module_name      = 'ConversationalChatbot'

    s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/ccb_#commithash#.zip' }

    s.swift_version = '5.1'
    s.requires_arc = true
    s.default_subspec = 'Source'

    s.subspec 'Source' do |source|

        source.source_files  = "Source/ccb/Source/Library/ConversationalChatbot/ConversationalChatbot/**/*.{swift}"
        source.resources     = [ "Source/ccb/Source/Library/ConversationalChatbot/ConversationalChatbot/**/*.{storyboard}",
                                 "Source/ccb/Source/Library/ConversationalChatbot/ConversationalChatbot/**/*.{xcassets}" ]
    end

    s.ios.deployment_target  = '11.0'
    s.dependency 'UAPPFramework', DependencyCDP2Platform
    s.dependency 'PhilipsUIKitDLS', PhilipsUIKitDLSVersion
    s.dependency 'Starscream', '4.0.4'
    s.dependency 'youtube-ios-player-helper', '1.0.2'
    s.dependency 'markymark', '9.2.1'

end
