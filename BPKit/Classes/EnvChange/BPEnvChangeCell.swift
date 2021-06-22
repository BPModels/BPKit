//
//  BPEnvChangeCell.swift
//  Tenant
//
//  Created by samsha on 2021/5/31.
//

import UIKit

class BPEnvChangeCell: UITableViewCell {
    
    private var titleLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(18))
        label.textAlignment = .left
        return label
    }()
    private var serverApiLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.gray0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textAlignment = .left
        return label
    }()
    private var webApiLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.gray0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(14))
        label.textAlignment = .left
        return label
    }()
    private var currentTipLabel: BPLabel = {
        let label = BPLabel()
        label.text                = "当前"
        label.textColor           = UIColor.blue0
        label.font                = UIFont.regularFont(ofSize: AdaptSize(11))
        label.textAlignment       = .center
        label.backgroundColor     = UIColor.blue0.withAlphaComponent(0.25)
        label.isHidden            = true
        label.layer.cornerRadius  = AdaptSize(2)
        label.layer.masksToBounds = true
        return label
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubviews() {
        self.contentView.addSubview(titleLabel)
        self.contentView.addSubview(serverApiLabel)
        self.contentView.addSubview(webApiLabel)
        self.contentView.addSubview(currentTipLabel)
        titleLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.top.equalToSuperview().offset(AdaptSize(10))
            make.right.lessThanOrEqualToSuperview().offset(AdaptSize(-15))
            make.height.equalTo(titleLabel.font.lineHeight)
        }
        serverApiLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(5))
            make.height.equalTo(serverApiLabel.font.lineHeight)
        }
        webApiLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel)
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalTo(serverApiLabel.snp.bottom)
            make.height.equalTo(webApiLabel.font.lineHeight)
            make.bottom.equalToSuperview().offset(AdaptSize(-15)).priority(.high)
        }
        currentTipLabel.sizeToFit()
        currentTipLabel.snp.makeConstraints { make in
            make.left.equalTo(titleLabel.snp.right).offset(AdaptSize(5))
            make.height.equalTo(currentTipLabel.font.lineHeight)
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(currentTipLabel.width + AdaptSize(8))
        }
    }
    
    private func bindProperty() {
        self.selectionStyle = .none
        self.accessoryType  = .disclosureIndicator
    }
    
    
    // MARK: ==== Event ====
    
    /// 设置显示内容
    /// - Parameters:
    ///   - typeModel: 数据对象
    ///   - indexPath: 当前下标
    ///   - tempSelectType: 临时选择类型
    func setData(typeModel: BPEnvTypeDelegate, indexPath: IndexPath, tempSelectType: BPEnvType?, tempApi: String?, tempWebApi: String?) {
        let type = typeModel.typeList[indexPath.row]
        // 是否选中
        let isSelected: Bool = {
            if let tempEnv = tempSelectType {
                return type == tempEnv
            } else {
                return type == typeModel.currentType
            }
        }()
        if isSelected {
            self.titleLabel.textColor = UIColor.blue0
            self.titleLabel.font      = UIFont.mediumFont(ofSize: AdaptSize(24))
        } else {
            self.titleLabel.textColor = UIColor.black0
            self.titleLabel.font      = UIFont.mediumFont(ofSize: AdaptSize(18))
        }
        
        self.titleLabel.text     = typeModel.title(type: type)
        if type == .debug {
            // 如果没有自定义，则取之前缓存的自定义接口
            if let _tempApi = tempApi {
                self.serverApiLabel.text = "Server: " + _tempApi
            } else {
                self.serverApiLabel.text = "Server: " + (typeModel.customApi ?? "")
            }
            if let _tempWebApi = tempWebApi {
                self.webApiLabel.text    = "   Web: " + _tempWebApi
            } else {
                self.webApiLabel.text    = "   Web: " + (typeModel.customWebApi ?? "")
            }
        } else {
            self.serverApiLabel.text = "Server: " + typeModel.api(type: type)
            self.webApiLabel.text    = "   Web: " + typeModel.webApi(type: type)
        }
        self.currentTipLabel.isHidden = !(type == typeModel.currentType)
    }
}
