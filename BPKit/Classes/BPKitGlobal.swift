//
//  BPKitGlobal.swift
//  BPKit
//
//  Created by samsha on 2021/6/10.
//

import Foundation

/// 尺寸自适应
/// - Parameter size: 设计尺寸
/// - Returns: 自适应后的尺寸
public func AdaptSize(_ size: CGFloat) -> CGFloat {
    let newSize = kScreenWidth / (isPad ? 768 : 375) * size
    return newSize
}

/// 屏幕宽
public var kScreenWidth: CGFloat {
    get {
        return UIScreen.main.bounds.size.width
    }
}

/// 判断当前设备是否是iPad
public var isPad: Bool {
    get {
        return UIDevice.current.userInterfaceIdiom == .pad
    }
}
