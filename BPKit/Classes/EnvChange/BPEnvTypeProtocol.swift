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
///// 默认实现
//extension BPEnvTypeDelegate {
//    func api(type: BPEnvType) -> String {
//        switch type {
//        case .dev:
//            return "http://192.168.1.155:9080/"
//        case .test:
//            return "http://121.36.55.155:8081/api/"
//        case .pre:
//            return "http://121.36.23.209/api/"
//        case .release:
//            return "http://121.36.23.209/api/"
//        case .debug:
//            return customApi ?? ""
//        }
//    }
//    
//    func webApi(type: BPEnvType) -> String {
//        switch type {
//        case .dev:
//            return "http://192.168.1.155:8081/"
//        case .test:
//            return "http://121.36.55.155:8081/"
//        case .pre:
//            return "http://121.36.23.209/"
//        case .release:
//            return "http://121.36.23.209/"
//        case .debug:
//            return customWebApi ?? ""
//        }
//    }
//    
//    func title(type: BPEnvType) -> String {
//        switch type {
//        case .dev:
//            return "开发环境"
//        case .test:
//            return "测试环境"
//        case .pre:
//            return "预发环境"
//        case .release:
//            return "正式环境"
//        case .debug:
//            return "自定义"
//        }
//    }
//    
//    var typeList: [BPEnvType] {
//        get {
//            return [.dev, .test, .pre, .release, .debug]
//        }
//    }
//    
//    var currentType: BPEnvType {
//        get {
//            return .dev
//        }
//    }
//    
//    /// 自定义Api
//    var customApi: String? {
//        get {
//            return UserDefaults.standard.object(forKey: "kCustomServerDomain") as? String
//        }
//        set {
//            UserDefaults.standard.setValue(newValue, forKey: "kCustomServerDomain")
//        }
//    }
//    /// 自定义Web Api
//    var customWebApi: String? {
//        get {
//            return UserDefaults.standard.object(forKey: "kCustomWebDomain") as? String
//        }
//        set {
//            UserDefaults.standard.setValue(newValue, forKey: "kCustomWebDomain")
//        }
//    }
//}

public enum BPEnvType: Int {
    case dev     = 0
    case test    = 1
    case pre     = 2
    case release = 3
    case debug   = 4
}
