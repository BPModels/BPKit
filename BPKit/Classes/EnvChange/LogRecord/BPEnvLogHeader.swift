//
//  BPEnvLogHeader.swift
//  BPKit
//
//  Created by samsha on 2021/7/6.
//

import Foundation

class BPEnvLogHeader: UITableViewHeaderFooterView {
    
    private var codeLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .center
        return label
    }()
    private var methodLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(15))
        label.textAlignment = .center
        return label
    }()
    private var pathLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.mediumFont(ofSize: AdaptSize(15))
        label.textAlignment = .left
        return label
    }()
    
    override init(reuseIdentifier: String?) {
        super.init(reuseIdentifier: reuseIdentifier)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createSubviews() {
        self.backgroundColor = .clear
//        self.tintColor       = .clear
        self.contentView.addSubview(codeLabel)
        self.contentView.addSubview(methodLabel)
        self.contentView.addSubview(pathLabel)
        codeLabel.snp.makeConstraints { make in
            make.left.height.top.equalToSuperview()
            make.width.equalTo(AdaptSize(40))
        }
        methodLabel.snp.makeConstraints { make in
            make.left.equalTo(codeLabel.snp.right)
            make.width.equalTo(AdaptSize(50))
            make.height.top.equalToSuperview()
        }
        pathLabel.snp.makeConstraints { make in
            make.left.equalTo(methodLabel.snp.right)
            make.top.height.right.equalToSuperview()
        }
    }
    
    private  func bindProperty() {
        
    }
    
    // MARK: ==== Event ====
    func setData(model: BPEnvLogModel) {
        if let code = model.response?.statusCode {
            self.codeLabel.text = "\(code)"
            if code == 200 {
                self.codeLabel.textColor = .green0
            } else {
                self.codeLabel.textColor = .red0
            }
        }
        self.methodLabel.text = model.request?.method.rawValue
        self.pathLabel.text   = model.request?.path
    }
}

