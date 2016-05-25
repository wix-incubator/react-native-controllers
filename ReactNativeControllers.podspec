Pod::Spec.new do |s|

  s.name         = "ReactNativeControllers"
  s.version      = "2.0.0"
  s.summary      = "Native IOS Navigation for React Native (navbar, tabs, drawer)"
  s.homepage     = "https://github.com/wix/react-native-controllers"
  s.license      = { :type => "MIT" }
  s.author       = { "Tal Kol" => "talkol@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/wix/react-native-controllers.git", :tag => "v#{s.version}" }
  s.source_files = "ios", "ios/**/*.{h,m}"

end
