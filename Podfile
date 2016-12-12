post_install do |installer|
    installer.pods_project.targets.each do |target|
        target.build_configurations.each do |config|
            config.build_settings['SWIFT_VERSION'] = '3.0'
        end
    end
end

platform :ios, '9.0'
use_frameworks!
 
target 'be-talk' do
    pod 'SwiftyJSON', :git => 'https://github.com/acegreen/SwiftyJSON.git', :branch => 'swift3'
    pod "libjingle_peerconnection"
    pod "SocketRocket"
    pod "Socket.IO-Client-Swift"
    pod "AppRTC", "~> 1.0"
    pod "JSQMessagesViewController"
end

target 'be-talkUITests' do
    
end
