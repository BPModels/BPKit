//
//  ViewController.swift
//  BPKit
//
//  Created by TestEngineerFish on 06/10/2021.
//  Copyright (c) 2021 TestEngineerFish. All rights reserved.
//

import UIKit
@_exported import BPKit

class ViewController: BPViewController, UITableViewDelegate, UITableViewDataSource, BPEnvChangeViewControllerDelegate {
    
    private var tableView: UITableView = {
        let tableView = UITableView()
        tableView.estimatedRowHeight = AdaptSize(56)
        tableView.backgroundColor    = UIColor.gray4
        tableView.separatorStyle     = .none
        tableView.refreshHeaderEnable = true
        tableView.refreshFooterEnable = true
        tableView.showsVerticalScrollIndicator   = false
        tableView.showsHorizontalScrollIndicator = false
        return tableView
    }()
    private var subtitle: BPLabel = {
        let label = BPLabel()
        label.text          = IconFont.back.rawValue
        label.textColor     = UIColor.red
        label.font          = UIFont.iconFont(size: AdaptSize(33))
        label.textAlignment = .center
        return label
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        self.customNavigationBar?.title = "HOME"
        self.createSubviews()
        self.bindProperty()
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(subtitle)
        self.view.addSubview(tableView)
        subtitle.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
            make.height.equalTo(AdaptSize(50))
        }
        tableView.snp.makeConstraints { make in
            make.left.right.bottom.equalToSuperview()
            make.top.equalTo(subtitle.snp.bottom)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        tableView.delegate = self
        tableView.dataSource = self
        BPKitConfig.share.isEnableShakeChangeEnv = true
        BPKitConfig.share.changeEnvDelegate = self
        BPKitConfig.share.typeData = BPTypeData()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: ==== UITableViewDelegate, UITableViewDataSource ====
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        cell.backgroundColor = .randomColor()
        cell.textLabel?.text = "\(indexPath.row)"
        return cell
    }
    
    // MARK: ==== BPEnvChangeViewControllerDelegate ====
    /// 页面显示
    func show() {
        print("Show")
    }
    /// 确认切换环境
    func changeEnv() {
        print("Change")
    }
    /// 页面隐藏
    func hide() {
        print("hide")
    }
}

class BPTypeData: BPEnvTypeDelegate {
    
    func api(type: BPEnvType) -> String {
        switch type {
        case .dev:
            return "22http://192.168.1.155:9080/"
        case .test:
            return "http://121.36.55.155:8081/api/"
        case .pre:
            return "http://121.36.23.209/api/"
        case .release:
            return "http://121.36.23.209/api/"
        case .debug:
            return customApi ?? ""
        }
    }

    func webApi(type: BPEnvType) -> String {
        switch type {
        case .dev:
            return "http://192.168.1.155:8081/"
        case .test:
            return "http://121.36.55.155:8081/"
        case .pre:
            return "http://121.36.23.209/"
        case .release:
            return "http://121.36.23.209/"
        case .debug:
            return customWebApi ?? ""
        }
    }

    func title(type: BPEnvType) -> String {
        switch type {
        case .dev:
            return "开发环境"
        case .test:
            return "测试环境"
        case .pre:
            return "预发环境"
        case .release:
            return "正式环境"
        case .debug:
            return "自定义"
        }
    }

    var typeList: [BPEnvType] {
        get {
            return [.dev, .test, .pre, .release, .debug]
        }
    }

    var currentType: BPEnvType {
        get {
            let typeInt = UserDefaults.standard.object(forKey: "kCurrentType") as? Int ?? 0
            return  BPEnvType(rawValue: typeInt) ?? .dev
        }

        set {
            UserDefaults.standard.setValue(newValue.rawValue, forKey: "kCurrentType")
        }
    }
    
    /// 自定义Api
    var customApi: String? {
        get {
            return UserDefaults.standard.object(forKey: "kCustomServerDomain") as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "kCustomServerDomain")
        }
    }
    /// 自定义Web Api
    var customWebApi: String? {
        get {
            return UserDefaults.standard.object(forKey: "kCustomWebDomain") as? String
        }
        set {
            UserDefaults.standard.setValue(newValue, forKey: "kCustomWebDomain")
        }
    }
}
