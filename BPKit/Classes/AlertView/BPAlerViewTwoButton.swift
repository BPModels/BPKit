//
//  BPAlerViewTwoButton.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/5.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// 默认AlertView,显示底部左右两个按钮的样式
class BPAlerViewTwoButton: BPBaseAlertView {

    init(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?, isDestruct: Bool = false) {
        super.init(frame: .zero)
        self.isDestruct            = isDestruct
        self.titleLabel.text       = title
        self.descriptionLabel.text = description
        self.rightActionBlock      = rightBtnClosure
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
        mainView.addSubview(descriptionLabel)
        mainView.addSubview(leftButton)
        mainView.addSubview(rightButton)
        mainView.addSubview(partitionContentLineView)
        mainView.addSubview(partitionButtonLineView)
        // 是否显示标题
        if let title = titleLabel.text, title.isNotEmpty {
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalToSuperview().offset(-rightPadding)
                make.height.equalTo(titleHeight)
            }
            descriptionLabel.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(defaultSpace)
                make.left.right.equalTo(titleLabel)
                make.height.equalTo(descriptionHeight)
            }
            mainViewHeight += topPadding + titleHeight + defaultSpace + descriptionHeight
        } else {
            descriptionLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalTo(-rightPadding)
                make.height.equalTo(descriptionHeight)
            }
            mainViewHeight += topPadding + descriptionHeight
        }

        partitionContentLineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(rightButton)
            make.height.equalTo(AdaptSize(0.6))
        }
        rightButton.snp.makeConstraints { (make) in
            make.top.equalTo(descriptionLabel.snp.bottom).offset(defaultSpace)
            make.left.equalTo(leftButton.snp.right)
            make.right.equalToSuperview()
            make.height.equalTo(buttonHeight)
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        partitionButtonLineView.snp.makeConstraints { (make) in
            make.left.top.bottom.equalTo(rightButton)
            make.width.equalTo(AdaptSize(0.6))
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
        if self.isDestruct {
            self.rightButton.setTitleColor(UIColor.red1)
        } else {
            self.rightButton.setTitleColor(UIColor.blue0)
        }
    }
}

