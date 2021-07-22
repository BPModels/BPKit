//
//  ViewController.swift
//  BPKit
//
//  Created by TestEngineerFish on 06/10/2021.
//  Copyright (c) 2021 TestEngineerFish. All rights reserved.
//

import UIKit
import BPKit
import ObjectMapper
import BPDeviceInfo
import BPNetwork

class CenterView: BPView {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
        self.updateUI()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
    }
    
    override func bindProperty() {
        super.bindProperty()
    }
    
    override func updateUI() {
        super.updateUI()
        self.backgroundColor = UIColor.with(.white0, dark: .darkWhite0)
    }
    
    // MARK: ==== Event ====
}


class ViewController1: BPViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
        self.updateUI()
    }
    
    override func createSubviews() {
        super.createSubviews()
        let centerView = CenterView()
        self.view.addSubview(centerView)
        centerView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.size.equalTo(CGSize(width: AdaptSize(100), height: AdaptSize(100)))
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title = "你好"
    }
    
    override func bindData() {
        super.bindData()
    }
    
    override func updateUI() {
        super.updateUI()
        self.view.backgroundColor = .with(.darkWhite0, dark: .white0)
    }
    
    // MARK: ==== Event ====
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
//        BPDatePickerView(type: BPDatePickerType.day) { date in
//
//        }.show()
        BPDatePickerView(title: "请选择工人退场日期", subtitle: "员工退场日期将被设定为选择的日期后", type: BPDatePickerType.day) { date in
            
        }.show()
    }
    
}

class ViewController: BPTableViewController<BPModel, BPCommonTableViewCell>, BPTableViewControllerDelegate, BPNetworkDelegate {
    
    var request: BPRequest = BPMessageRequest.messageHome
    var isShowAddButton: Bool = true
    var isShowSearch: Bool = true
    var isShowFilter: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.title = "我是标题"
        self.configBPKit()
        self.configBPNetwork()
        self.customNavigationBar?.hideLeftButton()
    }
    
    override func addAction() {
        request()
    }
    
    /// 配置BPKit
    private func configBPKit() {
        BPKitConfig.share.isEnableShakeChangeEnv = true
        BPKitConfig.share.typeData = BPTypeData()
    }
    
    /// 配置BPNetwork
    private func configBPNetwork() {
        BPNetworkConfig.share.domainApi    = currentApi
        BPNetworkConfig.share.demainWebApi = currentWebApi
        BPNetworkService.default.delegate  = self
    }
    
    public var currentApi: String {
        return BPTypeData.share.api(type: BPTypeData.share.currentType)
    }

    public var currentWebApi: String {
        return BPTypeData.share.webApi(type: BPTypeData.share.currentType)
    }
    
    // MARK: ==== BPNetworkDelegate ====
    /// 处理状态码（如果返回true，则不调用success或fail回调）
    /// - Parameter code: 状态吗
    /// - Returns: 是否已处理
    func handleStatusCode(code: Int) -> Bool {
        return false
    }
    /// 处理错误内容（如果返回true，则不调用success或fail回调）
    /// - Parameter message: 错误内容
    /// - Returns: 是否已处理
    func handleErrorMessage(message: String) -> Bool {
        
        return false
    }
    /// 无网络
    func noNetwork() {
        kWindow.toast("无网络连接，请连接后重试")
    }
    /// 无网络权限
    func noAuthNetwork() {
        kWindow.toast("无网络")
    }
    
}

struct BPModel: Mappable {

    var name: String = "Fish"
    var age: Int = 11

    init() {}
    init?(map: Map) {}

    mutating func mapping(map: Map) {
        name <- map["name"]
        age  <- map["age"]
    }
}

class BPTestCell: BPTableViewCell {
    private var titleLabel: BPLabel = {
        let label = BPLabel()
        label.text          = "我是标题"
        label.textColor     = UIColor.black0
        label.font          = UIFont.DINAlternateBold(ofSize: AdaptSize(20))
        label.textAlignment = .left
        label.setRequiredIcon()
        return label
    }()
    
    override func createSubviews() {
        super.createSubviews()
        self.contentView.addSubview(titleLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.top.equalToSuperview().offset(AdaptSize(15))
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
    }
    
    override func bindData(model: Mappable, indexPath: IndexPath) {
        super.bindData(model: model, indexPath: indexPath)
        guard let _model = model as? BPModel else { return }
        self.titleLabel.text = _model.name
        self.titleLabel.setRequiredIcon()
        print(indexPath)
        if indexPath.row % 2 > 0 {
            self.setLine()
        } else {
            self.setLine(isHide: true, left: AdaptSize(10), right: AdaptSize(-50))
        }
    }
}

enum BPMessageRequest: BPRequest {
    /// 消息首页
    case messageHome
    
    
    var method: BPHTTPMethod {
        switch self {
        case .messageHome:
            return .post
        }
    }
    
    var parameters: [String : Any?]? {
        switch self {
        default:
            return ["id" : 12345455, "projectId" : 84839358, "name": "Sam"]
        }
    }
    
    var path: String {
        switch self {
        case .messageHome:
            return "organization/baseInfo/organization/baseInfo/organization/baseInfo"
        }
    }
    
    var getTypeParameter: String {
        switch self {
        case .messageHome:
            return "test"
        }
    }
}

struct BPTypeData: BPEnvTypeDelegate {
    
    static var share = BPTypeData()
    
    func api(type: BPEnvType) -> String {
        switch type {
        case .dev:
            return "http://192.168.1.155:9080/"
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

