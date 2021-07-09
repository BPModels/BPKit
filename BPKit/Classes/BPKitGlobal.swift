//
//  BPKitGlobal.swift
//  BPKit
//
//  Created by samsha on 2021/6/10.
//

import Foundation
@_exported import BPLog
@_exported import BPCommon
@_exported import BPDeviceInfo

/// 资源路径
public var sourceBundle: Bundle? {
    // 使用【use_frameworks!】
    let mainPath = Bundle.main.bundlePath
    var bundler  = Bundle(path: mainPath + "/Frameworks/BPKit.framework/BPKit.bundle")
    if bundler == nil {
        bundler = Bundle(path: mainPath + "/BPKit.bundle")
    }
    return bundler
}

/// 显示加载动画
public func showLoading() {
    BPLoadingView.share.show(delay: 0.5)
}

/// 隐藏加载动画
public func hideLoading() {
    BPLoadingView.share.hide()
}

// TODO: ==== Function ====

/// 尺寸自适应
/// - Parameter size: 设计尺寸
/// - Returns: 自适应后的尺寸
public func AdaptSize(_ size: CGFloat) -> CGFloat {
    let newSize = kScreenWidth / (isPad ? 768 : 375) * size
    return newSize
}

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


/// 获取资源目录中的图片
func getImage(name: String, type: String) -> UIImage? {
    var image: UIImage?
    if let path = sourceBundle?.path(forResource: name, ofType: type) {
        let url = URL(fileURLWithPath: path)
        if let data = try? Data(contentsOf: url) {
            image = UIImage.sd_image(withGIFData: data)
        }
    }
    return image
}
