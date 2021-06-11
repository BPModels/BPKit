//
//  BPDeviceInfoGlobal.swift
//  BPDeviceInfo
//
//  Created by samsha on 2021/6/3.
//

import UIKit

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

/// 当前设备是否是模拟器
public var isSimulator: Bool {
    get {
        var isSim = false
        #if arch(i386) || arch(x86_64)
        isSim = true
        #endif
        return isSim
    }
}

/// 是否是iPhoneX之后的设备
public var iPhoneXLater: Bool {
    get {
        let iPhoneXLaterModelList: [DeviceModelType] = [.iPhoneX,
                                                        .iPhoneXr,
                                                        .iPhoneXs,
                                                        .iPhoneXsMax,
                                                        .iPhone11,
                                                        .iPhone11Pro,
                                                        .iPhone11ProMax,
                                                        .iPhone12Mini,
                                                        .iPhone12,
                                                        .iPhone12Pro,
                                                        .iPhone12ProMax,
                                                        .simulator]
        return iPhoneXLaterModelList.contains(BPDeviceInfo.share.model())
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


/// 获取屏幕截图
public func getScreenshotImage() -> UIImage? {
    guard let layer = UIApplication.shared.keyWindow?.layer else {
        return nil
    }
    let renderer = UIGraphicsImageRenderer(size: layer.frame.size)
    let image = renderer.image { (context: UIGraphicsImageRendererContext) in
        layer.render(in: context.cgContext)
    }
    return image
}


// MARK: ---尺寸相关---
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

/// 屏幕比例,返回
/// 1: 代表320 x 480 的分辨率(就是iphone4之前的设备，非Retain屏幕);
/// 2: 代表640 x 960 的分辨率(Retain屏幕);
/// 3: 代表1242 x 2208 的分辨率;
public var kScreenScale: CGFloat {
    get {
        return UIScreen.main.scale
    }
}
/// 状态栏高度
public var kStatusBarHeight:CGFloat {
    get {
        return UIApplication.shared.statusBarFrame.height
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
        return iPhoneXLater ? 34.0 : 0.0
    }
}
