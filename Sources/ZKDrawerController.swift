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

public enum ZKDrawerControllerPosition {
    case left
    case right
    case center
}

public protocol ZKDrawerControllerDelegate: class {
    func drawerController(_ drawerVC: ZKDrawerController, willShow vc: UIViewController)
    func drawerController(_ drawerVC: ZKDrawerController, didHide vc: UIViewController)
}

public extension UIViewController {
    public var drawerController: ZKDrawerController? {
        var vc = parent
        while vc != nil {
            if vc is ZKDrawerController {
                return vc as? ZKDrawerController
            } else {
                vc = vc?.parent
            }
        }
        return nil
    }
}

open class ZKDrawerController: UIViewController, ZKDrawerCoverViewDelegate {
    
    override open var childViewControllerForStatusBarHidden: UIViewController? {
        return centerViewController
    }
    
    open override var childViewControllerForStatusBarStyle: UIViewController? {
        return centerViewController
    }
    
    open var defaultRightWidth: CGFloat = 300 {
        didSet {
            if let view = rightViewController?.view {
                view.snp.updateConstraints({ (update) in
                    update.width.equalTo(defaultRightWidth)
                })
                rightWidth = defaultRightWidth
            }
        }
    }
    
    open var defaultLeftWidth: CGFloat = 300 {
        didSet {
            if let view = leftViewController?.view {
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
    open var centerViewController: UIViewController! {
        didSet {
            remove(vc: oldValue)
            setupMainViewController(centerViewController)
        }
    }
    
    /// 右侧抽屉视图控制器
    open var rightViewController: UIViewController? {
        didSet {
            remove(vc: oldValue)
            setupRightViewController(rightViewController)
        }
    }
    
    /// 左侧抽屉视图控制器
    open var leftViewController: UIViewController? {
        didSet {
            remove(vc: oldValue)
            setupLeftViewController(leftViewController)
        }
    }
    
    open func viewController(of position: ZKDrawerControllerPosition) -> UIViewController? {
        switch position {
        case .center:
            return centerViewController
        case .left:
            return leftViewController
        case .right:
            return rightViewController
        }
    }
    
    /// 主视图在抽屉出现后的缩放比例
    open var mainScale: CGFloat = 1
    
    var lastPosition: ZKDrawerControllerPosition = .center

    open weak var delegate: ZKDrawerControllerDelegate?
    
    public convenience init(main: UIViewController, right: UIViewController) {
        self.init(center: main, right: right, left: nil)
    }
    
    public convenience init(main: UIViewController, left: UIViewController) {
        self.init(center: main, right: nil, left: left)
    }
    
    public convenience init(main: UIViewController) {
        self.init(center: main, right: nil, left: nil)
    }
    
    public init(center: UIViewController, right: UIViewController?, left: UIViewController?) {
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
        containerView.delegate = self
        
        centerViewController = center
        rightViewController = right
        leftViewController = left
        
        setupMainViewController(center)
        setupLeftViewController(left)
        setupRightViewController(right)
        
        mainCoverView = ZKDrawerCoverView()
        center.view.addSubview(mainCoverView)
        mainCoverView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
        mainCoverView.alpha = 0
        mainCoverView.delegate = self
        
        leftShadowView = ZKDrawerShadowView()
        leftShadowView.direction = .right
        containerView.addSubview(leftShadowView)
        leftShadowView.snp.makeConstraints { (make) in
            make.right.equalTo(center.view)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(shadowWidth)
        }
        rightShadowView = ZKDrawerShadowView()
        rightShadowView.direction = .left
        containerView.addSubview(rightShadowView)
        rightShadowView.snp.makeConstraints { (make) in
            make.left.equalTo(center.view)
            make.top.bottom.equalToSuperview()
            make.width.equalTo(shadowWidth)
        }
        leftShadowView.alpha = 0
        rightShadowView.alpha = 0
    }
    
    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    open override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        super.viewWillTransition(to: size, with: coordinator)
        let position = currentPosition
        let color = mainCoverView.backgroundColor
        self.mainCoverView.backgroundColor = .clear
        coordinator.animate(alongsideTransition: { (context) in
            switch position {
            case .right:
                self.containerView.setNeedsAdjustTo(.right)
            case .center:
                self.containerView.setNeedsAdjustTo(.center)
            default:
                break
            }
            self.containerView.setNeedsLayout()
            self.containerView.layoutIfNeeded()
            
        }, completion: { finished in
            self.mainCoverView.backgroundColor = color
        })
        
    }
  
    /// default true, 解决左侧抽屉划出手势和导航控制器手势冲突的问题
    open var shouldRequireFailureOfNavigationPopGesture: Bool {
        get {
            return containerView.shouldRequireFailureOfNavigationPopGesture
        }
        set {
            containerView.shouldRequireFailureOfNavigationPopGesture = newValue
        }
    }
    
    private func setupLeftViewController(_ viewController: UIViewController?) {
        guard let vc = viewController else {
            leftWidth = 0
            return
        }
        addChildViewController(vc)
        containerView.addSubview(vc.view)
        vc.view.snp.makeConstraints({ (make) in
            make.top.left.bottom.equalToSuperview()
            make.height.equalToSuperview()
            make.width.equalTo(defaultLeftWidth)
        })
        leftWidth = defaultLeftWidth
        containerView.setNeedsAdjustTo(.center)
        if let leftShadow = leftShadowView, let rightShadow = rightShadowView {
            containerView.bringSubview(toFront: leftShadow)
            containerView.bringSubview(toFront: rightShadow)
        }
    }
    
    private func setupRightViewController(_ viewController: UIViewController?) {
        guard let vc = viewController else {
            rightWidth = 0
            return
        }
        addChildViewController(vc)
        containerView.addSubview(vc.view)
        vc.view.snp.makeConstraints({ (make) in
            make.top.bottom.equalToSuperview()
            make.left.equalTo(centerViewController.view.snp.right)
            make.height.equalToSuperview()
            make.width.equalTo(defaultRightWidth)
        })
        rightWidth = defaultRightWidth
        if let leftShadow = leftShadowView, let rightShadow = rightShadowView {
            containerView.bringSubview(toFront: leftShadow)
            containerView.bringSubview(toFront: rightShadow)
        }
        vc.didMove(toParentViewController: self)
    }
    
    private func setupMainViewController(_ viewController: UIViewController) {
        addChildViewController(viewController)
        containerView.addSubview(viewController.view)
        viewController.view.snp.makeConstraints { (make) in
            make.top.bottom.equalToSuperview()
            make.height.equalToSuperview()
            make.left.equalTo(leftWidth)
            make.right.equalTo(-rightWidth)
            make.width.equalToSuperview()
        }
        viewController.didMove(toParentViewController: self)
    }
    
    private func remove(vc: UIViewController?) {
        vc?.view.snp.removeConstraints()
        vc?.view.removeFromSuperview()
        vc?.removeFromParentViewController()
        vc?.didMove(toParentViewController: nil)
    }
    
    func drawerCoverViewTapped(_ view: ZKDrawerCoverView) {
        hide(animated: true)
    }

    /// 弹出预先设定好的抽屉ViewController
    ///
    /// - Parameters:
    ///   - position: 抽屉的位置，center代表隐藏两侧抽屉
    ///   - animated: 是否有过渡动画
    open func show(_ position: ZKDrawerControllerPosition, animated: Bool) {
        switch position {
        case .center:
            hide(animated: animated)
        case .left, .right:
            if let frame = viewController(of: position)?.view.frame {
                containerView.scrollRectToVisible(frame, animated: animated)
            }
        }
    }
    
    /// 传入一个新的ViewController并从右侧弹出
    ///
    /// - Parameters:
    ///   - viewController: ViewController
    ///   - animated: 是否有过渡动画
    open func showRight(_ viewController: UIViewController, animated: Bool) {
        rightViewController = viewController
        show(.right, animated: animated)
    }
    
    /// 隐藏抽屉
    ///
    /// - Parameter animated: 是否有过渡动画
    open func hide(animated: Bool) {
        if #available(iOS 9.0, *) {
            self.containerView.setContentOffset(CGPoint.init(x: self.leftWidth, y: 0), animated: animated)
        } else {
            UIView.animate(withDuration: 0.3, animations: {
                self.containerView.contentOffset.x = self.leftWidth
            })
            
        }
    }
    
    /// 传入一个新的ViewController并从左侧弹出
    ///
    /// - Parameters:
    ///   - viewController: ViewController
    ///   - animated: 是否有过渡动画
    open func showLeft(_ viewController: UIViewController, animated: Bool) {
        leftViewController = viewController
        show(.left, animated: animated)
    }

}

extension ZKDrawerController: UIScrollViewDelegate {
    
