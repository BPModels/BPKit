//
//  ViewController.swift
//  BPKit
//
//  Created by TestEngineerFish on 06/10/2021.
//  Copyright (c) 2021 TestEngineerFish. All rights reserved.
//

import UIKit
import BPKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}

protocol BPLoginInputViewItemDelegate: NSObjectProtocol {
    func editing(textField: UITextField)
}


class BPAlertViewWorkerBasicInfoPhoneContactView: BPBaseAlertView, BPLoginInputViewItemDelegate {
   
    private let phoneNumberItem   = UITextField()
    
    private var rightActionCallBack: ((String) -> Void)?
    
    init(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: ((String) -> Void)?, isDestruct: Bool = false) {
        super.init(frame: .zero)
        self.isDestruct            = isDestruct
        self.titleLabel.text       = title
        self.descriptionLabel.text = description
        self.rightActionCallBack   = rightBtnClosure
        self.leftActionBlock       = leftBtnClosure
        self.leftButton.setTitle(leftBtnName, for: .normal)
        self.rightButton.setTitle(rightBtnName, for: .normal)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        
        mainView.addSubview(titleLabel)
//        mainView.addSubview(contentScrollView)
//        contentScrollView.addSubview(descriptionLabel)
        mainView.addSubview(phoneNumberItem)
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
        mainViewHeight += AdaptSize(25) + AdaptSize(55)
        phoneNumberItem.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(AdaptSize(25))
            make.left.equalTo(AdaptSize(15))
            make.right.equalTo(-AdaptSize(15))
            make.height.equalTo(AdaptSize(55))
        }
        
        partitionContentLineView.snp.makeConstraints { (make) in
            make.top.equalTo(phoneNumberItem.snp.bottom).offset(AdaptSize(25))
            make.left.right.equalToSuperview()
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
        mainViewHeight += AdaptSize(25) + buttonHeight
        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(mainViewWidth)
            make.height.equalTo(mainViewHeight)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.backgroundView.isUserInteractionEnabled = false
        if self.isDestruct {
            self.rightButton.setTitleColor(UIColor.red1)
        } else {
            self.rightButton.setTitleColor(UIColor.blue0)
        }
        self.phoneNumberItem.delegate = self

    }
    
    func editing(textField: UITextField) {
        
    }
    
    @objc
    override func rightAction() {
        guard phoneNumberItem.isValid else {
            return
        }
        self.rightActionCallBack?(self.phoneNumberItem.getTextValue())
        if autoClose {
            self.hide()
        }
    }
    
}
