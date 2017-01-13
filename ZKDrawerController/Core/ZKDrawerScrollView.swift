//
//  ZKDrawerScrollView.swift
//  ZKDrawerController
//
//  Created by zzk on 2017/1/7.
//  Copyright © 2017年 zzk. All rights reserved.
//

import UIKit
import SnapKit

public class ZKDrawerScrollView: UIScrollView {
    
    var rightWidth: CGFloat = 0
    
    var leftWidth: CGFloat = 0
    
    var mainScale: CGFloat = 1
    
    var drawerStyle: ZKDrawerCoverStyle = .cover
    
    var gestureRecognizerWidth:CGFloat = 40
    
    public override init(frame: CGRect) {
        super.init(frame: frame)

        self.backgroundColor = UIColor.clear
        self.showsHorizontalScrollIndicator = false
        self.bounces = false
        self.isPagingEnabled = true
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var needAdjustContentOffset: Bool = true
    public override func layoutSubviews() {
        super.layoutSubviews()
        if needAdjustContentOffset {
            self.contentOffset.x = leftWidth
            needAdjustContentOffset = false
        }
    }
    
    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        //拿到手势生效的坐标点（相对于scrollView的内部空间）
        let point = gestureRecognizer.location(in: self)
        
        if self.contentOffset.x == 0 && leftWidth > 0 {
            //当偏移量为0时（左侧菜单完全展示）
            if point.x < self.frame.size.width {
                return true
            }
        } else if self.contentOffset.x == contentSize.width - self.frame.size.width && rightWidth > 0 {
            //当偏移量为contentSize.width时（右侧菜单完全展示）
            if point.x + self.frame.size.width > contentSize.width {
                return true
            }
            
        } else {
            if point.x < leftWidth + gestureRecognizerWidth || point.x > contentSize.width - rightWidth - gestureRecognizerWidth {
                return true
            }
        }
        return false
    }
//    public override func setContentOffset(_ contentOffset: CGPoint, animated: Bool) {
//        super.setContentOffset(contentOffset, animated: animated)
//        if animated && contentOffset != self.contentOffset {
//            self.isUserInteractionEnabled = false 
//        }
//    }
}
