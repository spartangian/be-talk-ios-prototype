# be-talk-ios
Be-talk for iPhone application

#installation

1. pull this repository
2. run pod install from terminal

you might encounter this: "The 'Pods-be-talk' target has transitive dependencies that include static binaries:"
this is about the libjingle libWebRTC.a

3. comment AppRTC from the podfile
4. copy Pods/AppRTC directory to be-talk project directory (location where the .swift files are located)
5. run pod install again on terminal
6. build clean (shift + command + k)
7. build
8. if you encounter a problem in ARDAppClient.m like: `Use of undeclear identifier of UIDevice`, add this on top of ARDAppClient.m : #import <UIKit/UIKit.h> source: http://stackoverflow.com/questions/35507457/how-to-deal-with-use-of-undeclear-identifier-of-uidevice
9. build again
