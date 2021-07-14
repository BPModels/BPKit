//
//  BPEnvChangeViewController.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/22.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import Foundation

class BPEnvChangeViewController: BPViewController , UITableViewDelegate, UITableViewDataSource {
    
    private let cellID = "BPEnvChangeCellID"
    private var typeModel: BPEnvTypeDelegate
    
    init(type: BPEnvTypeDelegate) {
        self.typeModel = type
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var tableView: BPTableView = {
        let tableView = BPTableView()
        tableView.estimatedRowHeight = AdaptSize(55)
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    
    private var changeButton: BPButton = {
        let button = BPButton(.second)
        button.setTitle("确认切换", for: .normal)
        button.setTitleColor(.white0)
        button.setStatus(.disable)
        return button
    }()
    
    private var backButton: BPButton = {
        let button = BPButton()
        button.setTitle("返回", for: .normal)
        button.setTitleColor(UIColor.gray0)
        button.layer.cornerRadius = AdaptSize(5)
        button.layer.borderWidth  = AdaptSize(1)
        button.layer.borderColor  = UIColor.gray0.cgColor
        return button
    }()
    
    private var logLabel: BPLabel = {
        let label = BPLabel()
        label.text          = "日志："
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .center
        return label
    }()
    private var logSwitchBar: UISwitch = UISwitch()
    
    private var borderLabel: BPLabel = {
        let label = BPLabel()
        label.text          = "描边："
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(13))
        label.textAlignment = .center
        return label
    }()
    private var borderSwitchBar: UISwitch = UISwitch()
    
    /// 临时选中的类型
    private var tempEnv: BPEnvType?
    /// 临时填写的服务端域名
    private var tempServerDomain: String?
    /// 临时填写的Web端域名
    private var tempWebDomain: String?
    
    deinit {
        BPKitConfig.share.changeEnvDelegate?.hide()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.title = "选择环境"
        self.customNavigationBar?.hideLeftButton()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
        // 显示事件回调
        BPKitConfig.share.changeEnvDelegate?.show()
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(tableView)
        self.view.addSubview(changeButton)
        self.view.addSubview(backButton)
        self.view.addSubview(logLabel)
        self.view.addSubview(logSwitchBar)
        self.view.addSubview(borderLabel)
        self.view.addSubview(borderSwitchBar)
        
        tableView.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(AdaptSize(100))
            make.left.right.equalToSuperview()
            make.bottom.equalTo(changeButton.snp.top).offset(AdaptSize(20))
        }
        changeButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.bottom.equalToSuperview().offset(AdaptSize(-50) - kSafeBottomMargin)
            make.size.equalTo(CGSize(width: kScreenWidth / 3, height: AdaptSize(50)))
        }
        backButton.snp.makeConstraints { (make) in
            make.bottom.size.equalTo(changeButton)
            make.left.equalToSuperview().offset(AdaptSize(15))
        }
        logLabel.sizeToFit()
        logLabel.snp.makeConstraints { make in
            make.left.equalTo(backButton)
            make.bottom.equalTo(backButton.snp.top).offset(AdaptSize(-15))
            make.size.equalTo(logLabel.size)
        }
        logSwitchBar.snp.makeConstraints { make in
            make.left.equalTo(logLabel.snp.right)
            make.centerY.equalTo(logLabel)
        }
        borderLabel.sizeToFit()
        borderLabel.snp.makeConstraints { (make) in
            make.left.equalTo(changeButton)
            make.bottom.equalTo(changeButton.snp.top).offset(AdaptSize(-15))
            make.size.equalTo(borderLabel.size)
        }
        borderSwitchBar.snp.makeConstraints { (make) in
            make.left.equalTo(borderLabel.snp.right)
            make.centerY.equalTo(borderLabel)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.tableView.delegate   = self
        self.tableView.dataSource = self
        self.tableView.register(BPEnvChangeCell.classForCoder(), forCellReuseIdentifier: cellID)
        self.backButton.addTarget(self, action: #selector(backAction), for: .touchUpInside)
        self.changeButton.addTarget(self, action: #selector(changeAction), for: .touchUpInside)
        self.logSwitchBar.addTarget(self, action: #selector(switchLogAction(bar:)), for: .valueChanged)
        self.borderSwitchBar.addTarget(self, action: #selector(switchBorderAction(bar:)), for: .valueChanged)
    }
    
    override func bindData() {
        super.bindData()
        self.borderSwitchBar.isOn = UserDefaults.standard.bool(forKey: "bp_borderDebug")
        self.logSwitchBar.isOn    = UserDefaults.standard.bool(forKey: "bp_logDebug")
    }
    
    // MARK: ==== Event ====
    /// 返回
    /// - Parameter isChange: 是否切换环境
    @objc
    private func backAction(isChange: Bool = false) {
        self.dismiss(animated: true) {
            if isChange {
                BPKitConfig.share.changeEnvDelegate?.changeEnv()
            }
        }
    }
    
    @objc
    private func changeAction() {
        BPAlertManager.share.twoButton(title: "提示", description: "切换环境需要退出重新登录,\n确认切换吗？", leftBtnName: "取消", leftBtnClosure: nil, rightBtnName: "确定") { [weak self] in
            guard let self = self, let newEnv = self.tempEnv else { return }
            // 临时选择转换成正式选择
            self.typeModel.customApi    = self.tempServerDomain
            self.typeModel.customWebApi = self.tempWebDomain
            if self.typeModel.currentType != newEnv {
                self.typeModel.currentType  = newEnv
            }
            self.backAction(isChange: true)
        }.show()
    }
    
    @objc
    private func switchLogAction(bar: UISwitch) {
        if bar.isOn {
            UserDefaults.standard.set(true, forKey: "bp_logDebug")
            BPEnvLogView.show()
        } else {
            UserDefaults.standard.set(false, forKey: "bp_logDebug")
            BPEnvLogView.hide()
        }
    }
    
    @objc
    private func switchBorderAction(bar: UISwitch) {
        if bar.isOn {
            BPAlertManager.share.twoButton(title: "提示", description: "开启描边调试模式需要退出重新登录，确认退出吗？", leftBtnName: "取消", leftBtnClosure: {
                bar.isOn = !bar.isOn
            }, rightBtnName: "确定") {
                UserDefaults.standard.set(true, forKey: "bp_borderDebug")
                self.backAction(isChange: self.changeButton.status == .normal)
            }.show()
        } else {
            BPAlertManager.share.twoButton(title: "提示", description: "关闭描边调试模式需要退出重新登录，确认退出吗？", leftBtnName: "取消", leftBtnClosure: {
                bar.isOn = !bar.isOn
            }, rightBtnName: "确定") {
                UserDefaults.standard.set(false, forKey: "bp_borderDebug")
                self.backAction(isChange: self.changeButton.status == .normal)
            }.show()
        }
    }
    
    // MARK: ==== UITableViewDataSource && UITableViewDelegate ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return typeModel.typeList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: cellID) as? BPEnvChangeCell else {
            return UITableViewCell()
        }
        cell.setData(typeModel: typeModel, indexPath: indexPath, tempSelectType: self.tempEnv, tempApi: tempServerDomain, tempWebApi: tempWebDomain)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let newEnv = BPEnvType(rawValue: indexPath.row) else {
            return
        }
        if newEnv == .debug {
            BPAlertManager.share.twoTextField(title: "设置自定义域名", firstPlaceholder: "请输入Server Domain", secondPlaceholder: "请输入Web Domain") { serverDomain, webDomain in
                // 临时选择，未确认切换
                self.tempEnv          = newEnv
                self.tempServerDomain = serverDomain
                self.tempWebDomain    = webDomain
                self.changeButton.setStatus(.normal)
                tableView.reloadData()
            }.show()
        } else {
            // 临时选择，未确认切换
            self.tempEnv = newEnv
            if typeModel.currentType == newEnv {
                self.changeButton.setStatus(.disable)
            } else {
                self.changeButton.setStatus(.normal)
            }
            tableView.reloadData()
        }
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        return UIView()
    }
}
