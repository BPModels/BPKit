//
//  BPStackView.swift
//  Tenant
//
//  Created by 沙庭宇 on 2021/1/28.
//

enum BPDirectionType: Int {
    case left
    case right
    case center
    case top
    case bottom
}

enum BPStackViewShadowType {
    /// 默认不增加阴影
    case normal
    /// 除了首张，都增加阴影
    case exceptFirst
}

import Foundation

class BPStackView: BPView {
    var offsetX: CGFloat = .zero
    var spacing: CGFloat
    var shadowType: BPStackViewShadowType = .normal
    private var type: BPDirectionType
    private var subviewList: [UIView]
    
    init(type: BPDirectionType = .center, subview list: [UIView] = [], spacing: CGFloat = .zero) {
        self.type         = type
        self.subviewList  = list
        self.spacing      = spacing
        super.init(frame: .zero)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        guard !subviewList.isEmpty else { return }
        self.setShadow()
        switch type {
            case .left:
                offsetX = 0
                for subview in subviewList {
                    self.addSubview(subview)
                    subview.snp.remakeConstraints { (make) in
                        make.left.equalToSuperview().offset(offsetX)
                        make.centerY.equalToSuperview()
                        make.size.equalTo(subview.size)
                    }
                    offsetX += (subview.width + spacing)
                }
            case .center:
                offsetX = 0
                var residueW = self.width
                subviewList.forEach { (subview) in
                    residueW -= subview.width
                }
                if spacing.isZero {
                    // 未设置间距
                    self.spacing = residueW / CGFloat(subviewList.count - 1)
                } else {
                    // 固定间距
                    residueW -= CGFloat(subviewList.count - 1) * spacing
                    offsetX = residueW / 2
                }
                for subview in subviewList {
                    self.addSubview(subview)
                    subview.snp.remakeConstraints { (make) in
                        make.left.equalToSuperview().offset(offsetX)
                        make.centerY.equalToSuperview()
                        make.size.equalTo(subview.size)
                    }
                    offsetX += (subview.width + spacing)
                }
            case .right:
                offsetX = 0
                let _subviewList = subviewList.reversed()
                for subview in _subviewList {
                    self.addSubview(subview)
                    subview.snp.remakeConstraints { (make) in
                        make.right.equalToSuperview().offset(offsetX)
                        make.centerY.equalToSuperview()
                        make.size.equalTo(subview.size)
                    }
                    offsetX -= (subview.width + spacing)
                }
            default:
                break
        }
    }
    
    // MARK: ==== Event ====
    func add(view: UIView) {
        self.subviewList.append(view)
        self.layoutSubviews()
    }
    
    func insert(view: UIView, index: Int) {
        if index < 0 {
            self.subviewList = [view] + subviewList
        } else if index >= subviewList.count {
            self.subviewList.append(view)
        } else {
            self.subviewList.insert(view, at: index)
        }
        self.layoutSubviews()
    }
    
    func remove(view: UIView) {
        for (index, subview) in subviewList.enumerated() {
            if subview == view {
                subview.removeFromSuperview()
                self.subviewList.remove(at: index)
                break
            }
        }
        self.layoutSubviews()
    }
    
    func removeAll() {
        self.subviewList.forEach { (subview) in
            subview.removeFromSuperview()
        }
        self.subviewList = []
    }
    
    // TODO: ==== Tools ====
    private func setShadow() {
        if shadowType == .exceptFirst {
            for index in 0..<self.subviews.count {
                if index > 0 {
                    self.subviews[index].layer.setDefaultShadow()
                }
            }
        }
    }
}
