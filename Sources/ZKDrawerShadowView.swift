//
//  ZKDrawerShadowView.swift
//  ZKDrawerController
//
//  Created by zzk on 2017/1/8.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit

class ZKDrawerShadowView: UIView {
    
    enum Direction {
        case left
        case right
    }

    var direction: Direction = .left
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = UIColor.clear
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        let locations:[CGFloat] = (direction == .left ? [0, 1] : [1, 0])
        let colorSpace = CGColorSpaceCreateDeviceRGB()
        let colors = [UIColor.black.withAlphaComponent(0.5).cgColor, UIColor.black.withAlphaComponent(0).cgColor]
        let gradient = CGGradient.init(colorsSpace: colorSpace, colors: colors as CFArray, locations: locations)
        
        let startPoint = CGPoint.init(x: 0, y: 0)
        let endPoint = CGPoint.init(x: rect.size.width, y: 0)
        
        let context = UIGraphicsGetCurrentContext()
        
        context?.drawLinearGradient(gradient!, start: startPoint, end: endPoint, options: CGGradientDrawingOptions.init(rawValue: 0))
    }

}
