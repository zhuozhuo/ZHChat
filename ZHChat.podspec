

Pod::Spec.new do |s|

 s.name         = "ZHChat"
 s.version      = "0.1.7"
 s.summary      = "An elegant messages UI library for iOS."
 s.homepage     = "https://github.com/zhuozhuo"
 s.screenshots  = ['http://ac-unmt7l5d.clouddn.com/39fd9320ae6315b2.PNG','http://ac-unmt7l5d.clouddn.com/e1ed619294a427cc.PNG','http://ac-unmt7l5d.clouddn.com/e1ed619294a427cc.PNG']
 s.license      = "MIT"
 s.license      = { :type => "MIT", :file => "LICENSE" }
 s.author             = { "Mr.jiang" => "414816566@qq.com" }
 s.platform     = :ios, "7.0"
 s.source       = { :git => "https://github.com/zhuozhuo/ZHChat.git", :tag => s.version }
 s.source_files  = "ZHCMessagesViewController/**/*.{h,m}"
 s.resources = ['ZHCMessagesViewController/Assets/ZHCMessagesAssets.bundle', 'ZHCMessagesViewController/**/*.{xib}']
 s.frameworks = 'QuartzCore', 'CoreGraphics', 'CoreLocation', 'MapKit', 'MobileCoreServices', 'AVFoundation'
 s.requires_arc = true

end
