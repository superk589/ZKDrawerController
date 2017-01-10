//
//  ZKDrawerController.swift
//  ZKDrawerController
//
//  Created by zzk on 2017/1/7.
//  Copyright © 2017年 zzk. All rights reserved.
//
import UIKit
import SnapKit

public enum ZKDrawerCoverStyle {
    /// 水平平铺 无阴影
    case plain
    /// 上方覆盖 抽屉视图外边缘有阴影
    case cover
    /// 下方插入 主视图外边缘有阴影
    case insert
}

public enum ZKDrawerStatus {
    case left
    case right
    case center
}

open class ZKDrawerController: UIViewController, ZKDrawerCoverViewDelegate {
    
    open var defaultRightWidth: CGFloat = 300 {
        didSet {
            if let view = rightVC?.view {
                view.snp.updateConstraints({ (update) in
                    update.width.equalTo(defaultRightWidth)
                })
                rightWidth = defaultRightWidth
            }
        }
    }
    
    open var defaultLeftWidth: CGFloat = 300 {
        didSet {
            if let view = leftVC?.view {
                view.snp.updateConstraints({ (update) in
                    update.width.equalTo(defaultLeftWidth)
                })
                leftWidth = defaultLeftWidth
            }
        }
    }
    
    /// 作为容器的滚动视图
    open var containerView: ZKDrawerScrollView!
    
    /// 背景图片视图
    open var backgroundImageView: UIImageView!
    
    /// 左侧阴影
    var leftShadowView: ZKDrawerShadowView!
    
    /// 右侧阴影
    var rightShadowView: ZKDrawerShadowView!
    
    /// 主视图蒙层
    open var mainCoverView: ZKDrawerCoverView!
    
    var lastStatus: ZKDrawerStatus = .center
    
    /// 阴影视图的宽度
    open var shadowWidth: CGFloat = 5 {
        didSet {
            leftShadowView.snp.updateConstraints { (update) in
                update.width.equalTo(shadowWidth)
            }
            rightShadowView.snp.updateConstraints { (update) in
                update.width.equalTo(shadowWidth)
            }
        }
    }
    
    
    /// 主视图控制器
    open var mainVC: UIViewController! {
        didSet {
            removeOldVC(vc: oldValue)
            setupMainVC(vc: mainVC)
        }
    }
    
    /// 右侧抽屉视图控制器
    open var rightVC: UIViewController? {
        didSet {
            removeOldVC(vc: oldValue)
            setupRightVC(vc: rightVC)
        }
    }
    
    /// 左侧抽屉视图控制器
    open var leftVC: UIViewController? {
        didSet {
            removeOldVC(vc: oldValue)
            setupLeftVC(vc: leftVC)
        }
    }
    
