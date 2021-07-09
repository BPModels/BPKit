//
//  UIView+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import Toast_Swift

/**
 *  ViewGeometry
 */
public extension UIView {

    /// 顶部距离父控件的距离
    ///
    ///     self.frame.origin.y
    var top: CGFloat {
        get{
            return self.frame.origin.y
        }
        
        set{
            var frame = self.frame
            frame.origin.y = newValue
            self.frame = frame
        }
    }

    /// 左边距离父控件的距离
    ///
    ///     self.frame.origin.x
    var left: CGFloat {
        get{
            return self.frame.origin.x
        }
        
        set{
            var frame = self.frame
            frame.origin.x = newValue
            self.frame = frame
        }
    }

    /// 当前View的底部,距离父控件顶部的距离
    ///
    ///     self.frame.maxY
    var bottom: CGFloat {
        get {
            return self.frame.maxY
        }
        
        set {
            var frame = self.frame
            frame.origin.y = newValue - frame.size.height
            self.frame = frame
        }
    }

    /// 当前View的右边,距离父控件左边的距离
    ///
    ///     self.frame.maxX
    var right: CGFloat {
        get {
            return self.frame.maxX
        }
        
        set {
            guard let superW = superview?.width else { return }
            var frame = self.frame
            frame.origin.x = superW - newValue - frame.width
            self.frame = frame
        }
    }

    /// 宽度
    var width: CGFloat {
        get {
            return self.frame.size.width
        }
        
        set {
            var frame = self.frame
            frame.size.width = newValue
            self.frame = frame
        }
    }

    /// 高度
    var height: CGFloat {
        get {
            return self.frame.size.height
        }
        
        set {
            var frame = self.frame
            frame.size.height = newValue
            self.frame = frame
        }
    }

    /// X轴的中心位置
    var centerX: CGFloat {
        get {
            return self.center.x
        }
        
        set {
            self.center = CGPoint(x: newValue, y: self.center.y)
        }
    }

    /// Y轴的中心位置
    var centerY: CGFloat {
        get {
            return self.center.y
        }
        
        set {
            self.center = CGPoint(x: self.center.x, y: newValue)
        }
    }

    /// 左上角的顶点,在父控件中的位置
    var origin: CGPoint {
        get {
            return self.frame.origin
        }
        
        set {
            var frame = self.frame
            frame.origin = newValue
            self.frame = frame
        }
    }

    /// 尺寸大小
    var size: CGSize {
        get {
            return self.frame.size
        }
        
        set {
            var frame = self.frame
            frame.size = newValue
            self.frame = frame
        }
    }
}

public extension UIView {
    
    /// 移除父视图中的所有子视图
    func removeAllSubviews() {
        while (self.subviews.count > 0) {
            self.subviews.last?.removeFromSuperview()
        }
    }
}

public extension UIView {
    
    /// 裁剪 view 的圆角,裁一角或者全裁
    ///
    /// 其实就是根据当前View的Size绘制了一个 CAShapeLayer,将其遮在了当前View的layer上,就是Mask层,使mask以外的区域不可见
    /// - parameter direction: 需要裁切的圆角方向,左上角(topLeft)、右上角(topRight)、左下角(bottomLeft)、右下角(bottomRight)或者所有角落(allCorners)
    /// - parameter cornerRadius: 圆角半径
    func clipRectCorner(direction: UIRectCorner, cornerRadius: CGFloat) {
        let cornerSize = CGSize(width:cornerRadius, height:cornerRadius)
        let maskPath = UIBezierPath(roundedRect: bounds, byRoundingCorners: direction, cornerRadii: cornerSize)
        let maskLayer = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path = maskPath.cgPath
        layer.addSublayer(maskLayer)
        layer.mask = maskLayer
    }

    /// 根据需要,裁剪各个顶点为圆角
    ///
    /// 其实就是根据当前View的Size绘制了一个 CAShapeLayer,将其遮在了当前View的layer上,就是Mask层,使mask以外的区域不可见
    /// - parameter directionList: 需要裁切的圆角方向,左上角(topLeft)、右上角(topRight)、左下角(bottomLeft)、右下角(bottomRight)或者所有角落(allCorners)
    /// - parameter cornerRadius: 圆角半径
    /// - note: .pi等于180度,圆角计算,默认以圆横直径的右半部分顺时针开始计算(就类似上面那个圆形中的‘=====’线),当然如果参数 clockwies 设置false.则逆时针开始计算角度
    func clipRectCorner(directionList: [UIRectCorner], cornerRadius radius: CGFloat) {
        let bezierPath = UIBezierPath()
        // 以左边中间节点开始绘制
        bezierPath.move(to: CGPoint(x: 0, y: height/2))
        // 如果左上角需要绘制圆角
        if directionList.contains(.topLeft) {
            bezierPath.move(to: CGPoint(x: 0, y: radius))
            bezierPath.addArc(withCenter: CGPoint(x: radius, y: radius), radius: radius, startAngle: .pi, endAngle: .pi * 1.5, clockwise: true)
        } else {
            bezierPath.addLine(to: origin)
        }
        // 如果右上角需要绘制
        if directionList.contains(.topRight) {
            bezierPath.addLine(to: CGPoint(x: right - radius, y: 0))
            bezierPath.addArc(withCenter: CGPoint(x: width - radius, y: radius), radius: radius, startAngle: CGFloat.pi * 1.5, endAngle: CGFloat.pi * 2, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: width, y: 0))
        }
        // 如果右下角需要绘制
        if directionList.contains(.bottomRight) {
            bezierPath.addLine(to: CGPoint(x: width, y: height - radius))
            bezierPath.addArc(withCenter: CGPoint(x: width - radius, y: height - radius), radius: radius, startAngle: 0, endAngle: CGFloat.pi/2, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: width, y: height))
        }
        // 如果左下角需要绘制
        if directionList.contains(.bottomLeft) {
            bezierPath.addLine(to: CGPoint(x: radius, y: height))
            bezierPath.addArc(withCenter: CGPoint(x: radius, y: height - radius), radius: radius, startAngle: CGFloat.pi/2, endAngle: CGFloat.pi, clockwise: true)
        } else {
            bezierPath.addLine(to: CGPoint(x: 0, y: height))
        }
        // 与开始节点闭合
        bezierPath.addLine(to: CGPoint(x: 0, y: height/2))

        let maskLayer   = CAShapeLayer()
        maskLayer.frame = bounds
        maskLayer.path  = bezierPath.cgPath
        layer.mask      = maskLayer
    }

    /// 高斯模糊
    func setBlurEffect(style: UIBlurEffect.Style = .light) {
        let blur = UIBlurEffect(style: style)
        let effectView = UIVisualEffectView(effect: blur)
        self.addSubview(effectView)
        effectView.snp.makeConstraints { (make) in
            make.edges.equalToSuperview()
        }
    }
}

public extension UIView {
    
    /// 显示Toast提示，基于当前的View，不影响其他页面的操作
    func toast(_ message: String, duration: TimeInterval = 1.5, completion: ((_ didTap: Bool) -> Void)? = nil) {
        DispatchQueue.main.async { [weak self] in
            guard let self = self else { return }
            var style = ToastStyle()
            style.messageAlignment = .center
            self.makeToast(message, duration: duration, point: self.center, title: nil, image: nil, style: style, completion: completion)
        }
    }
    
    /// 显示Toast提示，基于最顶层，可能会影响其他的操作
    class func topToast(_ message: String) {
        if let topWindow = UIApplication.shared.windows.last {
            topWindow.toast(message)
        }
    }
}