    open func scrollViewDidEndDragging(_ scrollView: UIScrollView, willDecelerate decelerate: Bool) {
        if decelerate {
            scrollView.panGestureRecognizer.isEnabled = false
        }
    }
    
    open func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
        scrollView.panGestureRecognizer.isEnabled = true
    }
    
    open func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        let offset = scrollView.contentOffset
        if velocity.x == 0 {
            if offset.x > leftWidth + rightWidth / 2 {
                targetContentOffset.pointee.x = rightWidth + leftWidth
            } else if offset.x < leftWidth / 2 {
                targetContentOffset.pointee.x = 0
            } else {
                targetContentOffset.pointee.x = leftWidth
            }
        } else if velocity.x > 0 {
            if offset.x > leftWidth {
                targetContentOffset.pointee.x = rightWidth + leftWidth
            } else {
                targetContentOffset.pointee.x = leftWidth
            }
        } else {
            if offset.x < leftWidth {
                targetContentOffset.pointee.x = 0
            } else {
                targetContentOffset.pointee.x = leftWidth
            }
        }
        
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        if lastPosition == .center && lastPosition != currentPosition {
            if let vc = rightViewController ?? leftViewController {
                delegate?.drawerController(self, willShow: vc)
            }
        } else if lastPosition != .center && lastPosition != currentPosition {
            if let vc = rightViewController ?? leftViewController {
                delegate?.drawerController(self, willShow: vc)
            }
        }
        lastPosition = currentPosition

