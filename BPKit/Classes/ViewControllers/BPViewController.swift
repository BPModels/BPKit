//
//  BPViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/8.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import SnapKit

class BPViewController: UIViewController, BPNavigationBarDelegate {

    deinit {
        #if DEBUG
        print(self.classForCoder, "资源释放")
        #endif
    }
    
    // TODO: ==== 分页 ====
    var page: Int {
        var _page = 1
        self.view.subviews.forEach { (contentView) in
            contentView.subviews.forEach { (subview) in
                guard let tableView = subview as? UITableView else {
                    return
                }
                _page = tableView.page
            }
        }
        return _page
    }
    var pageSize: Int = 20

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        print("==== \(self.classForCoder) 内存告警 ====")
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.white0
        self.useCustomNavigationBar()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
        self.setFullScreenPopGesture()
    }
    
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        self.navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    internal func createSubviews() {}

    internal func bindProperty() {}

    internal func bindData() {}

    internal func registerNotification() {}

    private func setFullScreenPopGesture() {
    }
    
//    // TODO: ==== 摇一摇切换环境 ====
//    override func motionEnded(_ motion: UIEvent.EventSubtype, with event: UIEvent?) {
//        super.motionEnded(motion, with: event)
//        #if DEBUG
//        if event?.subtype == .some(.motionShake) && !(UIViewController.currentViewController?.isKind(of: BPEnvChangeViewController.classForCoder()) ?? false) {
//            let vc = BPEnvChangeViewController()
//            UIViewController.currentViewController?.present(vc, animated: true, completion: nil)
//            BPLog("用户目录：\(NSHomeDirectory())")
//        }
//        #endif
//    }
    
    // TODO: ==== CustomNavigationBar ====
    private struct AssociatedKeys {
        static var customeNavigationBar: String = "kCustomeNavigationBar"
    }
    
    func useCustomNavigationBar() {
        let navBar = self.createCustomNavigationBar()
        self.view.addSubview(navBar)
        navBar.snp.makeConstraints { (make) in
            make.left.right.top.equalToSuperview()
            make.height.equalTo(kNavHeight)
        }
        self.customNavigationBar?.delegate = self
    }
    
    var customNavigationBar: BPNavigationBar? {
        return objc_getAssociatedObject(self, &AssociatedKeys.customeNavigationBar) as? BPNavigationBar
    }
    
    // MARK: ++++++++++ Private ++++++++++
    private func createCustomNavigationBar() -> BPNavigationBar {
        let cnb = BPNavigationBar()
        objc_setAssociatedObject(self, &AssociatedKeys.customeNavigationBar, cnb, objc_AssociationPolicy.OBJC_ASSOCIATION_RETAIN_NONATOMIC)
        return cnb
    }
    
    // MARK: ==== BPNavigationBarDelegate ====
    func leftAction() {
        kWindow.hideLoading()
        self.navigationController?.pop()
    }
    func rightAction() {}
}
