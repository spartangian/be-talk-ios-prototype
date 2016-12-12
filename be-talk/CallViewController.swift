//
//  CallViewController.swift
//  be-talk
//
//  Created by Gian Paolo Balaag on 10/6/16.
//  Copyright © 2016 Tmjp Engineering. All rights reserved.
//

import UIKit

//ARDAppClientDelegate Handles events when remote client connects and disconnect states. Also, handles events when local and remote video feeds are received.
//RTCEAGLVideoViewDelegate handles event for determining the video frame size.
class CallViewController: UIViewController, ARDAppClientDelegate, RTCEAGLVideoViewDelegate {
    
    var roomName: String!

    //Renders the Remote Video in the view
    @IBOutlet weak var remoteView: RTCEAGLVideoView!
    
    //Renders the Local Video in the view
    @IBOutlet weak var localView: RTCEAGLVideoView!
    
    //var roomName: String! = "testable"
    
    //Performs the connection to the AppRTC Server and joins the chat room
    var client: ARDAppClient?
    var localVideoTrack: RTCVideoTrack?
    var remoteVideoTrack: RTCVideoTrack?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        initialize()
        
        connectToChatRoom()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        disconnect()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func initialize(){
        disconnect()
        
        //Initializes the ARDAppClient with the delegate assignment
        client = ARDAppClient.init(delegate: self)
        
        //RTCEAGLVideoViewDelegate provides notifications on video frame dimensions
        remoteView.delegate = self
        localView.delegate = self
    }
    
    func connectToChatRoom(){
        client?.serverHostUrl = "https://apprtc.appspot.com"
        client?.connectToRoom(withId: roomName, options: nil)
    }
    
    func remoteDisconnected(){
        if(remoteVideoTrack != nil){
            remoteVideoTrack?.remove(remoteView)
        }
        remoteVideoTrack = nil
    }
    
    func disconnect(){
        if(client != nil){
            if(localVideoTrack != nil){
                localVideoTrack?.remove(localView)
            }
            if(remoteVideoTrack != nil){
                remoteVideoTrack?.remove(remoteView)
            }
            localVideoTrack = nil
            remoteVideoTrack = nil
            client?.disconnect()
        }
    }

    
    // MARK: RTCEAGLVideoViewDelegate
    func videoView(_ videoView: RTCEAGLVideoView!, didChangeVideoSize size: CGSize) {
        //Resize localView or remoteView based on the size returned
    }
    
    func appClient(_ client: ARDAppClient!, didChange state: ARDAppClientState) {
        switch state{
        case ARDAppClientState.connected:
            print("Client Connected")
            break
        case ARDAppClientState.connecting:
            print("Client Connecting")
            break
        case ARDAppClientState.disconnected:
            print("Client Disconnected")
            remoteDisconnected()
        }
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveLocalVideoTrack localVideoTrack: RTCVideoTrack!) {
        //handles local video view when started streaming video to other side
        self.localVideoTrack = localVideoTrack
        self.localVideoTrack?.add(localView)
    }
    
    func appClient(_ client: ARDAppClient!, didReceiveRemoteVideoTrack remoteVideoTrack: RTCVideoTrack!) {
        //handles remote video view, when recieved a stream from other side.
        self.remoteVideoTrack = remoteVideoTrack
        self.remoteVideoTrack?.add(remoteView)
    }
    
    func appClient(_ client: ARDAppClient!, didError error: Error!) {
        //Handle the error. output the error message to alert box with OK button
        showAlertWithMessage(error.localizedDescription)
        disconnect()
    }
    
    func showAlertWithMessage(_ message: String){
        let alertView: UIAlertController = UIAlertController(title: nil, message: message, preferredStyle: UIAlertControllerStyle.alert)
        let alertAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertActionStyle.cancel, handler: nil)
        alertView.addAction(alertAction)
        self.present(alertView, animated: true, completion: nil)
    }
    
    @IBAction func endCall(_ sender: AnyObject) {
        disconnect()
        //popViewController(animated:) returns UIViewController?, 
        //and the compiler is giving that warning since you aren't capturing the value. 
        //The solution is to assign it to an underscore:
        _ = self.navigationController?.popToRootViewController(animated: true)
    }
}
