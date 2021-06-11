//
//  BPAlertManager.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import Kingfisher

class BPAlertManager {
    
    static var share       = BPAlertManager()
    private var alertArray = [BPBaseAlertView]()
    private var isShowing  = false
    
    private func show() {
        guard !self.isShowing else {
            return
        }
        self.isShowing = true
        // 排序
        self.alertArray.sort(by: { $0.priority.rawValue < $1.priority.rawValue })
        guard let alertView = self.alertArray.first else {
            return
        }
        // 关闭弹框后的闭包
        alertView.closeActionBlock = { [weak self] in
            guard let self = self else { return }
            self.isShowing = false
            self.removeAlert()
        }
        alertView.show()
    }

    /// 添加一个alertView
    /// - Parameter alertView: alert对象
    private func addAlert(alertView: BPBaseAlertView) {
        self.alertArray.append(alertView)
    }

    /// 移除当前已显示的Alert
    private func removeAlert() {
        guard !self.alertArray.isEmpty else {
            return
        }
        self.alertArray.removeFirst()
        // 如果队列中还有未显示的Alert，则继续显示
        guard !self.alertArray.isEmpty else {
            return
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.3) { [weak self] in
            self?.show()
        }
    }
    
    // MARK: ==== Alert view ====

    /// 版本更新弹框
    func showUpdate(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?, priority: BPAlertPriorityEnum = .normal) {
        let alertView = BPAlertViewUpdate(title: title, description: description, leftBtnName: leftBtnName, leftBtnClosure: leftBtnClosure, rightBtnName: rightBtnName, rightBtnClosure: rightBtnClosure)
        alertView.priority = priority
        self.addAlert(alertView: alertView)
        self.show()
    }

    /// 显示纯图片
    func showOnlyImage(imageStr: String, hideCloseBtn: Bool = false, touchBlock: ((String?) -> Void)? = nil, priority: BPAlertPriorityEnum = .normal) {
        let alertView = BPAlertViewImage(imageStr: imageStr, hideCloseBtn: hideCloseBtn, touchBlock: touchBlock)
        alertView.priority = priority
        self.addAlert(alertView: alertView)
        self.show()
    }
    
    /// 显示底部一个按钮的弹框， 默认内容居中
    @discardableResult
    func oneButton(title: String?, description: String, buttonName: String, closure: (() -> Void)?) -> BPBaseAlertView {
        let alertView = BPAlertViewOneButton(title: title, description: description, buttonName: buttonName, closure: closure)
        self.addAlert(alertView: alertView)
        return alertView
    }
    
    /// 显示底部一个按钮的弹框（内容为BPAttributionView）默认左对齐
    func oneButtonAttr(title: String?, description: String, buttonName: String, closure: (() -> Void)?) -> BPBaseAlertView {
        let alertView = BPAlertAttributedViewOneButton(title: title, description: description, buttonName: buttonName, closure: closure)
        self.addAlert(alertView: alertView)
        return alertView
    }
    
    /// 显示底部两个按钮的弹框
    func twoButton(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?, isDestruct: Bool = false) -> BPBaseAlertView {
        let alertView = BPAlertViewTwoButton(title: title, description: description, leftBtnName: leftBtnName, leftBtnClosure: leftBtnClosure, rightBtnName: rightBtnName, rightBtnClosure: rightBtnClosure, isDestruct: isDestruct)
        self.addAlert(alertView: alertView)
        return alertView
    }
    
    /// 显示底部两个按钮的弹框
    func twoButtonAttr(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?, isDestruct: Bool = false) -> BPBaseAlertView {
        let alertView = BPAlertAttributedViewTwoButton(title: title, description: description, leftBtnName: leftBtnName, leftBtnClosure: leftBtnClosure, rightBtnName: rightBtnName, rightBtnClosure: rightBtnClosure, isDestruct: isDestruct)
        self.addAlert(alertView: alertView)
        return alertView
    }
    
//    /// 显示工人基本信息维护添加联系方式的弹框
//    func workerContactTwoButton(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: ((String) -> Void)?, isDestruct: Bool = false) -> BPBaseAlertView {
//        let alertView = BPAlertViewWorkerBasicInfoPhoneContactView(title: title, description: description, leftBtnName: leftBtnName, leftBtnClosure: leftBtnClosure, rightBtnName: rightBtnName, rightBtnClosure: rightBtnClosure, isDestruct: isDestruct)
//        self.addAlert(alertView: alertView)
//        return alertView
//    }
//    /// 显示工人基本信息维护添加紧急联系方式的弹框
//    func workerEmergencyContactTwoButton(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: ((BPWorkerContactModel) -> Void)?, isDestruct: Bool = false) -> BPBaseAlertView {
//        let alertView = BPAlertViewWorkerBasicInfoPhoneEmergencyView(title: title, description: description, leftBtnName: leftBtnName, leftBtnClosure: leftBtnClosure, rightBtnName: rightBtnName, rightBtnClosure: rightBtnClosure, isDestruct: isDestruct)
//        self.addAlert(alertView: alertView)
//        return alertView
//    }
    // 显示更换自定义域名弹框
    func twoTextField(title: String?, firstPlaceholder: String, secondPlaceholder: String, rightBtnClosure: ((String?, String?) -> Void)?) -> BPBaseAlertView {
        let alertView = BPAlertViewTwoEditView(title: title, firstPlaceholder: firstPlaceholder, secondPlaceholder: secondPlaceholder, rightBtnClosure: rightBtnClosure)
        self.addAlert(alertView: alertView)
        return alertView
    }
}
