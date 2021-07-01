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

class ViewController: BPTableViewController<BPModel, BPTestCell>, BPTableViewControllerDelegate {
    
    var request: BPRequest = BPMessageRequest.messageHome
    var isShowAddButton: Bool = true
    var isShowSearch: Bool = true
    var isShowFilter: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.delegate = self
        self.title = "我是标题"
        self.customNavigationBar?.hideLeftButton()
        BPPickerModel()
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
    
    override func bindData(model: Mappable) {
        super.bindData(model: model)
        guard let _model = model as? BPModel else { return }
        self.titleLabel.text = _model.name
    }
}

enum BPMessageRequest: BPRequest {
    /// 消息首页
    case messageHome
    
    
    var method: BPHTTPMethod {
        switch self {
        case .messageHome:
            return .get
        }
    }
    
    var parameters: [String : Any?]? {
        switch self {
        default:
            return nil
        }
    }
    
    var path: String {
        switch self {
        case .messageHome:
            return "http://www.baidu.com/test"
        
        }
    }
    
    var getTypeParameter: String {
        switch self {
        case .messageHome:
            return "test"
        default:
            return ""
        }
    }
}
