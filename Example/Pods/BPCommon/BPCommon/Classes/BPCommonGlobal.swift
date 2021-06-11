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


// TODO: ==== Function ====
/// 震动
public func shake() {
    let gen = UIImpactFeedbackGenerator(style: .light)
    gen.prepare()
    gen.impactOccurred()
}
