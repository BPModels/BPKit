//
//  BPEnvTypeProtocol.swift
//  BPKit
//
//  Created by samsha on 2021/6/22.
//

import Foundation

public protocol BPEnvChangeViewControllerDelegate: NSObjectProtocol {
    /// 页面显示
    func show()
    /// 确认切换环境
    func changeEnv()
    /// 页面隐藏
    func hide()
}

public protocol BPEnvTypeDelegate {
    func api(type: BPEnvType) -> String
    func webApi(type: BPEnvType) -> String
    func title(type: BPEnvType) -> String
    var typeList: [BPEnvType] { get }
    var currentType: BPEnvType { get set }
    /// 自定义Api
    var customApi: String? { get set}
    /// 自定义Web Api
    var customWebApi: String? { get set}
}

public enum BPEnvType: Int {
    case dev     = 0
    case test    = 1
    case pre     = 2
    case release = 3
    case debug   = 4
}
