//
//  BPKitGlobal.swift
//  BPKit
//
//  Created by samsha on 2021/6/10.
//

import Foundation

/// 默认闭包
typealias DefaultBlock      = (()->Void)
typealias DefaultImageBlock = ((UIImage?)->Void)
typealias StringBlock       = ((String)->Void)
typealias IntBlock          = ((Int)->Void)
typealias BoolBlock         = ((Bool)->Void)
//typealias MediaListBlock    = (([BPMediaModel])->Void)
typealias DoubleBlock       = ((Double?)->Void)

/// 尺寸自适应
/// - Parameter size: 设计尺寸
/// - Returns: 自适应后的尺寸
public func AdaptSize(_ size: CGFloat) -> CGFloat {
    let newSize = kScreenWidth / (isPad ? 768 : 375) * size
    return newSize
}

/// 屏幕比例,返回
/// 1: 代表320 x 480 的分辨率(就是iphone4之前的设备，非Retain屏幕);
/// 2: 代表640 x 960 的分辨率(Retain屏幕);
/// 3: 代表1242 x 2208 的分辨率;
public var kScreenScale: CGFloat {
    get {
        return UIScreen.main.scale
    }
}

/// 屏幕宽
public var kScreenWidth: CGFloat {
    get {
        return UIScreen.main.bounds.size.width
    }
}

/// 屏幕高
public var kScreenHeight: CGFloat {
    get {
        return UIScreen.main.bounds.size.height
    }
}

/// Navigation Bar 高度
public var kNavHeight:CGFloat {
    get {
        return kStatusBarHeight + 44.0
    }
}

//// TabBar 高度
public var kTabBarHeight:CGFloat {
    get {
        return kStatusBarHeight == 44 ? 83 : 49
    }
}

/// 全面屏的底部安全高度
public var kSafeBottomMargin:CGFloat {
    get {
        return true ? 34.0 : 0.0
    }
}

/// 状态栏高度
public var kStatusBarHeight:CGFloat {
    get {
        return UIApplication.shared.statusBarFrame.height
    }
}

/// 当前Window
public var kWindow: UIWindow {
    get {
        guard let window = UIApplication.shared.keyWindow else {
            return UIWindow(frame: CGRect.zero)
        }
        return window
    }
}

/// 判断当前设备是否是iPad
public var isPad: Bool {
    get {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}

/// 是否是黑暗模式
public var isDark: Bool {
    get {
        if #available(iOS 13.0, *) {
            return UITraitCollection.current.userInterfaceStyle == UIUserInterfaceStyle.dark
        } else {
            return false
        }
    }
}

//MARK: ==== Function ====

/// 计算文本尺寸
/// 根据文字计算大小
public func sizeForText(mAttrStr: NSAttributedString, width: CGFloat) -> CGSize {
    // 创建CTFramesetter实例
    let frameSetter  = CTFramesetterCreateWithAttributedString(mAttrStr)
    // 获得需要绘制的大小
    let restrictSize = CGSize(width: width, height: CGFloat.greatestFiniteMagnitude)
    let coreTextSize = CTFramesetterSuggestFrameSizeWithConstraints(frameSetter, CFRange(location: 0, length: 0), nil, restrictSize, nil)
    return coreTextSize
}

/// 震动
func feedbackGenerator() {
    let gen = UIImpactFeedbackGenerator(style: .light)
    gen.prepare()
    gen.impactOccurred()
}
