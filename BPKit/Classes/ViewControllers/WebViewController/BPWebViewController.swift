//
//  BPWebViewController.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/10/17.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit
import WebKit

open class BPWebViewController: BPViewController {
    public var urlStr: String   = ""
    public var backBlock: DefaultBlock?
    public var hideNavigationBar: Bool = false
    
    public let configuration = WKWebViewConfiguration()
    
    public lazy var webView: WKWebView = {
        self.setConfiguration()
        let _webView = WKWebView(frame: CGRect(x: 0, y: 0, width: kScreenWidth, height: kScreenHeight), configuration: configuration)
        return _webView
    }()
    public var progressView: UIProgressView?
    
    private func setConfiguration() {
        // 视频播放是否允许调用本地播放器
        configuration.allowsInlineMediaPlayback = true
        // 设置哪些设备(音频或视频)需要用户主动播放,不自动播放
        configuration.mediaTypesRequiringUserActionForPlayback = .all
        // 是否允许画中画(缩放视频在浏览器内,不影响其他操作)效果,特定设备有效
        configuration.allowsPictureInPictureMediaPlayback = true
        // 设置请求时的User—Agent信息中的应用名称, iOS9之后又用
        configuration.applicationNameForUserAgent = "User_agent name"
        // ---- 设置偏好设置 ----
        let preferences = WKPreferences()
        // 设置最小字体,优先JS的控制,可关闭javaScriptEnabled.来测试
        preferences.minimumFontSize = 0
        // 是否支持javaScriptEnable
        preferences.javaScriptEnabled = true
        // 是否可以不经过用户同意,直接由JS控制打开窗口
        preferences.javaScriptCanOpenWindowsAutomatically = true
        configuration.preferences = preferences
        
        // 这个类主要负责与JS交互管理
        let userContentController = WKUserContentController()
        configuration.userContentController = userContentController
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        self.createSubviews()
        self.bindProperty()
        self.bindData()
    }
    
    open override func createSubviews() {
        super.createSubviews()
        self.view.addSubview(webView)
        webView.snp.makeConstraints { (make) in
            make.left.right.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(kNavHeight)
        }
    }
    
    open override func bindProperty() {
        super.bindProperty()
        self.customNavigationBar?.title    = title
        self.customNavigationBar?.isHidden = hideNavigationBar
    }
    
    open override func bindData() {
        super.bindData()
        guard let url = URL(string: urlStr) else {
            kWindow.toast("地址无效")
            self.navigationController?.pop()
            return
        }
        let request = URLRequest(url: url, cachePolicy: .reloadIgnoringLocalAndRemoteCacheData, timeoutInterval: 30)
        self.webView.load(request)
    }
    
    open override func leftAction() {
        super.leftAction()
        self.backBlock?()
    }
    
    
    public func userContentController(_ userContentController: WKUserContentController, didReceive message: WKScriptMessage) {
        return
    }
}
