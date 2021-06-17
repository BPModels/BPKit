//
//  BPKitConfig.swift
//  BPKit
//
//  Created by samsha on 2021/6/11.
//

import Foundation

/// 统一配置类
public class BPKitConfig {
    public static let share = BPKitConfig()

    // TODD: ==== BPTabBarController ====
    
    /// 根视图控制器列表
    var rootNCList: [UINavigationController] = []
    
    /// 添加根视图控制器列表
    public func addRootNavigationControllers(nvcList: [UINavigationController]) {
        self.rootNCList = nvcList
    }
    
    /// 未选中时底部Item的文字颜色
    public var unselectItemColor: UIColor?
    
    /// 选中后底部Item的文字颜色
    public var selectedItemColor: UIColor?
}
