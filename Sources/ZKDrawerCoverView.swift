//
//  ZKDrawerCoverView.swift
//  ZKDrawerController
//
//  Created by zzk on 2017/1/8.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

protocol ZKDrawerCoverViewDelegate: class {
    func drawerCoverViewTapped(_ view: ZKDrawerCoverView)
}

public class ZKDrawerCoverView: UIView {

    weak var delegate: ZKDrawerCoverViewDelegate?
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        let tap = UITapGestureRecognizer.init(target: self, action: #selector(tapAction))
        addGestureRecognizer(tap)
    }
    
    @objc func tapAction() {
        delegate?.drawerCoverViewTapped(self)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
