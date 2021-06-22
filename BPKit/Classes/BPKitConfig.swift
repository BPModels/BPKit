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
    
    // TODO: ---- BPEnvChangeViewController
    /// 是否开启摇动切换网络页面
    public var isEnableShakeChangeEnv = false
    
    /// 切换环境页面协议对象
    public weak var changeEnvDelegate: BPEnvChangeViewControllerDelegate?
    
    /// 切换网络数据对象
    public var typeData: BPEnvTypeDelegate?
    
    
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
