//
//  UITextView+Extension.swift
//  Tenant
//
//  Created by samsha on 2021/7/29.
//

import Foundation

public extension UITextView {
    /// 设置光标位置
    func setPosition(offset: Int) {
        // 先移到文首
        let begin = self.beginningOfDocument
        guard let start = self.position(from: begin, offset: 0) else { return }
        let startRange  = self.textRange(from: start, to: start)
        self.selectedTextRange = startRange
        // 移动到正确位置
        guard let selectedRange = self.selectedTextRange else { return }
        var currentOffset = self.offset(from: self.beginningOfDocument, to: selectedRange.start)
        currentOffset += offset
        guard let newPosition = self.position(from: self.beginningOfDocument, offset: currentOffset) else { return }
        self.selectedTextRange = self.textRange(from: newPosition, to: newPosition)
    }
    
    /// 获得光标位置
    func getPosition() -> Int {
        guard let range = self.selectedTextRange else {
            return self.text.count
        }
        let index = self.offset(from: self.beginningOfDocument, to: range.start)
        return index
    }
    
    /// 转换NSRange 到 UITextRange
    func transformRange(range: NSRange) -> UITextRange? {
        let beginning = self.beginningOfDocument
        guard let startPosition = self.position(from: beginning, offset: range.location), let endPosition = self.position(from: beginning, offset: range.location + range.length) else {
            return nil
        }
        let _textRange = self.textRange(from: startPosition, to: endPosition)
        return _textRange
    }
}