    /// 主视图在抽屉出现后的缩放比例
    open var mainScale: CGFloat = 1
    
    
    public init(main: UIViewController, right: UIViewController?, left: UIViewController?) {
        super.init(nibName: nil, bundle: nil)
        containerView = ZKDrawerScrollView()
        backgroundImageView = UIImageView()
        containerView.addSubview(backgroundImageView)
        backgroundImageView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        
        view.addSubview(containerView)
        containerView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        self.addChildViewController(main)
        containerView.delegate = self
        
        self.mainVC = main
        self.rightVC = right
        self.leftVC = left
        
        setupMainVC(vc: main)
        setupLeftVC(vc: left)
        setupRightVC(vc: right)
        
        mainCoverView = ZKDrawerCoverView()
        main.view.addSubview(mainCoverView)
        mainCoverView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mainCoverView.alpha = 0
        mainCoverView.delegate = self
        
        
        leftShadowView = ZKDrawerShadowView()
        leftShadowView.direction = .right
        containerView.addSubview(leftShadowView)
        leftShadowView.snp.makeConstraints { (make) in
            make.right.equalTo(main.view)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(shadowWidth)
        }
        rightShadowView = ZKDrawerShadowView()
        rightShadowView.direction = .left
        containerView.addSubview(rightShadowView)
        rightShadowView.snp.makeConstraints { (make) in
            make.left.equalTo(main.view)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(shadowWidth)
        }
        leftShadowView.alpha = 0
        rightShadowView.alpha = 0
        
        // 导航手势失败才可以执行左侧菜单手势
        if let gesture = main.navigationController?.interactivePopGestureRecognizer {
            containerView.panGestureRecognizer.require(toFail: gesture)
        }
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setupLeftVC(vc: UIViewController?) {
        if let controller = vc {
            self.addChildViewController(controller)
        }
        if let view = vc?.view {
            containerView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.top.left.bottom.equalToSuperview()
                make.height.equalToSuperview()
                make.width.equalTo(defaultLeftWidth)
            })
            leftWidth = defaultLeftWidth
            containerView.needAdjustContentOffset = true
            if let leftShadow = leftShadowView, let rightShadow = rightShadowView {
                containerView.bringSubview(toFront: leftShadow)
                containerView.bringSubview(toFront: rightShadow)
            }
        } else {
            leftWidth = 0
        }
    }
    
    func setupRightVC(vc: UIViewController?) {
        if let controller = vc {
            self.addChildViewController(controller)
        }
        if let view = vc?.view {
            containerView.addSubview(view)
            view.snp.makeConstraints({ (make) in
                make.top.bottom.equalToSuperview()
                make.left.equalTo(mainVC.view.snp.right)
                make.height.equalToSuperview()
                make.width.equalTo(defaultRightWidth)
            })
            rightWidth = defaultRightWidth
            if let leftShadow = leftShadowView, let rightShadow = rightShadowView {
                containerView.bringSubview(toFront: leftShadow)
                containerView.bringSubview(toFront: rightShadow)
            }

        } else {
            rightWidth = 0
        }
    }
    
    var mainLeftConstrain: Constraint!
    var mainRightConstrain: Constraint!
    func setupMainVC(vc: UIViewController) {
        self.addChildViewController(vc)
        containerView.addSubview(vc.view)
        vc.view.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
            make.left.equalTo(leftWidth)
            make.right.equalTo(-rightWidth)
            make.width.equalToSuperview()
        }
    }
    
    func removeOldVC(vc: UIViewController?) {
        vc?.view.snp.removeConstraints()
        vc?.view.removeFromSuperview()
        vc?.removeFromParentViewController()
    }
    
    func drawerCoverViewTapped(_ view: ZKDrawerCoverView) {
        if status == .right {
            self.hideRight(animated: true)
        } else if status == .left {
            self.hideleft(animated: true)
        }
    }

    /// 弹出预先设定好的右侧抽屉ViewController
    ///
    /// - Parameter animated: 是否有过度动画
    open func showRight(animated: Bool) {
        if let frame = rightVC?.view.frame {
            self.containerView.scrollRectToVisible(frame, animated: animated)
        }
    }
    
    
    /// 传入一个新的ViewController并从右侧弹出
    ///
    /// - Parameters:
    ///   - vc: ViewController
    ///   - animated: 是否有过度动画
    open func showRightVC(_ vc: UIViewController, animated: Bool) {
        rightVC = vc
        showRight(animated: animated)
    }
    
    
    /// 隐藏右侧抽屉
    ///
    /// - Parameter animated: 是否有过度动画
    open func hideRight(animated: Bool) {
        self.containerView.setContentOffset(CGPoint.init(x: self.leftWidth, y: 0), animated: animated)
    }
    
    /// 弹出预先设定好的左侧抽屉ViewController
    ///
    /// - Parameter animated: 是否有过度动画
    open func showLeft(animated: Bool) {
        if let frame = leftVC?.view.frame {
            self.containerView.scrollRectToVisible(frame, animated: animated)
        }
    }
    
    
    /// 传入一个新的ViewController并从左侧弹出
    ///
    /// - Parameters:
    ///   - vc: ViewController
    ///   - animated: 是否有过度动画
    open func showleftVC(_ vc: UIViewController, animated: Bool) {
        leftVC = vc
        showLeft(animated: animated)
    }
    
    /// 隐藏左侧抽屉
    ///
    /// - Parameter animated: 是否有过度动画
    open func hideleft(animated: Bool) {
        hideRight(animated: animated)
    }
    
    
}

extension ZKDrawerController: UIScrollViewDelegate {
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        // 左右同时有抽屉时 在滑动回到正中时停止
        if lastStatus != .center && lastStatus != status {
            lastStatus = status
            scrollView.setContentOffset(CGPoint.init(x: leftWidth, y: 0), animated: false)
        } else {
            lastStatus = status
        }

        let width = scrollView.frame.size.width
        let offsetX = scrollView.contentOffset.x
        
        /// 0 to 1 progress of the drawer showing
        let progress: CGFloat = {
            if status == .left {
                return (leftWidth - offsetX) / leftWidth
            } else if status == .right {
                return (width + rightWidth - scrollView.contentSize.width + offsetX) / rightWidth
            }
            return 0
        }()
        
