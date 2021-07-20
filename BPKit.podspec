#
# Be sure to run `pod lib lint BPKit.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BPKit'
  s.version          = '0.4.7'
  s.summary          = 'A short description of BPKit.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
TODO: Add long description of the pod here.
                       DESC
                       
  s.homepage         = 'https://github.com/BPModels/BPKit'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'TestEngineerFish' => '916878440@qq.com' }
  s.source           = { :git => 'https://github.com/BPModels/BPKit.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '11.0'
  
  s.swift_versions = '5.0'

  s.source_files = 'BPKit/Classes/**/*'
  
   s.resource_bundles = {
     'BPKit' => ['BPKit/Assets/*']
   }

   s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  
   # Lottie（Apache License 2.0）
   s.dependency 'lottie-ios'
   # 分类切换滚动视图（MIT License）
   s.dependency 'JXSegmentedView'
   # 全屏右滑返回（MIT License）
   s.dependency 'FDFullscreenPopGesture', '1.1'
   # 下载处理图片（MIT License）
   s.dependency 'Kingfisher', '~> 5.7'
   # 布局约束（MIT License）
   s.dependency 'SnapKit'
   # 弹框（MIT License）
   s.dependency 'Toast-Swift'
   # 键盘管理（MIT License）
   s.dependency 'IQKeyboardManager'
   # 图片库（MIT License）
   s.dependency 'SDWebImage'
   # JSON转对象（MIT License）
   s.dependency 'ObjectMapper'
   # 日志收集
   s.dependency 'BPLog'
   # 设备信息
   s.dependency 'BPDeviceInfo'
   # 公共库
   s.dependency 'BPCommon'
   # 网络库
   s.dependency 'BPNetwork'
end
