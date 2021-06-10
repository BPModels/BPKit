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
        self.addChildViewController()
        UITabBar.appearance().backgroundImage         = UIImage.imageWithColor(UIColor.white0)
        UITabBar.appearance().isTranslucent           = false
        UITabBar.appearance().unselectedItemTintColor = UIColor.gray5
        UITabBar.appearance().tintColor               = UIColor.blue0
    }
    
    /// 设置底部TabBarItem
    func addChildViewController() {
        let messageVC = BPMessageHomeViewController()
        messageVC.view.backgroundColor = .white0
        let messageNC = BPNavigationController()
        messageNC.addChild(messageVC)
        messageNC.tabBarItem.title         = "消息"
        messageNC.tabBarItem.image         = UIImage(named: "message_unselect")?.withRenderingMode(.alwaysOriginal)
        messageNC.tabBarItem.selectedImage = UIImage(named: "message_selected")?.withRenderingMode(.alwaysOriginal)
        messageNC.tabBarItem.imageInsets   = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.addChild(messageNC)
        
        let taskVC = BPTaskHomeViewController()
        taskVC.view.backgroundColor = .white0
        let taskNC = BPNavigationController()
        taskNC.addChild(taskVC)
        taskNC.tabBarItem.title         = "任务"
        taskNC.tabBarItem.image         = UIImage(named: "task_unselect")?.withRenderingMode(.alwaysOriginal)
        taskNC.tabBarItem.selectedImage = UIImage(named: "task_selected")?.withRenderingMode(.alwaysOriginal)
        taskNC.tabBarItem.imageInsets   = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.addChild(taskNC)
        
        let studioVC = BPStudioHomeViewController()
        studioVC.view.backgroundColor = .white0
        let studioNC = BPNavigationController()
        studioNC.addChild(studioVC)
        studioNC.tabBarItem.title         = "工作台"
        studioNC.tabBarItem.image         = UIImage(named: "studio_unselect")?.withRenderingMode(.alwaysOriginal)
        studioNC.tabBarItem.selectedImage = UIImage(named: "studio_selected")?.withRenderingMode(.alwaysOriginal)
        studioNC.tabBarItem.imageInsets   = UIEdgeInsets(top: 8, left: 8, bottom: 8, right: 8)
        self.addChild(studioNC)
        
        let organizationVC = BPOrganizationViewController()
        organizationVC.view.backgroundColor = .gray4
        let organizationNC = BPNavigationController()
        organizationNC.addChild(organizationVC)
        organizationNC.tabBarItem.title         = "通讯录"
        organizationNC.tabBarItem.image         = UIImage(named: "organization_unselect")?.withRenderingMode(.alwaysOriginal)
        organizationNC.tabBarItem.selectedImage = UIImage(named: "organization_selected")?.withRenderingMode(.alwaysOriginal)
        organizationNC.tabBarItem.imageInsets   = UIEdgeInsets(top: 7, left: 7, bottom: 7, right: 7)
        self.addChild(organizationNC)
        
        let exploreVC = UIViewController()
        exploreVC.view.backgroundColor = .white0
        let exploreNC = BPNavigationController()
        exploreNC.addChild(exploreVC)
        exploreNC.tabBarItem.title         = "发现"
        exploreNC.tabBarItem.image         = UIImage(named: "explore_unselect")?.withRenderingMode(.alwaysOriginal)
        exploreNC.tabBarItem.selectedImage = UIImage(named: "explore_selected")?.withRenderingMode(.alwaysOriginal)
        exploreNC.tabBarItem.imageInsets   = UIEdgeInsets(top: 6, left: 6, bottom: 6, right: 6)
        self.addChild(exploreNC)
    }
}
