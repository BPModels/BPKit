//
//  UIColor+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation
import UIKit
import CoreGraphics

public extension UIColor {
    class func make(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        if #available(iOS 10.0, *) {
            return UIColor(displayP3Red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        }else{
            return UIColor(red: red/255.0, green: green/255.0, blue: blue/255.0, alpha: alpha)
        }
    }

    /// 十六进制颜色值
    /// - parameter hex: 十六进制值,例如: 0x000fff
    /// - parameter alpha: 透明度
    class func hex(_ hex: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        if hex > 0xFFF {
            let divisor = CGFloat(255)
            let red     = CGFloat((hex & 0xFF0000) >> 16) / divisor
            let green   = CGFloat((hex & 0xFF00  ) >> 8)  / divisor
            let blue    = CGFloat( hex & 0xFF    )        / divisor
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        } else {
            let divisor = CGFloat(15)
            let red     = CGFloat((hex & 0xF00) >> 8) / divisor
            let green   = CGFloat((hex & 0x0F0) >> 4) / divisor
            let blue    = CGFloat( hex & 0x00F      ) / divisor
            return UIColor(red: red, green: green, blue: blue, alpha: alpha)
        }
    }

    /// 根据方向,设置渐变色
    ///
    /// - Parameters:
    ///   - size: 渐变区域大小
    ///   - colors: 渐变色数组
    ///   - direction: 渐变方向
    /// - Returns: 渐变后的颜色,如果设置失败,则返回nil
    /// - note: 设置前,一定要确定当前View的高宽!!!否则无法准确的绘制
    class func gradientColor(with size: CGSize, colors: [CGColor], direction: GradientDirectionType) -> UIColor? {
        switch direction {
        case .horizontal:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0, y: 0.5), endPoint: CGPoint(x: 1, y: 0.5))
        case .vertical:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0.5, y: 0), endPoint: CGPoint(x: 0.5, y: 1))
        case .leftTop:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0, y: 0), endPoint: CGPoint(x: 1, y: 1))
        case .leftBottom:
            return gradientColor(with: size, colors: colors, startPoint: CGPoint(x: 0, y: 1), endPoint: CGPoint(x: 1, y: 0))
        }
    }

    /// 设置渐变色
    /// - parameter size: 渐变文字区域的大小.也就是用于绘制的区域
    /// - parameter colors: 渐变的颜色数组,从左到右顺序渐变,区域均匀分布
    /// - parameter startPoint: 渐变开始坐标
    /// - parameter endPoint: 渐变结束坐标
    /// - returns: 返回一个渐变的color,如果绘制失败,则返回nil;
    class func gradientColor(with size: CGSize, colors: [CGColor], startPoint: CGPoint, endPoint: CGPoint) -> UIColor? {
        // 设置画布,开始准备绘制
        UIGraphicsBeginImageContextWithOptions(size, false, kScreenScale)
        // 获取当前画布上下文,用于操作画布对象
        guard let context     = UIGraphicsGetCurrentContext() else { return nil }
        // 创建RGB空间
        let colorSpaceRef     = CGColorSpaceCreateDeviceRGB()
        // 在RGB空间中绘制渐变色,可设置渐变色占比,默认均分
        guard let gradientRef = CGGradient(colorsSpace: colorSpaceRef, colors: colors as CFArray, locations: nil) else { return nil }
        // 设置渐变起始坐标
        let startPoint        = CGPoint(x: size.width * startPoint.x, y: size.height * startPoint.y)
        // 设置渐变结束坐标
        let endPoint          = CGPoint(x: size.width * endPoint.x, y: size.height * endPoint.y)
        // 开始绘制图片
        context.drawLinearGradient(gradientRef, start: startPoint, end: endPoint, options: CGGradientDrawingOptions(rawValue: CGGradientDrawingOptions.drawsBeforeStartLocation.rawValue | CGGradientDrawingOptions.drawsAfterEndLocation.rawValue))
        // 获取渐变图片
        guard let gradientImage = UIGraphicsGetImageFromCurrentImageContext() else { return nil }
        return UIColor(patternImage: gradientImage)
    }
    
}
//MARK: **************** 颜色值 **********************
public extension UIColor {

    //MARK: 颜色快捷设置相关函数
    static func ColorWithRGBA(red: CGFloat, green: CGFloat, blue: CGFloat, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.make(red: red, green: green, blue: blue, alpha: alpha)
    }

