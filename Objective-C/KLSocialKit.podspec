#
# Be sure to run `pod lib lint KLSocialKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'KLSocialKit'
  s.version          = '1.0.0'
  s.summary          = '推送、分享、第三方登陆功能合集'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
  组件介绍：
  推送、分享、第三方登陆功能合集。
                       DESC

  s.homepage         = 'https://github.com/Kalanhall@163.com/KLSocialKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'Kalanhall@163.com' => 'wujm002@galanz.com' }
  s.source           = { :git => 'https://github.com/Kalanhall@163.com/KLSocialKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '9.0'

  s.source_files = 'KLSocialKit/Classes/**/*'
  
  # s.resource_bundles = {
  #   'KLSocialKit' => ['KLSocialKit/Assets/*.png']
  # }

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  s.static_framework = true
  
  # ------------ 友盟+基础组件库 ------------
  s.dependency 'UMCCommon'
  # 集成友盟推送
  s.dependency 'UMCPush'
  # 集成友盟Crash统计
  s.dependency 'UMCAnalytics'
  s.dependency 'UMCErrorCatch'

end
