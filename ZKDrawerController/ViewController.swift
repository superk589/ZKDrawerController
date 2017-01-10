//
//  ViewController.swift
//  ZKDrawerController
//
//  Created by zzk on 2017/1/9.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var drawerController: ZKDrawerController!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "show", style: .plain, target: self, action: #selector(showRight))
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "show", style: .plain, target: self, action: #selector(showLeft))
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    func showLeft() {
        drawerController.showLeft(animated: true)
    }
    func showRight() {
        drawerController.showRight(animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

