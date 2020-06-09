# Uncomment the next line to define a global platform for your project
platform :ios, '9.0'
inhibit_all_warnings!

source 'https://github.com/CocoaPods/Specs.git'
source 'https://github.com/Kalanhall/Specs.git'

target 'Objective-C' do
  # Comment the next line if you don't want to use dynamic frameworks
  use_frameworks!

  # Pods for Objective-C
  pod 'KLApplicationEntry'    , '~> 1.4.0'
  pod 'KLGuidePage'           , '~> 1.0.0'
  pod 'KLUserInfoManager'     , '~> 1.0.1'
  pod 'KLLeaks'               , '~> 1.0.0'
  pod 'KLConsole'             , '~> 2.0.1'
  pod 'YKWoodpecker'          , '~> 1.2.5'
  pod 'AppOrderFiles'
  # 主页模块
  pod 'KLHomeService'         , :git=> 'https://github.com/Kalanhall/KLHomeService'
  pod 'KLHomeServiceInterface', '~> 0.0.2'

  target 'Objective-CTests' do
    inherit! :search_paths
    # Pods for testing
  end

end
