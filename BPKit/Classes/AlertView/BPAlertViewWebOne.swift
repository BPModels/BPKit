//
//  BPAlertViewWebOne.swift
//  Ant
//
//  Created by 沙庭宇 on 2020/12/27.
//


import WebKit

class BPAlertViewWebOne: BPBaseAlertView {
    
    private var urlStr: String
    private var webView = WKWebView()
 
    init(title: String?, urlStr: String, btnName: String, btnClosure: (() -> Void)?) {
        self.urlStr           = urlStr
        super.init(frame: .zero)
        self.titleLabel.text  = title
        self.leftActionBlock  = btnClosure
        self.leftButton.setTitle(btnName, for: .normal)
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
            make.left.right.top.equalTo(leftButton)
            make.height.equalTo(AdaptSize(0.6))
        }
        leftButton.snp.makeConstraints { (make) in
            make.top.equalTo(webView.snp.bottom).offset(defaultSpace)
            make.left.right.equalToSuperview()
            make.height.equalTo(buttonHeight)
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

