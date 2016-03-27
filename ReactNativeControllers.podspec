Pod::Spec.new do |s|

  s.name         = "ReactNativeControllers"
  s.version      = "0.0.1-master"
  s.summary      = "Native IOS Navigation for React Native (navbar, tabs, drawer)"
  s.homepage     = "https://github.com/wix/react-native-controllers"
  s.license      = { :type => "MIT" }
  s.author       = { "Tal Kol" => "talkol@gmail.com" }
  s.platform     = :ios, "7.0"
  s.source       = { :git => "https://github.com/wix/react-native-controllers.git" }
  s.source_files = "ios", "ios/**/*.{h,m}"

end
