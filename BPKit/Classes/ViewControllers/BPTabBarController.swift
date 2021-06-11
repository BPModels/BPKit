//
//  BPCostomTabBarController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// 自定义底部TabBar控制器,实现了TabBar的事件处理协议
class BPTabBarController: UITabBarController, UITabBarControllerDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        BPKitConfig.share.rootNCList.forEach { nc in
            self.addChild(nc)
        }
        UITabBar.appearance().backgroundImage         = UIImage.imageWithColor(UIColor.white0)
        UITabBar.appearance().isTranslucent           = false
        UITabBar.appearance().unselectedItemTintColor = BPKitConfig.share.unselectItemColor
        UITabBar.appearance().tintColor               = BPKitConfig.share.selectedItemColor
    }
}
