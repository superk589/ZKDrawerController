Pod::Spec.new do |s|
  s.name         = "ZKDrawerController"
  s.version      = "0.6.1"
  s.summary      = "An iOS drawer controller in swift."
  s.description  = <<-DESC
                   A light-weighted iOS drawer controller in swift.
                   DESC
  s.homepage     = "https://github.com/superk589/ZKDrawerController"
  s.license      = "MIT"
  s.author             = { "zhenkai zhao" => "superk589@gmail.com" }
  s.platform     = :ios, "10.0"
  s.source       = { :git => "https://github.com/superk589/ZKDrawerController.git", :tag => "#{s.version}" }
  s.source_files  = "Sources/*.swift"
  s.framework  = "UIKit"
  s.dependency "SnapKit"
  s.swift_version = "5.0"
end
