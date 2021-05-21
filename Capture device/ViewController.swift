//
//  ViewController.swift
//  Capture device
//
//  Created by Morten Just on 5/15/21.
//

import Cocoa
import AVFoundation
import CoreMediaIO
import SceneKit


class ViewController: NSViewController {

    @IBOutlet weak var sceneView: SCNView!
    var session = AVCaptureSession()
    let output = AVCaptureMovieFileOutput()
    var input : AVCaptureDeviceInput?
    var scene : SCNScene!
    var boxNode : SCNNode!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // add a scene and a blue box
        scene = SCNScene()
        sceneView.scene = scene
        sceneView.allowsCameraControl = true
        sceneView.autoenablesDefaultLighting = true
        let box = SCNBox()
        boxNode = SCNNode(geometry: box)
        box.firstMaterial?.diffuse.contents = NSColor.blue
        scene.rootNode.addChildNode(boxNode)
    }
    
    
    @IBAction func start(_ sender: Any) {
        session = AVCaptureSession()
        session.beginConfiguration()
        session.addOutput(output)
        session.commitConfiguration()
        
        AVCaptureDevice.requestAccess(for: .video) { granted in
            print("granted")
        }
        
        // Deprecated, but seems it's the only way. (Works with an NSView layer.)
        let device = AVCaptureDevice.devices(for: .muxed).first!
        input = try! AVCaptureDeviceInput(device: device)
        session.addInput(input!)
    
        let layer = AVCaptureVideoPreviewLayer(session: session)

        // the layer doesn't have a size immediately, and we need one to avoid a Metal crash
        layer.frame = CGRect(x: 0, y: 0, width: 100, height: 100)
        
        // set the layer as the contents
        boxNode.geometry?.firstMaterial?.diffuse.contents = layer
        
        // start session
        session.startRunning()

    }
    
    @IBAction func stop(_ sender: Any) {
        session.stopRunning()
    }

    
    // this just makes the connected iOS device screen available as a camera
    static func prepareForDeviceMonitoring(){
        
        var prop = CMIOObjectPropertyAddress(
            mSelector: CMIOObjectPropertySelector(kCMIOHardwarePropertyAllowScreenCaptureDevices),
            mScope: CMIOObjectPropertyScope(kCMIOObjectPropertyScopeGlobal),
            mElement: CMIOObjectPropertyElement(kCMIOObjectPropertyElementMaster))
        var allow: UInt32 = 1;
        CMIOObjectSetPropertyData(CMIOObjectID(kCMIOObjectSystemObject), &prop,
                                  0, nil,
                                  UInt32(MemoryLayout.size(ofValue: allow)), &allow)
        
    }
    
}

