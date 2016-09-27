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
        
        let lbl = UILabel()
        lbl.frame = self.view.bounds
        lbl.autoresizingMask = [ .flexibleWidth, .flexibleHeight ]
        lbl.text = "Loading..."
        lbl.textAlignment = .center
        self.view.addSubview(lbl)
        
        
        
    }

}

