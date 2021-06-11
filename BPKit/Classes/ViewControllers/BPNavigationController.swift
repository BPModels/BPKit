//
//  BPNavigationController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/10.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

class BPNavigationController: UINavigationController, UIGestureRecognizerDelegate {
    
    private let lightStatusBarVCList: [AnyClass] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        self.interactivePopGestureRecognizer?.delegate = self
    }
    
    // MARK: ==== Override ====
    override func pushViewController(_ viewController: UIViewController, animated: Bool) {
        if self.children.count == 1 {
            viewController.hidesBottomBarWhenPushed = true
        }
        self.setNavigationBarHidden(true, animated: false)
        super.pushViewController(viewController, animated: animated)
    }
    
    override func setViewControllers(_ viewControllers: [UIViewController], animated: Bool) {
        super.setViewControllers(viewControllers, animated: animated)
        self.setNavigationBarHidden(true, animated: false)
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        guard let topVC = self.children.last, lightStatusBarVCList.contains(where: { (targetType) -> Bool in
            return topVC.classForCoder == targetType
        }) else {
            return .default
        }
        return .lightContent
    }
}
