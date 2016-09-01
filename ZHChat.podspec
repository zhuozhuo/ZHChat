

Pod::Spec.new do |s|

 s.name         = "ZHChat"
 s.version      = "0.1.3"
 s.summary      = "An elegant messages UI library for iOS."
 s.homepage     = "https://github.com/zhuozhuo/ZHBLE"
 s.screenshots  = ['http://ac-unmt7l5d.clouddn.com/eedc9f8abb34b096.PNG','http://ac-unmt7l5d.clouddn.com/196afe26dbee82f2.PNG','http://ac-unmt7l5d.clouddn.com/11dc5e2c9bdac647.PNG','http://ac-unmt7l5d.clouddn.com/c7307ef86ad4ddb7.PNG']
 s.license      = "MIT"
 s.license      = { :type => "MIT", :file => "LICENSE" }
 s.author             = { "Mr.jiang" => "414816566@qq.com" }
 s.platform     = :ios, "7.1"
 s.source       = { :git => "https://github.com/zhuozhuo/ZHChat.git", :tag => s.version }
 s.source_files  = "ZHCMessagesViewController/**/*.{h,m}"
 s.resources = ['ZHCMessagesViewController/Assets/ZHCMessagesAssets.bundle', 'ZHCMessagesViewController/**/*.{xib}']
 s.frameworks = 'QuartzCore', 'CoreGraphics', 'CoreLocation', 'MapKit', 'MobileCoreServices', 'AVFoundation'
 s.requires_arc = true

end
