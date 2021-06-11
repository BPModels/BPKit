//
//  BPAlertViewWeb.swift
//  Ant
//
//  Created by 沙庭宇 on 2020/12/25.
//

import WebKit

class BPAlertViewWeb: BPBaseAlertView {
    
    private var urlStr: String
    private var webView = WKWebView()
 
    init(title: String?, urlStr: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?) {
        self.urlStr           = urlStr
        super.init(frame: .zero)
        self.titleLabel.text  = title
        self.rightActionBlock = rightBtnClosure
        self.leftActionBlock  = leftBtnClosure
        self.leftButton.setTitle(leftBtnName, for: .normal)
        self.rightButton.setTitle(rightBtnName, for: .normal)
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func createSubviews() {
        super.createSubviews()
        mainView.addSubview(titleLabel)
        mainView.addSubview(webView)
        mainView.addSubview(leftButton)
        mainView.addSubview(rightButton)
        mainView.addSubview(partitionContentLineView)
        mainView.addSubview(partitionButtonLineView)

        mainViewHeight += topPadding
        // 是否显示标题
        if let title = titleLabel.text, title.isNotEmpty {
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalToSuperview().offset(-rightPadding)
                make.height.equalTo(titleHeight)
            }
            mainViewHeight += titleHeight
        }
        webView.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalToSuperview().offset(mainViewHeight + defaultSpace)
            make.height.equalTo(webCotentHeight)
        }
        mainViewHeight += webCotentHeight + defaultSpace
        partitionContentLineView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.top.equalTo(rightButton)
            make.height.equalTo(AdaptSize(0.6))
        }
        rightButton.snp.makeConstraints { (make) in
            make.top.equalTo(webView.snp.bottom).offset(defaultSpace)
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
        mainViewHeight += defaultSpace + buttonHeight + bottomPadding

        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(mainViewWidth)
            make.height.equalTo(mainViewHeight)
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.mainView.backgroundColor = .white0
        self.backgroundView.isUserInteractionEnabled = false
    }
    
    override func bindData() {
        super.bindData()
        guard let url = URL(string: urlStr) else {
            return
        }
        let requestUrl = URLRequest(url: url)
        self.webView.load(requestUrl)
    }
}
