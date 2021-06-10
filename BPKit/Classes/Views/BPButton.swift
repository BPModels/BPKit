//
//  BPBaseButton.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/8/6.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit


enum BPButtonStatusEnum: Int {
    case normal
    case touchDown
    case disable
}

enum BPButtonType: Int {
    /// 普通的按钮，无特殊样式
    case normal
    /// 主按钮，主题蓝色渐变背景样式
    case theme
    /// 次按钮，主题蓝色边框样式
    case second
}

@IBDesignable
class BPButton: UIButton {
    
    private var status: BPButtonStatusEnum = .normal
    private var type: BPButtonType
    private var showAnimation: Bool
    
    /// 正常状态透明度
    var normalOpacity:Float     = 1.0
    /// 禁用状态透明度
    var disableOpacity:Float    = 0.3
    
    
    // MARK: ---- Init ----
    
    init(_ type: BPButtonType = .normal, frame: CGRect = .zero, animation: Bool = true) {
        self.type          = type
        self.showAnimation = animation
        super.init(frame: frame)
        
        self.bindProperty()
        self.addTarget(self, action: #selector(touchDown(sender:)), for: .touchDown)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchUpInside)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchUpOutside)
        self.addTarget(self, action: #selector(touchUp(sender:)), for: .touchCancel)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    deinit {
        self.removeTarget(self, action: #selector(touchDown(sender:)), for: .touchDown)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchUpInside)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchUpOutside)
        self.removeTarget(self, action: #selector(touchUp(sender:)), for: .touchCancel)
    }
    
    // MARK: ---- Layout ----
    
    override func layoutSubviews() {
        super.layoutSubviews()
        // 约束设置
        self.setStatus(nil)
    }
    
    /// 设置按钮状态，根据状态来更新UI
    func setStatus(_ status: BPButtonStatusEnum?) {
        if let _status = status {
            self.status = _status
        }
        switch self.status {
        case .normal:
            self.isEnabled     = true
            self.layer.opacity = normalOpacity
        case .touchDown:
            break
        case .disable:
            self.isEnabled     = false
            self.layer.opacity = disableOpacity
        }
    }
    
    // MARK: ---- Event ----
    private func bindProperty() {
        switch type {
        case .normal:
            self.setTitleColor(UIColor.black0)
        case .theme:
            self.setTitleColor(UIColor.white0)
            self.layer.cornerRadius  = self.size.height / 2
            self.layer.masksToBounds = true
            self.backgroundColor     = UIColor.gradientColor(with: self.size, colors: [UIColor.hex(0x6FBCFB).cgColor, UIColor.blue0.cgColor], direction: .vertical)
        case .second:
            self.setTitleColor(UIColor.white0)
            self.backgroundColor     = .blue0
            self.layer.cornerRadius  = AdaptSize(5)
            self.layer.masksToBounds = true
        }
    }
    
    func setTitleColor(_ color: UIColor?) {
        self.setTitleColor(color, for: .normal)
        self.setTitleColor(color, for: .highlighted)
    }
    
    @objc func touchDown(sender: UIButton) {
        self.isEnabled = true
        if type != .normal {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(0.7)
        }
        guard self.showAnimation else {
            return
        }
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values       = [0.9]
        animation.duration     = 0.1
        animation.autoreverses = false
        animation.fillMode     = .forwards
        animation.isRemovedOnCompletion = false
        sender.layer.add(animation, forKey: nil)
    }
    
    @objc func touchUp(sender: UIButton) {
        if type != .normal {
            self.backgroundColor = self.backgroundColor?.withAlphaComponent(1.0)
        }
        guard self.showAnimation else {
            return
        }
        let animation = CAKeyframeAnimation(keyPath: "transform.scale")
        animation.values       = [1.1, 0.95, 1.0]
        animation.duration     = 0.2
        animation.autoreverses = false
        animation.fillMode     = .forwards
        animation.isRemovedOnCompletion = false
        sender.layer.add(animation, forKey: nil)
    }
    
    //TODO: 自定义Storyboard编辑器
    @IBInspectable
    var cornerRadius: CGFloat = 0.0 {
        didSet {
            layer.cornerRadius  = cornerRadius
            layer.masksToBounds = cornerRadius > 0
        }
    }
    
    @IBInspectable
    var borderWidth: CGFloat = 0.0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable
    var borderColor: UIColor = .black {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }
}