    static func ColorWithHexRGBA(_ hex: UInt32, alpha: CGFloat = 1.0) -> UIColor {
        return UIColor.hex(hex, alpha: alpha)
    }

    /// 获得随机颜色
    /// - Returns: 随机颜色
    static func randomColor(alpheRandom: Bool = false) -> UIColor {
        let red   = CGFloat.random(in: 0...255)
        let green = CGFloat.random(in: 0...255)
        let blue  = CGFloat.random(in: 0...255)
        var alphe = CGFloat(1)
        if alpheRandom {
            alphe = CGFloat.random(in: 0...1)
        }
        return ColorWithRGBA(red: red, green: green, blue: blue, alpha: alphe)
    }
    
    // TODO: ====== Green ====
    /// 文字 (red: 16, green: 188, blue: 131)
    static let green0 = ColorWithRGBA(red: 16, green: 188, blue: 131)
    /// 微信Icon背景色 (red: 6, green: 194, blue: 95)
    static let green1 = ColorWithRGBA(red: 6, green: 194, blue: 95)
    
    /// 文字 (red: 16, green: 188, blue: 131)
    var darkGreen0: UIColor {
        
        return UIColor.blue0
    }
    
    // TODO: ====== Black ====
    /// 文字 (red: 48, green: 49, blue: 51)
    static let black0 = ColorWithRGBA(red: 48, green: 49, blue: 51)
    /// 文字 (red: 96, green: 98, blue: 102)
    static let black1 = ColorWithRGBA(red: 96, green: 98, blue: 102)
    
    // TODO: ====== Red ====
    /// newTag ColorWithRGBA(red: 241, green: 44, blue: 32)
    static let red0 = ColorWithRGBA(red: 241, green: 44, blue: 32)
    /// 必填 ColorWithRGBA(red: 241, green: 86, blue: 66)
    static let red1 = ColorWithRGBA(red: 241, green: 86, blue: 66)
    /// 退出登录 (red: 253, green: 100, blue: 34)
    static let red2 = ColorWithRGBA(red: 253, green: 100, blue: 34)
    /// 已停工 (red: 196, green: 58, blue: 41)
    static let red3 = ColorWithRGBA(red: 196, green: 58, blue: 41)

    // TODO: ====== Blue ====
    /// 主题蓝 (red: 60, green: 135, blue: 246)
    static let blue0 = ColorWithRGBA(red: 60, green: 135, blue: 246)
    /// 次主题蓝 (red: 81, green: 116, blue: 154)
    static let blue1 = ColorWithRGBA(red: 81, green: 116, blue: 154)
    /// 空工作台按钮文字 (red: 89, green: 86, blue: 214)
    static let blue2 = ColorWithRGBA(red: 89, green: 86, blue: 214)
    
    // TODO: ====== Orange ====
    /// 文字背景 (red: 255, green: 170, blue: 2)
    static let orange0 = ColorWithRGBA(red: 255, green: 170, blue: 2)


    // MARK: ==== Gray ====
    /// 灰色文字(red: 144, green: 147, blue: 153)
    static let gray0 = ColorWithRGBA(red: 144, green: 147, blue: 153)

    /// 灰色背景 (red: 238, green: 238, blue: 238)
    static let gray1 = ColorWithRGBA(red: 238, green: 238, blue: 238)

    /// 边框线 (red: 212, green: 212, blue: 212)   顶部按钮不可点击文字颜色
    static let gray2 = ColorWithRGBA(red: 212, green: 212, blue: 212)

    /// 灰色箭头 (red: 199, green: 199, blue: 204)
    static let gray3 = ColorWithRGBA(red: 199, green: 199, blue: 204)

    /// 列表背景 (red: 248, green: 248, blue: 248)
    static let gray4: UIColor = ColorWithRGBA(red: 248, green: 248, blue: 248)
    /// 进度文字 (red: 96, green: 98, blue: 102)
    static let gray5 = ColorWithRGBA(red: 96, green: 98, blue: 102)

    // MARK: ==== White ====
    /// 聊天室别人发送的消息气泡颜色
    static let white0: UIColor = UIColor(red:1.00, green:1.00, blue:1.00, alpha:1.00)
    
    static let darkWhite0: UIColor = UIColor.black0
    
        
    /// 根据暗黑是否开启返回对应颜色
    /// - Parameters:
    ///   - normal: 未开启的颜色
    ///   - dark: 开启暗黑的颜色
    static func with(_ normal: UIColor, dark: UIColor) -> UIColor {
        if isDark {
            return dark
        } else {
            return normal
        }
    }
}
