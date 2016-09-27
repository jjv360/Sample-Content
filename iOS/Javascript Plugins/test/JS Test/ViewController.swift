//
//  ViewController.swift
//  JS Test
//
//  Created by Josh Fox on 2016/09/27.
//  Copyright © 2016 ydangle apps. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Create our output label
        let lbl = UILabel()
        lbl.frame = self.view.bounds
        lbl.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        lbl.text = "Loading..."
        lbl.textAlignment = .center
        self.view.addSubview(lbl)
        
        // Get URL to our script file
        guard let fileURL = Bundle.main.url(forResource: "my_plugin", withExtension: "js") else {
            return
        }
        
        // Create Plugin instance
        let plugin = Plugin(file: fileURL)
        
        // Add a message handler
        plugin.onmessage = { (data) in
            
            // Log the message to our output label
            let incomingData = data ?? "(null)"
            lbl.text = "Message received: \(incomingData)"
            
        }
        
        // Send a message to our plugin
        plugin.postMessage(data: "Hello!")
        
    }

}

