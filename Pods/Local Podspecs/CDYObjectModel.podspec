Pod::Spec.new do |spec|
  spec.name         = 'CDYObjectModel'
  spec.version      = '0.1.0'
  spec.summary      = "Wrapper layer on top of Core Data."
  spec.homepage     = "https://github.com/coodly/CDYObjectModel"
  spec.author       = { "Jaanus Siim" => "jaanus@coodly.com" }
  spec.source       = { :git => "https://github.com/coodly/CDYObjectModel.git", :tag => "v#{spec.version}" }
  spec.license      = { :type => 'Apache 2', :file => 'LICENSE.txt' }
  spec.requires_arc = true

  spec.subspec 'Core' do |ss|
    ss.platform = :ios, '6.0'
    ss.source_files = 'Core/*.{h,m}'
  end
end