Pod::Spec.new do |s|
  s.name         = '<#project#>'
  s.version      = '<#podVersion#>'
  s.homepage     = '<#projectHomeURL#>'
  s.summary      = '<#summary#>.'
  s.platform     = :ios, "8.0"
  s.author       = 'Philips Connected Digital Propositions'
  s.license      = { :type => 'Philips', :text => <<-LICENSE
                    © Koninklijke Philips N.V., 2015. All rights reserved.
                    LICENSE
                    }
  s.source  = { :git => '<#projectRepoURL#>',
        :commit => '#{s.version}'
        }
  s.requires_arc = true
  s.default_subspec = 'Source'

  s.subspec 'Source' do |source|
      source.source_files  = ['<#dir#>/*.{h,m,swift}']
  end

  s.subspec 'Binary' do |binary|
      binary.ios.vendored_frameworks = '<#binaryDirectory#>'
  end
  
   s.dependency 'UAPPFramework', '2017.5.0-SNAPSHOT'

end
