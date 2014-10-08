Pod::Spec.new do |s|

  s.name         = "LKLayoutLibrary"
  s.version      = "1.0.0"
  s.summary      = "LKLayoutLibrary provides layout manager for UIKit such as Linearlayout"

  s.description  = <<-DESC
                   LKLayoutLibrary provides layout manager for UIKit

                   LKLayoutLibrary adds layouts to UIKit without having the need of subclassing UIView.
                   DESC

  s.homepage     = "https://github.com/mkloeppner/LKLayoutLibrary"
  s.license      = 'MIT'

  s.author       = { "mkloeppner" => "mkloeppner@me.com" }
  s.platform     = :ios, '6.0'

  s.source       = { :git => "https://github.com/mkloeppner/LKLayoutLibrary.git", :tag => "1.0.0 }

  s.source_files  = 'LKLayoutLibrary', '**/*.{h,m}'
  s.exclude_files = 'LKLayoutLibraryTests'

  s.frameworks  = 'Foundation', 'UIKit'

  s.requires_arc = true

end
