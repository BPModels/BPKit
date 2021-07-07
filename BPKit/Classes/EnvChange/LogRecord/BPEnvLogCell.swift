//
//  BPEnvLogCell.swift
//  BPKit
//
//  Created by samsha on 2021/7/6.
//

import Foundation
import BPNetwork
import BPDeviceInfo
import Alamofire

class BPEnvLogCell: UITableViewCell {
    
    private var headerTitleLabel: BPLabel = {
        let label = BPLabel()
        label.text          = "HEAD"
        label.textColor     = UIColor.black0
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        return label
    }()
    private var headerLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(11))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private var bodyTitleLabel: BPLabel = {
        let label = BPLabel()
        label.text          = "PARAMETRIC"
        label.textColor     = UIColor.black0
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        return label
    }()
    private var bodyLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(11))
        label.textAlignment = .left
        label.numberOfLines = 0
        return label
    }()
    private var responseTitleLabel: BPLabel = {
        let label = BPLabel()
        label.text          = "RESPONSE"
        label.textColor     = UIColor.black0
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(13))
        label.textAlignment = .left
        return label
    }()
    private var responseLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(11))
        label.textAlignment = .left
        label.numberOfLines = 0
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
        self.backgroundColor = .clear
        let line0 = BPDottedLineView(size: CGSize(width: kScreenWidth, height: 0.5))
        let line1 = BPDottedLineView(size: CGSize(width: kScreenWidth, height: 0.5))
        line0.backgroundColor = .black0
        line1.backgroundColor = .black0
        self.contentView.addSubview(headerTitleLabel)
        self.contentView.addSubview(headerLabel)
        self.contentView.addSubview(line0)
        self.contentView.addSubview(bodyTitleLabel)
        self.contentView.addSubview(bodyLabel)
        self.contentView.addSubview(line1)
        self.contentView.addSubview(responseTitleLabel)
        self.contentView.addSubview(responseLabel)
        headerTitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(headerTitleLabel.font.lineHeight)
        }
        headerLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalTo(headerTitleLabel.snp.bottom).offset(AdaptSize(15))
            make.height.equalTo(AdaptSize(50))
        }
        line0.snp.makeConstraints { make in
            make.left.equalTo(headerLabel)
            make.top.equalTo(headerLabel.snp.bottom).offset(AdaptSize(15))
            make.size.equalTo(line0.size)
        }
        bodyTitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(line0.snp.bottom).offset(AdaptSize(10))
            make.height.equalTo(bodyTitleLabel.font.lineHeight)
        }
        bodyLabel.snp.makeConstraints { make in
            make.left.right.equalTo(headerLabel)
            make.top.equalTo(bodyTitleLabel.snp.bottom).offset(AdaptSize(15))
            make.height.equalTo(AdaptSize(50))
        }
        line1.snp.makeConstraints { make in
            make.left.equalTo(bodyLabel)
            make.size.equalTo(line1.size)
            make.top.equalTo(bodyLabel.snp.bottom).offset(AdaptSize(15))
        }
        responseTitleLabel.snp.makeConstraints { make in
            make.left.right.equalToSuperview()
            make.top.equalTo(line1.snp.bottom).offset(AdaptSize(10))
            make.height.equalTo(responseTitleLabel.font.lineHeight)
        }
        responseLabel.snp.makeConstraints { make in
            make.left.right.equalTo(headerLabel)
            make.top.equalTo(responseTitleLabel.snp.bottom).offset(AdaptSize(15))
            make.height.equalTo(AdaptSize(50))
            make.bottom.equalToSuperview().offset(AdaptSize(-15))
        }
    }
    
    private func bindProperty() {
        self.selectionStyle = .none
    }
    
    // MARK: ==== Event ====
    func setData(model: BPEnvLogModel) {
        headerLabel.text   = (model.request?.header.toJson() ?? "").toJsonFormat()
        bodyLabel.text     = (model.request?.parameters?.toJson())?.toJsonFormat()
        responseLabel.text = model.response?.toJSONString(prettyPrint: true)

        // 更新高度
        headerLabel.sizeToFit()
        bodyLabel.sizeToFit()
        responseLabel.sizeToFit()
        headerLabel.snp.updateConstraints { make in
            make.height.equalTo(headerLabel.height)
        }
        bodyLabel.snp.updateConstraints { make in
            make.height.equalTo(bodyLabel.height)
        }
        responseLabel.snp.updateConstraints { make in
            make.height.equalTo(responseLabel.height)
        }
    }
}

