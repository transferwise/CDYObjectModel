Pod::Spec.new do |spec|
  spec.name         = 'CDYAnalyticsCoordinator'
  spec.version      = '0.1.0'
  spec.summary      = "Utility classes to coordinate reporting to different analytics services."
  spec.homepage     = "https://github.com/coodly/CDYAnalyticsCoordinator"
  spec.author       = { "Jaanus Siim" => "jaanus@coodly.com" }
  spec.source       = { :git => "https://github.com/coodly/CDYAnalyticsCoordinator.git", :tag => "v#{spec.version}" }
  spec.license      = { :type => 'Apache 2', :file => 'LICENSE' }
  spec.requires_arc = true

  spec.subspec 'Core' do |ss|
    ss.platform = :ios, '6.0'
    ss.source_files = 'Core/*.{h,m}'
  end
end
