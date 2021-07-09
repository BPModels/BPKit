//
//  UILabel+Extension.swift
//  BaseProject
//
//  Created by Fish Sha on 2020/10/22.
//  Copyright © 2020 沙庭宇. All rights reserved.
//

import UIKit

public extension UILabel {
    /// 根据字体和画布宽度,计算文字在画布上的高度
    /// - parameter font: 字体
    /// - parameter width: 限制的宽度
    func textHeight(width: CGFloat) -> CGFloat {
        guard let _text = self.text, let _font = self.font else { return .zero}
        let rect = NSString(string: _text).boundingRect(with: CGSize(width: width, height: CGFloat(MAXFLOAT)), options: .usesLineFragmentOrigin, attributes: [.font: _font], context: nil)
        return ceil(rect.height)
    }
    
    /// 设置左侧 icon
    /// - Parameter icon: 图片
    func setIcon(icon: UIImage?, iconSize: CGSize? = nil) {
        guard let _icon = icon else {
            return
        }
        let _iconSize = iconSize ?? CGSize(width: AdaptSize(7), height: AdaptSize(7))
        let attachment = NSTextAttachment()
        attachment.image = _icon
        let offsetY = font.lineHeight/2 - _iconSize.height
        attachment.bounds = CGRect(origin: CGPoint(x: 0, y: offsetY), size: _iconSize)
        let mAttr = NSMutableAttributedString(attachment: attachment)
        mAttr.append(NSAttributedString(string: " " + (self.text ?? "")))
        self.attributedText = mAttr
    }
    
    /// 设置显示必选图标
    func setRequiredIcon() {
        let icon = getImage(name: "bp_required_icon", type: "png")
        self.setIcon(icon: icon)
    }
}
