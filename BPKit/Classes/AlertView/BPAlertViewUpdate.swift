//
//  BPAlertViewUpdate.swift
//  Ant
//
//  Created by 沙庭宇 on 2020/12/30.
//

import Foundation

open class BPAlertViewUpdate: BPBaseAlertView {
    
    private var topImageView: BPImageView = {
        let imageView = BPImageView()
        imageView.image = UIImage(named: "updateTopImage")
        return imageView
    }()
    private var textView: UITextView = {
        let textView = UITextView()
        textView.isEditable = false
        let paragraphStyle  = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = AdaptSize(6)
        textView.typingAttributes  = [NSAttributedString.Key.font : UIFont.regularFont(ofSize: AdaptSize(13)),
                                     NSAttributedString.Key.paragraphStyle : paragraphStyle]
        textView.textColor  = UIColor.gray0
        return textView
    }()
    
    init(title: String?, description: String, leftBtnName: String, leftBtnClosure: (() -> Void)?, rightBtnName: String, rightBtnClosure: (() -> Void)?) {
        super.init(frame: .zero)
        self.titleLabel.text       = title
        self.textView.text         = description
        self.descriptionLabel.text = description
        self.rightActionBlock      = rightBtnClosure
        self.leftActionBlock       = leftBtnClosure
        self.leftButton.setTitle(leftBtnName, for: .normal)
        self.rightButton.setTitle(rightBtnName, for: .normal)
        self.createSubviews()
        self.bindProperty()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    open override func createSubviews() {
        super.createSubviews()
        self.mainViewWidth = AdaptSize(270)
        mainView.addSubview(topImageView)
        mainView.addSubview(titleLabel)
        mainView.addSubview(textView)
        mainView.addSubview(leftButton)
        mainView.addSubview(rightButton)
        
        topImageView.snp.makeConstraints { (make) in
            make.left.right.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top)
            make.height.equalTo(AdaptSize(150))
        }
        textView.sizeToFit()
        let textViewH = textView.height > AdaptSize(200) ? AdaptSize(200) : textView.height
        // 是否显示标题
        if let title = titleLabel.text, title.isNotEmpty {
            titleLabel.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalToSuperview().offset(-rightPadding)
                make.height.equalTo(titleHeight)
            }
            textView.snp.makeConstraints { (make) in
                make.top.equalTo(titleLabel.snp.bottom).offset(defaultSpace)
                make.left.right.equalTo(titleLabel)
                make.height.equalTo(textViewH)
            }
            mainViewHeight += topPadding + titleHeight + defaultSpace + textViewH
        } else {
            textView.snp.makeConstraints { (make) in
                make.top.equalToSuperview().offset(topPadding)
                make.left.equalToSuperview().offset(leftPadding)
                make.right.equalTo(-rightPadding)
                make.height.equalTo(textViewH)
            }
            mainViewHeight += topPadding + textViewH
        }
        let buttonSize = CGSize(width: AdaptSize(104), height: AdaptSize(34))
        rightButton.snp.makeConstraints { (make) in
            make.top.equalTo(textView.snp.bottom).offset(defaultSpace)
            make.left.equalToSuperview().offset(mainViewWidth/2 + AdaptSize(5))
            make.size.equalTo(buttonSize)
        }

        leftButton.snp.makeConstraints { (make) in
            make.top.size.equalTo(rightButton)
            make.right.equalTo(rightButton.snp.left).offset(AdaptSize(-10))
        }
        mainViewHeight += defaultSpace + buttonHeight

        mainView.snp.makeConstraints { (make) in
            make.center.equalToSuperview()
            make.width.equalTo(mainViewWidth)
            make.height.equalTo(mainViewHeight)
        }
    }
    
    open override func bindProperty() {
        super.bindProperty()
        self.contentView.backgroundColor    = .white0
        self.leftButton.backgroundColor     = UIColor.gray1
        self.leftButton.layer.cornerRadius  = AdaptSize(5)
        self.leftButton.layer.masksToBounds = true
        self.leftButton.titleLabel?.font    = UIFont.regularFont(ofSize: AdaptSize(13))
        self.leftButton.setBackgroundImage(nil, for: .normal)
        self.leftButton.setTitleColor(UIColor.gray0)
        self.rightButton.backgroundColor     = UIColor.blue0
        self.rightButton.layer.cornerRadius  = AdaptSize(5)
        self.rightButton.layer.masksToBounds = true
        self.rightButton.titleLabel?.font    = UIFont.regularFont(ofSize: AdaptSize(13))
        self.rightButton.setBackgroundImage(nil, for: .normal)
        self.rightButton.setTitleColor(UIColor.white0)
        self.backgroundView.isUserInteractionEnabled = false
        self.titleLabel.font = UIFont.regularFont(ofSize: AdaptSize(14))
        self.mainView.layer.cornerRadius = AdaptSize(10)
    }
}
