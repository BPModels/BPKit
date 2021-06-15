//
//  BPBaseAlertView.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

/// 优先级由高到低
public enum BPAlertPriorityEnum: Int {
    case A = 0
    case B = 1
    case C = 2
    case D = 3
    case E = 4
    case F = 5
    case normal = 100
}

/// AlertView的基类,默认只显示标题或者标题+描述信息
public class BPBaseAlertView: BPTopWindowView {
    
    /// 弹框优先级
    public var priority: BPAlertPriorityEnum = .normal
    /// 是否已展示过
    public var isShowed = false
    /// 默认事件触发后自动关闭页面
    public var autoClose: Bool = true
    /// 确定按钮是否标红（破坏性操作警告）
    public var isDestruct: Bool = false
    
    /// 弹框的默认宽度
    public var mainViewWidth = AdaptSize(300)
    /// 弹框的默认高度
    public var mainViewHeight: CGFloat = .zero
    /// 弹框内容最大高度
    public var maxContentHeight: CGFloat = AdaptSize(300)
    
    /// 间距
    let leftPadding: CGFloat   = AdaptSize(20)
    let rightPadding: CGFloat  = AdaptSize(20)
    let topPadding: CGFloat    = AdaptSize(25)
    let bottomPadding: CGFloat = .zero
    let defaultSpace: CGFloat  = AdaptSize(15)
    let buttonHeight: CGFloat  = AdaptSize(50)
    let closeBtnSize: CGSize   = CGSize(width: AdaptSize(50), height: AdaptSize(50))
    
    let webCotentHeight        = AdaptSize(300)
    let imageViewSize: CGSize  = CGSize(width: AdaptSize(300), height: AdaptSize(500))
    
    // 标题的高度
    public var titleHeight: CGFloat {
        get {
            return self.titleLabel.textHeight(width: mainViewWidth - leftPadding - rightPadding)
        }
    }
    // 描述的高度
    public var descriptionHeight: CGFloat {
        get {
            return self.descriptionLabel.textHeight(width: mainViewWidth - leftPadding - rightPadding)
        }
    }
    
    public var descriptionText: String = ""
    public var imageUrlStr: String?
    public var leftActionBlock: DefaultBlock?
    public var rightActionBlock: DefaultBlock?
    public var closeActionBlock: DefaultBlock?
    public var imageActionBlock: ((String?)->Void)?
    
    // 弹框的背景
    public var mainView: UIView = {
        let view = UIView()
        view.backgroundColor     = UIColor.white0
        view.layer.cornerRadius  = AdaptSize(5)
        view.layer.masksToBounds = true
        return view
    }()

    // 弹窗标题
    public var titleLabel: UILabel = {
        let label           = UILabel()
        label.numberOfLines = 1
        label.textColor     = UIColor.black0
        label.font          = UIFont.iconFont(size: AdaptSize(16))
        label.textAlignment = .center
        return label
    }()
    
    public var contentScrollView: UIScrollView = {
       let scrollView = UIScrollView()
        scrollView.showsHorizontalScrollIndicator = false
        scrollView.showsVerticalScrollIndicator   = false
        return scrollView
    }()
    
    /// 自定义富文本视图
    public var attributionView: BPAttributionView?

    // 弹窗描述
    public var descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor     = UIColor.black0.withAlphaComponent(0.5)
        label.font          = UIFont.regularFont(ofSize: AdaptSize(16))
        label.numberOfLines = 0
        label.textAlignment = .center
        return label
    }()

    public var partitionContentLineView: BPView = {
        let view = BPView()
        view.backgroundColor = UIColor.gray1
        return view
    }()
    
    public var partitionButtonLineView: BPView = {
       let view = BPView()
        view.backgroundColor = UIColor.gray1
        return view
    }()
    
    /// 内容视图
    private var contentView: BPView = {
        let view = BPView()
        view.backgroundColor = UIColor.clear
        return view
    }()
    
    /// 左边按钮
    public var leftButton: BPButton = {
        let button = BPButton(animation: false)
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.white0), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.gray1), for: .highlighted)
        button.setTitleColor(UIColor.gray0, for: .normal)
        button.titleLabel?.font = UIFont.mediumFont(ofSize: AdaptSize(18))
        return button
    }()

    /// 右边按钮
    public var rightButton: BPButton = {
        let button = BPButton(animation: false)
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.white0), for: .normal)
        button.setBackgroundImage(UIImage.imageWithColor(UIColor.gray1), for: .highlighted)
        button.setTitleColor(UIColor.blue0, for: .normal)
        button.titleLabel?.font = UIFont.mediumFont(ofSize: AdaptSize(18))
        return button
    }()

    /// 关闭按钮
    public var closeButton: BPButton = {
        let button = BPButton()
        button.setTitle(IconFont.close.rawValue, for: .normal)
        button.setTitleColor(UIColor.black0.withAlphaComponent(0.8), for: .normal)
        button.titleLabel?.font = UIFont.iconFont(size: AdaptSize(40))
        button.isHidden = true
        button.backgroundColor = UIColor.clear
        return button
    }()

    /// 图片
    public var imageView: BPImageView = {
        let imageView = BPImageView()
        imageView.contentMode = UIView.ContentMode.scaleAspectFill
        imageView.isUserInteractionEnabled = true
        imageView.layer.cornerRadius       = AdaptSize(15)
        imageView.layer.masksToBounds      = true
        return imageView
    }()
    
    public override func createSubviews() {
        super.createSubviews()
        self.addSubview(mainView)
    }
    
    public override func bindProperty() {
        super.bindProperty()
        let tapImage      = UITapGestureRecognizer(target: self, action: #selector(clickImageAction))
        self.imageView.addGestureRecognizer(tapImage)
        self.leftButton.addTarget(self, action: #selector(leftAction), for: .touchUpInside)
        self.rightButton.addTarget(self, action: #selector(rightAction), for: .touchUpInside)
        self.closeButton.addTarget(self, action: #selector(hide), for: .touchUpInside)
    }
    
    // MARK: ==== Event ====
    public override func show(view: UIView = kWindow) {
        super.show(view: view)
        UIViewController.currentViewController?.view.endEditing(true)
        // 果冻动画
        self.mainView.layer.addJellyAnimation()
    }

    @objc func leftAction() {
        self.leftActionBlock?()
        if autoClose {
            self.hide()
        }
    }

    @objc func rightAction() {
        self.rightActionBlock?()
        if autoClose {
            self.hide()
        }
    }
    
    @objc func clickImageAction() {
        self.imageActionBlock?(self.imageUrlStr)
        if autoClose {
            self.hide()
        }
    }
    
    @objc public override func hide() {
        UIView.animate(withDuration: 0.25) { [weak self] in
            self?.mainView.transform = CGAffineTransform(scaleX: 0, y: 0)
        }
        super.hide()
        self.closeActionBlock?()
    }
}
