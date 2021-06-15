//
//  BPLabel.swift
//  BaseProject
//
//  Created by 沙庭宇 on 2019/11/8.
//  Copyright © 2019 沙庭宇. All rights reserved.
//

import UIKit

public class BPLabel: UILabel {
    /// 内边距
    public var textInsets: UIEdgeInsets = .zero
    
    public override func drawText(in rect: CGRect) {
        super.drawText(in: rect.inset(by: textInsets))
    }
    
    public override func textRect(forBounds bounds: CGRect, limitedToNumberOfLines numberOfLines: Int) -> CGRect {
        let insets = textInsets
        var rect = super.textRect(forBounds: bounds.inset(by: insets),
                                  limitedToNumberOfLines: numberOfLines)
        
        rect.origin.x -= insets.left
        rect.origin.y -= insets.top
        rect.size.width += (insets.left + insets.right)
        rect.size.height += (insets.top + insets.bottom)
        return rect
    }
    
    /// 设置文本，指定行间距
    public func setText(text: String, line space: CGFloat) {
        self.text = text
        let style = NSMutableParagraphStyle()
        style.lineSpacing   = space
        style.lineBreakMode = self.lineBreakMode
        style.alignment     = self.textAlignment
        let attr = NSAttributedString(string: text, attributes: [NSAttributedString.Key.paragraphStyle : style])
        self.attributedText = attr
    }
}
