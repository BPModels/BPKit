//
//  BPEnvLogToolsBar.swift
//  BPKit
//
//  Created by samsha on 2021/7/7.
//

import Foundation
import Lottie

protocol BPEnvLogToolsBarDeleagate: NSObjectProtocol {
    /// 清除
    func clearAction()
    /// 在线状态
    func onlineAction(isOnline: Bool)
}

class BPEnvLogToolsBar: BPView {

    weak var delegate: BPEnvLogToolsBarDeleagate?
    private var isOnline = true {
        willSet {
            if newValue {
                onlineView.layer.opacity = 1.0
                onlineView.play()
            } else {
                onlineView.layer.opacity = 0.25
                onlineView.pause()
            }
        }
    }

    private let onlineView: AnimationView = {
        if let path = sourceBundle?.path(forResource: "online", ofType: "json") {
            var view = AnimationView(filePath: path)
            view.size = CGSize(width: AdaptSize(50), height: AdaptSize(50))
            view.animationSpeed = 2.5
            view.loopMode = .loop
            return view
        } else {
            return AnimationView(name: "online")
        }
    }()
    
    private let clearView: AnimationView = {
        if let path = sourceBundle?.path(forResource: "clear", ofType: "json") {
            var view = AnimationView(filePath: path)
            view.size = CGSize(width: AdaptSize(25), height: AdaptSize(25))
            return view
        } else {
            return AnimationView(name: "clear")
        }
    }()
    
    private let closeView: AnimationView = {
        if let path = sourceBundle?.path(forResource: "close", ofType: "json") {
            var view = AnimationView(filePath: path)
            view.size = CGSize(width: AdaptSize(60), height: AdaptSize(60))
            return view
        } else {
            return AnimationView(name: "close")
        }
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func createSubviews() {
        super.createSubviews()
        self.backgroundColor = .gray0
        let stackView = BPStackView(type: .center, subview: [onlineView, clearView, closeView], spacing: AdaptSize(10))
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.isOnline = true
        let tapOnlineGes = UITapGestureRecognizer(target: self, action: #selector(onlineAction))
        let tapClearGes  = UITapGestureRecognizer(target: self, action: #selector(clearAction))
        let tapCloseGes  = UITapGestureRecognizer(target: self, action: #selector(closeAction))
        self.onlineView.addGestureRecognizer(tapOnlineGes)
        self.clearView.addGestureRecognizer(tapClearGes)
        self.closeView.addGestureRecognizer(tapCloseGes)
    }
    
    // MARK: ==== Event ====
    @objc
    private func clearAction() {
        self.delegate?.clearAction()
        self.clearView.play()
    }
    
    @objc
    private func onlineAction() {
        self.isOnline = !isOnline
        self.delegate?.onlineAction(isOnline: isOnline)
    }
    
    @objc
    private func closeAction() {
        BPEnvLogView.hide()
    }
}