        let scale: CGFloat = {
            if status == .left || status == .right {
                return 1 + progress * (mainScale - 1)
            } else {
                return 1
            }
        }()
        
        mainVC.view.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        mainCoverView.alpha = progress
        containerView.endEditing(true)
        
        if status == .left {
            switch drawerStyle {
            case .plain:
                mainVC.view.transform.tx = -(1 - scale) * width / 2
            case .cover:
                mainVC.view.transform.tx = (1 - scale) * width / 2 - leftWidth * progress
                rightShadowView.alpha = progress
            case .insert:
                leftShadowView.alpha = progress
                mainVC.view.transform.tx = -(1 - scale) * width / 2
            }
        } else if status == .right {
            switch drawerStyle {
            case .plain:
                mainVC.view.transform.tx = (1 - scale) * width / 2
            case .cover:
                mainVC.view.transform.tx = -(1 - scale) * width / 2 + rightWidth * progress
                leftShadowView.alpha = progress
            case .insert:
                rightShadowView.alpha = progress
                mainVC.view.transform.tx = (1 - scale) * width / 2
            }
        } else {
            mainVC.view.transform.tx = 0
            leftShadowView.alpha = 0
            rightShadowView.alpha = 0
        }
    }
    
    public func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if !decelerate {
            addPageAnimation(scrollView)
        }
    }
    public func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        addPageAnimation(scrollView)
    }
    
    public func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        scrollView.isUserInteractionEnabled = true
    }

    
    // 用于添加类似pageEnabled的效果
    func addPageAnimation(_ scrollView: UIScrollView) {
        let width = scrollView.frame.size.width
        let offsetX = scrollView.contentOffset.x
        
        /// 0 to 1 progress of the drawer showing
        let progress: CGFloat = {
            if status == .left {
                return (leftWidth - offsetX) / leftWidth
            } else if status == .right {
                return (width + rightWidth - scrollView.contentSize.width + offsetX) / rightWidth
            }
            return 0
        }()
        
        if progress >= 0.5 {
            if status == .left {
                scrollView.setContentOffset(CGPoint.init(x: 0, y: 0), animated: true)
            } else if status == .right {
                scrollView.setContentOffset(CGPoint.init(x: scrollView.contentSize.width - width, y: 0), animated: true)
            }
        } else {
            scrollView.setContentOffset(CGPoint.init(x: leftWidth, y: 0), animated: true)
        }
    }

}

extension ZKDrawerController {

    var rightWidth:CGFloat {
        set {
            containerView.rightWidth = newValue
            mainVC.view.snp.updateConstraints { (update) in
                update.right.equalTo(-newValue)
            }
        }
        get {
            return containerView.rightWidth
        }
    }
    
    var leftWidth: CGFloat {
        set {
            containerView.leftWidth = newValue
            mainVC.view.snp.updateConstraints { (update) in
                update.left.equalTo(newValue)
            }
        }
        get {
            return containerView.leftWidth
        }
    }
    
    /// 抽屉风格
    open var drawerStyle: ZKDrawerCoverStyle {
        set {
            containerView.drawerStyle = newValue
            switch newValue {
            case .plain:
                rightShadowView.isHidden = true
                leftShadowView.isHidden = true
            case .insert:
                rightShadowView.isHidden = false
                leftShadowView.isHidden = false
                leftShadowView.snp.remakeConstraints { (make) in
                    make.right.equalTo(mainVC.view.snp.left)
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(shadowWidth)
                }
                rightShadowView.snp.remakeConstraints { (make) in
                    make.left.equalTo(mainVC.view.snp.right)
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(shadowWidth)
                }
            case .cover:
                rightShadowView.isHidden = false
                leftShadowView.isHidden = false
                
                leftShadowView.snp.remakeConstraints { (make) in
                    make.right.equalTo(mainVC.view)
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(shadowWidth)
                }
                rightShadowView.snp.remakeConstraints { (make) in
                    make.left.equalTo(mainVC.view)
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(shadowWidth)
                }
            }
        }
        get {
            return containerView.drawerStyle
        }
    }
    
    /// 主视图上用来拉出抽屉的手势生效区域距边缘的宽度
    open var gestureRecognizerWidth: CGFloat {
        set {
            containerView.gestureRecognizerWidth = newValue
        }
        get {
            return containerView.gestureRecognizerWidth
        }
    }
    
    open var status: ZKDrawerStatus {
        if containerView.contentOffset.x < leftWidth {
            return .left
        } else if containerView.contentOffset.x > leftWidth {
            return .right
        } else {
            return .center
        }
    }
    
}
