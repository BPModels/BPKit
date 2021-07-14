//
//  BPTableViewEmptyView.swift
//  BPKit
//
//  Created by samsha on 2021/7/8.
//

import Foundation

class BPTableViewEmptyView: BPView {
    
    private var clickButtonBlock: (()->Void)?
    
    private var imageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = .scaleAspectFill
        return imageView
    }()
    
    private var hintLabel: BPLabel = {
        let label = BPLabel()
        label.text          = ""
        label.textColor     = UIColor.gray0
        label.font          = UIFont.regularFont(ofSize: AdaptSize(17))
        label.textAlignment = .center
        return label
    }()
    
    private var actionButton: BPButton = {
        let button = BPButton(.second)
        button.setTitleColor(UIColor.white0, for: .normal)
        button.titleLabel?.font = UIFont.regularFont(ofSize: AdaptSize(15))
        return button
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.createSubviews()
        self.bindProperty()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: ==== BPViewDelegate ====
    
    override func createSubviews() {
        super.createSubviews()
        self.addSubview(imageView)
        self.addSubview(hintLabel)
        self.addSubview(actionButton)
        imageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(AdaptSize(100))
            make.size.equalTo(CGSize(width: AdaptSize(84), height: AdaptSize(84)))
        }
        hintLabel.snp.makeConstraints { make in
            make.left.equalToSuperview().offset(AdaptSize(15))
            make.right.equalToSuperview().offset(AdaptSize(-15))
            make.top.equalTo(imageView.snp.bottom).offset(AdaptSize(28))
            make.height.equalTo(hintLabel.font.lineHeight)
        }
        actionButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(hintLabel.snp.bottom).offset(AdaptSize(28))
            make.size.equalTo(CGSize(width: AdaptSize(100), height: AdaptSize(50)))
        }
    }
    
    override func bindProperty() {
        super.bindProperty()
        self.actionButton.addTarget(self, action: #selector(buttonAction), for: .touchUpInside)
    }
    
    // MARK: ==== Event ====
    func setData(image: UIImage?, hintText: String?, buttonText: String?, actionBlock: (()->Void)?) {
        if let _image = image {
            self.imageView.image = _image
        } else {
            // 默认图
            self.imageView.image = getImage(name: "bp_empty", type: "png")
        }
        if let _hintText = hintText {
            self.hintLabel.text = _hintText
        } else {
            // 默认文案
            self.hintLabel.text = "暂无数据"
        }
        if let _buttonText = buttonText {
            self.actionButton.setTitle(_buttonText, for: .normal)
            self.actionButton.sizeToFit()
            self.actionButton.snp.updateConstraints { make in
                make.size.equalTo(CGSize(width: actionButton.width + AdaptSize(25), height: actionButton.height + AdaptSize(5)))
            }
        } else {
            self.actionButton.isHidden = true
        }
        
        self.clickButtonBlock = actionBlock
    }
    @objc
    private func buttonAction() {
        self.clickButtonBlock?()
    }
}

