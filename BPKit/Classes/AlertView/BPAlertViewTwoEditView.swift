//
//  BPAlertViewTwoEditView.swift
//  Tenant
//
//  Created by samsha on 2021/5/31.
//

import Foundation

class BPAlertViewTwoEditView: BPBaseAlertView {
    
    private let textFieldHeight = AdaptSize(45)
    let firstTextField: BPTextField = {
        let textField = BPTextField()
        textField.font          = UIFont.regularFont(ofSize: AdaptSize(16))
        textField.textColor     = UIColor.black0
        textField.textAlignment = .left
        textField.showBorder    = true
        textField.showLeftView  = true
        textField.showRightView = true
        textField.keyboardType  = .numbersAndPunctuation
        return textField
    }()
    let secondTextField: BPTextField = {
        let textField = BPTextField()
        textField.font          = UIFont.regularFont(ofSize: AdaptSize(16))
        textField.textColor     = UIColor.black0
        textField.textAlignment = .left
        textField.showBorder    = true
        textField.showLeftView  = true
        textField.showRightView = true
        textField.keyboardType  = .numbersAndPunctuation
        return textField
    }()
    // 点击确定后返回两个文本框中的值
    private var customRightActionBlock: ((String?, String?) -> Void)?
    
    init(title: String?, firstPlaceholder: String, secondPlaceholder: String, rightBtnClosure: ((String?, String?) -> Void)?) {
        super.init(frame: .zero)
        self.titleLabel.text             = title
        self.firstTextField.placeholder  = firstPlaceholder
        self.secondTextField.placeholder = secondPlaceholder
        self.customRightActionBlock      = rightBtnClosure
        self.leftButton.setTitle("取消", for: .normal)
        self.rightButton.setTitle("确定", for: .normal)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        
        mainView.addSubview(titleLabel)
        mainView.addSubview(firstTextField)
        mainView.addSubview(secondTextField)
        mainView.addSubview(leftButton)
        mainView.addSubview(rightButton)
        mainView.addSubview(partitionContentLineView)
        mainView.addSubview(partitionButtonLineView)
        
        titleLabel.snp.makeConstraints { (make) in
            make.top.equalToSuperview().offset(topPadding)
            make.left.equalToSuperview().offset(leftPadding)
            make.right.equalToSuperview().offset(-rightPadding)
            make.height.equalTo(titleHeight)
        }
        mainViewHeight += topPadding + titleHeight
        firstTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(leftPadding)
            make.right.equalToSuperview().offset(rightPadding)
            make.top.equalTo(titleLabel.snp.bottom).offset(defaultSpace)
            make.height.equalTo(textFieldHeight)
        }
        mainViewHeight += textFieldHeight + defaultSpace
        secondTextField.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(leftPadding)
            make.right.equalToSuperview().offset(rightPadding)
            make.top.equalTo(firstTextField.snp.bottom).offset(defaultSpace)
            make.height.equalTo(textFieldHeight)
        }
        mainViewHeight += textFieldHeight + defaultSpace
        partitionContentLineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(secondTextField.snp.bottom).offset(defaultSpace)
            make.height.equalTo(AdaptSize(0.6))
        }
        partitionButtonLineView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(rightButton)
            make.width.equalTo(AdaptSize(0.6))
        }
        rightButton.snp.makeConstraints { (make) in
            make.top.equalTo(partitionContentLineView.snp.bottom)
            make.left.equalTo(leftButton.snp.right)
            make.right.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.bottom.equalToSuperview()
        }
        leftButton.snp.makeConstraints { (make) in
            make.top.height.equalTo(rightButton)
            make.left.equalToSuperview()
        }
        mainViewHeight += defaultSpace + buttonHeight
        
        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(mainViewWidth)
            make.height.equalTo(mainViewHeight)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.backgroundView.isUserInteractionEnabled = false
    }
    
    // Mark: ==== Event ====
    override func rightAction() {
        self.customRightActionBlock?(firstTextField.text, secondTextField.text)
        super.rightAction()
    }
}
