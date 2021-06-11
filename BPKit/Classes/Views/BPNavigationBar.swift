//
//  BPCustomNavigationBar.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/8.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import Foundation

protocol BPNavigationBarDelegate: NSObjectProtocol {
    func leftAction()
    func rightAction()
}

class BPNavigationBar: BPView {
    
    weak var delegate: BPNavigationBarDelegate?
    
    /// 设置大标题
    var isBigTitle: Bool = false {
        didSet {
            self.setBigTitle()
        }
    }
    
    var titleLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.black0
        label.font          = UIFont.iconFont(size: AdaptSize(18))
        label.textAlignment = .center
        return label
    }()
    
    var leftButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.back.rawValue, for: .normal)
        button.setTitleColor(UIColor.black0)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(16))
        button.contentHorizontalAlignment = .left
        return button
    }()
    
    var rightButton: BPButton = {
        let button = BPButton()
        button.setTitleColor(UIColor.black0, for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(16))
        button.isHidden = true
        button.contentHorizontalAlignment = .right
        return button
    }()
    
    var leftTitle: String? = "" {
        willSet {
            self.leftButton.setTitle(newValue, for: .normal)
            self.leftButton.sizeToFit()
            self.leftButton.snp.updateConstraints { (make) in
                make.width.equalTo(leftButton.width)
            }
        }
    }
    
    var title: String? = "" {
        willSet {
            self.titleLabel.text = newValue
        }
    }
    
    var rightTitle: String? {
        set {
            self.rightButton.setTitle(newValue, for: .normal)
            self.rightButton.isHidden = false
            self.rightButton.sizeToFit()
            self.rightButton.snp.updateConstraints { (make) in
                make.width.equalTo(rightButton.width)
            }
        }
        get {
            return self.rightButton.currentTitle
        }
    }
    
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
        self.addSubview(leftButton)
        self.addSubview(titleLabel)
        self.addSubview(rightButton)
        leftButton.snp.makeConstraints { (make) in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(AdaptSize(40))
            make.height.equalTo(AdaptSize(26))
        }
        titleLabel.snp.makeConstraints { (make) in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().offset(AdaptSize(-10))
            make.width.equalTo(kScreenWidth - AdaptSize(120))
            make.height.equalTo(titleLabel.font.lineHeight)
        }
        rightButton.snp.makeConstraints { (make) in
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.centerY.equalTo(titleLabel)
            make.width.equalTo(AdaptSize(40))
            make.height.equalTo(AdaptSize(26))
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.backgroundColor = .white0
        self.leftButton.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        self.setTextColor(color: .black0)
        // 设置默认标题
        if let currentVC = UIViewController.currentViewController {
            self.title      = currentVC.title
            self.rightTitle = currentVC.rightText
            self.rightButton.setImage(currentVC.rightImage, for: .normal)
        }
        
    }
    
    // MARK: ==== Event ====
    @objc
    private func leftAction(btn: BPButton) {
        btn.setStatus(.disable)
        self.delegate?.leftAction()
        btn.setStatus(.normal)
    }
    
    @objc
    private func rightAction(btn: BPButton) {
        btn.setStatus(.disable)
        self.delegate?.rightAction()
        btn.setStatus(.normal)
    }
    
    func hideLeftButton() {
        self.leftButton.isHidden = true
    }
    
    func hideRightButton() {
        self.rightButton.isHidden = true
    }

    /// 设置大字体
    private func setBigTitle() {
        if isBigTitle {
            self.leftButton.titleLabel?.font = UIFont.mediumFont(ofSize: AdaptSize(20))
            self.leftButton.setTitle(title, for: .normal)
            self.titleLabel.isHidden = true
            self.leftButton.sizeToFit()
            self.leftButton.snp.updateConstraints { (make) in
                make.width.equalTo(leftButton.width)
                make.height.equalTo(leftButton.height)
            }
        } else {
            self.leftButton.titleLabel?.font = UIFont.iconFont(size: AdaptSize(16))
            self.leftButton.setTitle(IconFont.back.rawValue, for: .normal)
            self.titleLabel.isHidden = false
            self.leftButton.sizeToFit()
            self.leftButton.snp.updateConstraints { (make) in
                make.width.equalTo(AdaptSize(40))
                make.height.equalTo(AdaptSize(26))
            }
        }
    }
    
    /// 设置字体颜色
    func setTextColor(color: UIColor) {
        self.leftButton.setTitleColor(color)
        self.titleLabel.textColor = color
        self.rightButton.setTitleColor(color)
    }
    
}
