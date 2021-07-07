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
}

class BPEnvLogToolsBar: BPView {

    weak var delegate: BPEnvLogToolsBarDeleagate?

    private let clearView: AnimationView = {
        var view = AnimationView(name: "clear")
        view.size = CGSize(width: AdaptSize(60), height: AdaptSize(50))
        view.animationSpeed = 2.5
        return view
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
        let stackView = BPStackView(type: .center, subview: [clearView], spacing: AdaptSize(10))
        self.addSubview(stackView)
        stackView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
//        self.clearButton.addTarget(self, action: #selector(clearAction), for: .touchUpInside)
    }
    
    // MARK: ==== Event ====
    @objc
    private func clearAction() {
        self.delegate?.clearAction()
    }
}

