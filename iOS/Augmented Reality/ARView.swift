//
//  ARView.swift
//  AR-Test
//
//  Created by Josh Fox on 2016/11/12.
//  Copyright © 2016 ydangle apps. All rights reserved.
//

import UIKit
import AVFoundation
import SceneKit
import CoreMotion

public class ARView : UIView {
    
    // 3D Vars
    var sceneView : SCNView!
    
    // Camera Vars
    var cameraSession : AVCaptureSession!
    var cameraLayer : AVCaptureVideoPreviewLayer?
    var cameraView : UIView!
    
    // Accelerometer vars
    var motionQueue : OperationQueue!
    var motionMananger : CMMotionManager!
    
    
    /** Constructor with frame */
    override public init(frame: CGRect) {
        super.init(frame: frame)
        setup()
    }
    
    /** Constructor with coder */
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setup()
    }
    
    /** Constructor with no arguments */
    convenience public init() {
        self.init(frame: CGRect(x: 0, y: 0, width: 64, height: 64))
    }
    
    /** @private Our initialization code */
    func setup() {
        
        // Setup camera
        setupCamera()
        
        // Setup 3D scene
        setup3D()
        
        // Setup accelerometer
        setupAccelerometer()
        
    }
    
    /** @private Set up the camera layer */
    func setupCamera() {
    
        // Create capture session
        cameraSession = AVCaptureSession()
        
        // Get camera
        guard let backCamera = AVCaptureDevice.defaultDevice(withMediaType: AVMediaTypeVideo) else {
            return
        }
        
        // Create input from camera
        guard let cameraInput = try? AVCaptureDeviceInput(device: backCamera) else {
            return
        }
        
        // Add input to the camera session
        if cameraSession!.canAddInput(cameraInput) {
            cameraSession.addInput(cameraInput)
        }
        
        // Create camera view
        cameraView = UIView()
        self.addSubview(cameraView)
        
        // Create output layer
        cameraLayer = AVCaptureVideoPreviewLayer(session: cameraSession)
        cameraLayer?.videoGravity = AVLayerVideoGravityResizeAspectFill
        cameraView.layer.addSublayer(cameraLayer!)
        
        // Start the camera session
        cameraSession.startRunning()
        
    }
    
    /** Layout subviews */
    override public func layoutSubviews() {
        super.layoutSubviews()
        
        // Make sure camera layer is filling the whole view
        cameraView?.frame = self.bounds
        cameraLayer?.frame = cameraView.bounds
        
    }
    
    /** @private Set up the 3D view */
    func setup3D() {
        
        // Create 3D view
        sceneView = SCNView()
        sceneView.frame = self.bounds
        sceneView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        sceneView.backgroundColor = UIColor.clear
        self.addSubview(sceneView)
        
        // Create 3D scene
        sceneView.scene = SCNScene()
        
        // Create 3D camera
        let cameraNode = SCNNode()
        cameraNode.camera = SCNCamera()
        
        // Add camera to scene
        sceneView.scene?.rootNode.addChildNode(cameraNode)
        
        // Set camera as render target
        sceneView.pointOfView = cameraNode
        
        // (Demo) Create pyramid
        let pyramid = SCNPyramid(width: 1, height: 1, length: 1)
        let pyramidNode = SCNNode(geometry: pyramid)
        pyramid.firstMaterial?.diffuse.contents = UIColor.green
        pyramidNode.position = SCNVector3(x: 0, y: 0, z: -10)
        sceneView.scene?.rootNode.addChildNode(pyramidNode)
        
        // (Demo) Create sphere
        let sphere = SCNSphere(radius: 1)
        let sphereNode = SCNNode(geometry: sphere)
        sphere.firstMaterial?.diffuse.contents = UIColor.blue
        sphereNode.position = SCNVector3(x: -10, y: -10, z: 0)
        sceneView.scene?.rootNode.addChildNode(sphereNode)
        
    }
    
    /** @private Set up the accelerometer */
    func setupAccelerometer() {
        
        // Create operation queue for our updates to be called on
        motionQueue = OperationQueue()
        motionQueue.maxConcurrentOperationCount = 1
        
        // Create instance of motion manager
        motionMananger = CMMotionManager()
        motionMananger.deviceMotionUpdateInterval = 1 / 60
        
        // Start receiving motion updates
        let ref = CMAttitudeReferenceFrame.xMagneticNorthZVertical
        motionMananger.startDeviceMotionUpdates(using: ref, to: motionQueue) { [weak self] (motionData, error) in
            
            // Stop if error
            if error != nil || motionData == nil {
                return
            }
            
            // Update 3D camera's rotation
            let deviceQuaternion = motionData!.attitude.quaternion
            self?.sceneView.pointOfView?.orientation = SCNQuaternion(
                x: Float(deviceQuaternion.x),
                y: Float(deviceQuaternion.y),
                z: Float(deviceQuaternion.z),
                w: Float(deviceQuaternion.w)
            )
            
        }
        
    }
    
}
