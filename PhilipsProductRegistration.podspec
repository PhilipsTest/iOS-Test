require_relative './ci-build-support/Versions'
Pod::Spec.new do |s|
  s.name         = "PhilipsProductRegistration"
  s.module_name  = 'PhilipsProductRegistration'
  s.version      = VersionCDP2Platform
  s.homepage     = 'https://tfsemea1.ta.philips.com/tfs/TPC_Region02/Innersource/_git/mobile-plf-ios'
  s.summary      = "A framework to easily create Philips Product Registration component."
  s.platform     = :ios, "11.0"
  s.author       = 'Philips Connected Digital Propositions'
  s.license      = { :type => 'Philips', :text => <<-LICENSE
                    © Koninklijke Philips N.V., 2015. All rights reserved.
                    LICENSE
                    }

  s.source  = { :http => 'https://artifactory-ehv.ta.philips.com/artifactory/#artifactoryrepo#/com/philips/platform/Zip_Sources/#version_epoch#/prg_#commithash#.zip' }

  s.requires_arc = true
  s.default_subspec = 'Source'
  s.frameworks = 'WebKit'
  s.dependency "PhilipsPRXClient", DependencyCDP2Platform
  s.swift_version = '5.1'
  s.ios.deployment_target  = '11.0'
  
  s.subspec 'Source' do |source|
        source.dependency "PhilipsRegistration", DependencyCDP2Platform
        source.source_files  = "Source/prg/Source/Library/PhilipsProductRegistration/PhilipsProductRegistration/**/*.{h,swift}"
        source.resources = [ 'Source/prg/Source/Library/PhilipsProductRegistration/PhilipsProductRegistration/**/*.{storyboard,xcassets,lproj,png}' ]
    end
  
  s.subspec 'Pim' do |source|
      source.dependency "PIM", DependencyCDP2Platform
      source.source_files  = "Source/prg/Source/Library/PhilipsProductRegistration/PhilipsProductRegistration/**/*.{h,swift}"
      source.resources = [ 'Source/prg/Source/Library/PhilipsProductRegistration/PhilipsProductRegistration/**/*.{storyboard,xcassets,lproj,png}' ]
  end

    s.subspec 'Binary' do |binary|
        binary.dependency "PhilipsRegistration/Binary", DependencyCDP2Platform
        binary.ios.vendored_frameworks = 'Binary/ProductRegistrationLib/Framework/PhilipsProductRegistration.framework'
    end
end
