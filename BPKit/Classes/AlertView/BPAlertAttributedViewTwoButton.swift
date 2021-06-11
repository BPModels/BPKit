//
//  BPAlertAttributedViewTwoButton.swift
//  Tenant
//
//  Created by samsha on 2021/1/30.
//

import Foundation

/// 默认AlertView,显示底部左右两个按钮的样式
class BPAlertAttributedViewTwoButton: BPBaseAlertView {
    
    
    init(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?, isDestruct: Bool = false) {
        super.init(frame: .zero)
        self.isDestruct            = isDestruct
        self.titleLabel.text       = title
        self.descriptionText       = description
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
        
        self.attributionView = BPAttributionView(width: mainViewWidth - leftPadding - rightPadding)
        attributionView?.text = descriptionText
        attributionView?.font = UIFont.regularFont(ofSize: AdaptSize(14))
 
        
        mainView.addSubview(titleLabel)
        mainView.addSubview(contentScrollView)
        contentScrollView.addSubview(attributionView!)
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
        attributionView?.snp.makeConstraints { (make) in
            make.size.equalTo(attributionView!.size)
            make.top.equalToSuperview()
            make.bottom.equalToSuperview()
            make.left.equalToSuperview().offset(leftPadding)
            make.right.equalToSuperview().offset(-rightPadding)
        }
        contentScrollView.snp.makeConstraints { (make) in
            make.top.equalTo(titleLabel.snp.bottom).offset(defaultSpace)
            make.left.right.equalToSuperview()
            make.bottom.equalTo(partitionContentLineView.snp.top).offset(-defaultSpace)
        }
        if attributionView!.height > maxContentHeight {
            mainViewHeight += defaultSpace + maxContentHeight
        } else {
            mainViewHeight += defaultSpace + attributionView!.height
        }
        
        partitionContentLineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(contentScrollView.snp.bottom).offset(defaultSpace)
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
        if self.isDestruct {
            self.rightButton.setTitleColor(UIColor.red1)
        } else {
            self.rightButton.setTitleColor(UIColor.blue0)
        }
    }
}
