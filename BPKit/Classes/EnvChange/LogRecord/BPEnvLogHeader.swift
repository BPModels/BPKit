//
//  BPEnvLogHeader.swift
//  BPKit
//
//  Created by samsha on 2021/7/6.
//

import Foundation
import Lottie

protocol BPEnvLogHeaderDelegate: NSObjectProtocol {
    func clickHeaderAction(section: Int)
}

class BPEnvLogHeader: UITableViewHeaderFooterView {
    
    weak var delegate: BPEnvLogHeaderDelegate?
    private var model: BPEnvLogModel?
    private var section: Int = 0
    
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
    private var arrowLabel: BPLabel = {
        let label = BPLabel()
        label.text          = IconFont.downArrow.rawValue
        label.textColor     = UIColor.gray3
        label.font          = UIFont.iconFont(size: AdaptSize(13))
        label.textAlignment = .center
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
        self.contentView.addSubview(codeLabel)
        self.contentView.addSubview(methodLabel)
        self.contentView.addSubview(pathLabel)
        self.contentView.addSubview(arrowLabel)
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
            make.top.height.equalToSuperview()
            make.right.equalTo(arrowLabel.snp.left)
        }
        arrowLabel.snp.makeConstraints { make in
            make.left.equalTo(pathLabel.snp.right)
            make.right.equalToSuperview()
            make.width.equalTo(AdaptSize(40))
            make.height.equalTo(AdaptSize(30))
            make.centerY.equalToSuperview()
        }
    }
    
    private  func bindProperty() {
        let clickGes = UITapGestureRecognizer(target: self, action: #selector(clickAction))
        self.addGestureRecognizer(clickGes)
    }
    
    // MARK: ==== Event ====
    func setData(model: BPEnvLogModel, section: Int) {
        self.model   = model
        self.section = section
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
        if model.isOpen {
            self.arrowLabel.text = IconFont.upArrow1.rawValue
        } else {
            self.arrowLabel.text = IconFont.downArrow1.rawValue
        }
    }
    
    @objc
    private func clickAction() {
        self.delegate?.clickHeaderAction(section: section)
    }
}

