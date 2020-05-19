# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
inhibit_all_warnings!

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Kalanhall/Specs.git'

target 'Objective-C' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Objective-C
  pod 'KLApplicationEntry'
  pod 'KLUserInfoManager'
  pod 'KLLeaks'
  pod 'KLConsole' 
  
  # 主页模块
  pod 'KLHomeService', :path=>'/Users/kalan/KLHomeService'
  pod 'KLHomeServiceInterface'

  target 'Objective-CTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
