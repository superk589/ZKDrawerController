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
        view.backgroundColor = UIColor.blue
        
        //navigationItem.rightBarButtonItem = UIBarButtonItem.init(title: "show", style: .plain, target: self, action: #selector(showRight))
        navigationItem.leftBarButtonItem = UIBarButtonItem.init(title: "show", style: .plain, target: self, action: #selector(showLeft))
        // Do any additional setup after loading the view, typically from a nib.
        
        let button = UIButton.init(frame: CGRect.init(x: 200, y: 200, width: 150, height: 100))
        button.addTarget(self, action: #selector(push), for: .touchUpInside)
        button.setTitle("进入下一层页面", for: .normal)
        view.addSubview(button)
        
        let button3 = UIButton.init(frame: CGRect.init(x: 200, y: 350, width: 150, height: 100))
        button3.addTarget(self, action: #selector(presentAlert), for: .touchUpInside)
        button3.setTitle("显示警告弹窗", for: .normal)
        view.addSubview(button3)
        
    }
    func presentAlert() {
        let alert = UIAlertController.init(title: "aaaa", message: "aaaa", preferredStyle: .alert)
        self.present(alert, animated: true, completion: nil)
    }
    func showLeft() {
        drawerController.show(animated: true)
    }
    func showRight() {
        drawerController.show(animated: true)
    }
    
    func push() {
        let vc = ViewController()
        vc.drawerController = self.drawerController
        self.navigationController?.pushViewController(vc, animated: true)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

