//
//  ViewController.swift
//  AR-Test
//
//  Created by Josh Fox on 2016/11/12.
//  Copyright © 2016 ydangle apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    var arView : ARView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create ARView
        arView = ARView()
        arView.frame = self.view.bounds
        arView.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        self.view.addSubview(arView)
        
    }
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }

}

