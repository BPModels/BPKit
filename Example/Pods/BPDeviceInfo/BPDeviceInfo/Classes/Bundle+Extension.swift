//
//  Bundle+Extension.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/7/15.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

public extension Bundle {
    fileprivate static let _mainBundle: Bundle = Bundle.main
    
    /// 获取应用标识号
    static let bundleIdentifier: String = {
        return _mainBundle.infoDictionary?["CFBundleIdentifier"] as? String ?? ""
    }()
    
    /// 获取App Nmae 项目名称
    static let bundleName: String = {
        return _mainBundle.infoDictionary?["CFBundleName"] as? String ?? ""
    }()
    
    /// 项目显示名称
    static let projectName: String = {
        return _mainBundle.infoDictionary?["CFBundleDisplayName"] as? String ?? ""
    }()

    
    /// 获取App Bundle 版本号
    static let appVersion: String = {
        return _mainBundle.infoDictionary?["CFBundleShortVersionString"] as? String ?? ""
    }()
    
    /// 获取App Bundle 构建编号
    static let appBuild: String = {
        return _mainBundle.infoDictionary?["CFBundleVersion"] as? String ?? ""
    }()
    
    /// Universal links
    static let universalLink: String = {
        return "https://app.junming100.com"
    }()
    
    /// 提供供外界调用查询的入口
    class func objectForInfoDictionary(forKey key: String) -> Any? {
        return _mainBundle.object(forInfoDictionaryKey: key)
    }
}
