//
//  BPCommonGlobal.swift
//  BPCommon
//
//  Created by samsha on 2021/6/11.
//

import Foundation

// TODO: ==== Block ====

/// 默认闭包
public typealias DefaultBlock      = (()->Void)
public typealias DefaultImageBlock = ((UIImage?)->Void)
public typealias StringBlock       = ((String)->Void)
public typealias IntBlock          = ((Int)->Void)
public typealias BoolBlock         = ((Bool)->Void)
public typealias DoubleBlock       = ((Double?)->Void)
public typealias MediaListBlock    = (([BPMediaModel])->Void)


// TODO: ==== Function ====
/// 震动
public func shake() {
    let gen = UIImpactFeedbackGenerator(style: .light)
    gen.prepare()
    gen.impactOccurred()
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

/// 跳转到APP内设置界面
public func jumpToAppSetting() {
    let appSetting = URL(string: UIApplication.openSettingsURLString)

    if appSetting != nil {
        UIApplication.shared.open(appSetting!, options: [:], completionHandler: nil)
    }
}
