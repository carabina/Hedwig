Pod::Spec.new do |s|
  s.name         = "Hedwig"
  s.version      = "1.0"
  s.summary      = "Interactive Notification"
  s.homepage     = "https://github.com/Lab111/Hedwig"
  s.license      = "MIT"
  s.author       = { "Lab 7" => "hermes@lab7.org" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/Lab111/Hedwig.git", :tag => "1.0" }
  s.source_files  = "Sources", "Sources/*.swift"
  s.pod_target_xcconfig = { 'SWIFT_VERSION' => '3' }
end
