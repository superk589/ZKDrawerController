//
//  ViewController.swift
//  Example
//
//  Created by zzk on 07/09/2017.
//  Copyright © 2017 zzk. All rights reserved.
//

import UIKit
import ZKDrawerController

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = UIColor.blue
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showRight))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(showLeft))
    }
    
    @objc func showLeft() {
        drawerController?.show(.left, animated: true)
    }
    
    @objc func showRight() {
        drawerController?.show(.right, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }



}