        let width = scrollView.frame.size.width
        let offsetX = scrollView.contentOffset.x
        
        /// 0 to 1
        let progress: CGFloat = {
            if currentPosition == .left {
                return (leftWidth - offsetX) / leftWidth
            } else if currentPosition == .right {
                return (width + rightWidth - scrollView.contentSize.width + offsetX) / rightWidth
            }
            return 0
        }()
        
        let scale: CGFloat = {
            if currentPosition == .left || currentPosition == .right {
                return 1 + progress * (mainScale - 1)
            } else {
                return 1
            }
        }()
        
        let centerView = centerViewController.view!
        centerView.transform = CGAffineTransform.init(scaleX: scale, y: scale)
        mainCoverView.alpha = progress
        containerView.endEditing(true)
        
        if currentPosition == .left {
            switch drawerStyle {
            case .plain:
                centerView.transform.tx = -(1 - scale) * width / 2
            case .cover:
                centerView.transform.tx = (1 - scale) * width / 2 - leftWidth * progress
                rightShadowView.alpha = progress
            case .insert:
                leftShadowView.alpha = progress
                centerView.transform.tx = -(1 - scale) * width / 2
            }
        } else if currentPosition == .right {
            switch drawerStyle {
            case .plain:
                centerView.transform.tx = (1 - scale) * width / 2
            case .cover:
                centerView.transform.tx = -(1 - scale) * width / 2 + rightWidth * progress
                leftShadowView.alpha = progress
            case .insert:
                rightShadowView.alpha = progress
                centerView.transform.tx = (1 - scale) * width / 2
            }
        } else {
            centerView.transform.tx = 0
            leftShadowView.alpha = 0
            rightShadowView.alpha = 0
        }
    }
}

extension ZKDrawerController {

    var rightWidth: CGFloat {
        set {
            containerView.rightWidth = newValue
            centerViewController.view.snp.updateConstraints { (update) in
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
            centerViewController.view.snp.updateConstraints { (update) in
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
                    make.right.equalTo(centerViewController.view.snp.left)
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(shadowWidth)
                }
                rightShadowView.snp.remakeConstraints { (make) in
                    make.left.equalTo(centerViewController.view.snp.right)
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(shadowWidth)
                }
            case .cover:
                rightShadowView.isHidden = false
                leftShadowView.isHidden = false
                
                leftShadowView.snp.remakeConstraints { (make) in
                    make.right.equalTo(centerViewController.view)
                    make.top.bottom.equalToSuperview()
                    make.width.equalTo(shadowWidth)
                }
                rightShadowView.snp.remakeConstraints { (make) in
                    make.left.equalTo(centerViewController.view)
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
    
    
    /// 当前状态
    open var currentPosition: ZKDrawerControllerPosition {
        if containerView.contentOffset.x < leftWidth {
            return .left
        } else if containerView.contentOffset.x > leftWidth {
            return .right
        } else {
            return .center
        }
    }
    
}
