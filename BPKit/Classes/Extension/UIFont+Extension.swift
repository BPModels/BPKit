//
//  UIFont+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit.UIFont

/**
 *  IconFont
 */
public extension UIFont {
    class func iconFont(size: CGFloat) -> UIFont? {
        var font = UIFont(name: "iconfont", size: size)
        if font == nil {
            let fontName = "iconfont"
            if let bundle = sourceBundle,
               let fontPath = bundle.path(forResource: fontName, ofType: ".ttf") {
                let url = URL(fileURLWithPath: fontPath)
                let fontData = try? Data(contentsOf: url)
                
                // 通过CGDataProvider承载生成CGFont对象
                let fontCFData: CFData = CFBridgingRetain(fontData) as! CFData
                if let fontDataProvider = CGDataProvider(data: fontCFData), let cgFont: CGFont = CGFont(fontDataProvider) {
                    // 注册字体
                    var fontError: Unmanaged<CFError>?
                    CTFontManagerRegisterGraphicsFont(cgFont, &fontError)
                    // 转成UIFont
                    if let cgFontName: String = cgFont.postScriptName as String? {
                        font = UIFont(name: cgFontName, size: size)
                    }
                }
            }
            
        }
        return font
    }
}

public extension UIFont {

    /// 常用字体
    private struct FontFamilyName {
        static let PingFangTCRegular  = "PingFangSC-Regular"
        static let PingFangTCMedium   = "PingFangSC-Medium"
        static let PingFangTCSemibold = "PingFangSC-Semibold"
        static let PingFangTCLight    = "PingFangSC-Light"
        static let DINAlternateBold   = "DINAlternate-Bold"
    }
    
    class func regularFont(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.PingFangTCRegular, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
    class func mediumFont(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.PingFangTCMedium, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
    class func semiboldFont(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.PingFangTCSemibold, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
    class func lightFont(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.PingFangTCLight, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
    class func DINAlternateBold(ofSize size: CGFloat) -> UIFont {
        if #available(iOS 9.0, *) {
            return UIFont(name: FontFamilyName.DINAlternateBold, size: size)!
        }
        return UIFont.systemFont(ofSize:size)
    }
    
}

